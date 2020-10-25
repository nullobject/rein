# Rein

[![Build Status](https://travis-ci.com/nullobject/rein.svg?branch=master)](https://travis-ci.com/nullobject/rein)

[Data integrity](http://en.wikipedia.org/wiki/Data_integrity) is a good thing.
Constraining the values allowed by your application at the database-level,
rather than at the application-level, is a more robust way of ensuring your
data stays sane.

Unfortunately, ActiveRecord doesn't encourage (or even allow) you to use
database integrity without resorting to hand-crafted SQL. Rein (pronounced
"rain") adds a handful of methods to your ActiveRecord migrations so that you
can easily tame the data in your database.

All methods in the DSL are automatically *reversible*, so you can take
advantage of reversible Rails migrations.

## Table of Contents

* [Getting Started](#getting-started)
* [Constraint Types](#constraint-types)
  * [Summary](#summary)
  * [Foreign Key Constraints](#foreign-key-constraints)
  * [Unique Constraints](#unique-constraints)
  * [Exclusion Constraints](#exclusion-constraints)
  * [Inclusion Constraints](#inclusion-constraints)
  * [Length Constraints](#length-constraints)
  * [Match Constraints](#match-constraints)
  * [Numericality Constraints](#numericality-constraints)
  * [Presence Constraints](#presence-constraints)
  * [Null Constraints](#null-constraints)
  * [Check Constraints](#check-constraints)
  * [Validate Constraints](#validate-constraints)
* [Data Types](#data-types)
  * [Enumerated Types](#enumerated-types)
* [Views](#views)
* [Schemas](#schemas)
* [Examples](#examples)
* [Contribute](#contribute)
* [License](#license)

## Getting Started

Install the gem:

```
> gem install rein
```

Add a constraint to your migrations:

```ruby
class CreateAuthorsTable < ActiveRecord::Migration
  def change
    create_table :authors do |t|
      t.string :name, null: false
    end

    # An author must have a name.
    add_presence_constraint :authors, :name
  end
end
```

## Constraint Types

### Summary

The table below summarises the constraint operations provided by Rein and whether they support [validation](#validate-constraints).

| Rein name   | Rein method | SQL | Supports `NOT VALID`? |
| ----------- | ----------- | --- | --------------------- |
| Foreign Key | `add_foreign_key_constraint` | `FOREIGN KEY` | yes |
| Unique | `add_unique_constraint` | `UNIQUE` | no |
| Exclusion | `add_exclusion_constraint` | `EXCLUDE` | no |
| Inclusion | `add_inclusion_constraint` | `CHECK` | yes |
| Length | `add_length_constraint` | `CHECK` | yes |
| Match | `add_match_constraint` | `CHECK` | yes |
| Numericality | `add_numericality_constraint` | `CHECK` | yes |
| Presence | `add_presence_constraint` | `CHECK` | yes |
| Null | `add_null_constraint` | `CHECK` | yes |
| Check | `add_check_constraint` | `CHECK` | yes |

### Foreign Key Constraints

A foreign key constraint specifies that the values in a column must match the
values appearing in some row of another table.

For example, let's say that we want to constrain the `author_id` column in the
`books` table to one of the `id` values in the `authors` table:

```ruby
add_foreign_key_constraint :books, :authors
```

Adding a foreign key doesn't automatically create an index on the referenced
column. Having an index will generally speed up any joins you perform on the
foreign key. To create an index you can specify the `index` option:

```ruby
add_foreign_key_constraint :books, :authors, index: true
```

Rein will automatically infer the column names for the tables, but if we need
to be explicit we can using the `referenced` and `referencing` options:

```ruby
add_foreign_key_constraint :books, :authors, referencing: :author_id, referenced: :id
```

We can also specify the behaviour when one of the referenced rows is updated or
deleted:

```ruby
add_foreign_key_constraint :books, :authors, on_delete: :cascade, on_update: :cascade
```

Here's all the options for specifying the delete/update behaviour:

- `no_action`: if any referencing rows still exist when the constraint is
  checked, an error is raised; this is the default behavior if you do not
  specify anything.
- `cascade`: when a referenced row is deleted, row(s) referencing it should be
  automatically deleted as well.
- `set_null`: sets the referencing columns to be nulls when the referenced row
  is deleted.
- `set_default`: sets the referencing columns to its default values when the
  referenced row is deleted.
- `restrict`: prevents deletion of a referenced row.

To remove a foreign key constraint:

```ruby
remove_foreign_key_constraint :books, :authors
```

### Unique Constraints

A unique constraint specifies that certain columns in a table must be unique.

For example, all the books should have unique ISBNs:

```ruby
add_unique_constraint :books, :isbn
```

By default, the database checks unique constraints immediately (i.e. as soon as
a record is created or updated). If a record with a duplicate value exists,
then the database will raise an error.

Sometimes it is necessary to wait until the end of a transaction to do the
checking (e.g. maybe you want to swap the ISBNs for two books). To do so, you
need to tell the database to *defer* checking the constraint until the end of
the current transaction:

```sql
BEGIN;
SET CONSTRAINTS books_isbn_unique DEFERRED;
UPDATE books SET isbn = 'foo' WHERE id = 1;
UPDATE books SET isbn = 'bar' WHERE id = 2;
COMMIT;
```

This [blog
post](https://hashrocket.com/blog/posts/deferring-database-constraints) offers
a good explanation of how to do this in a Rails app when using the
`acts_as_list` plugin.

If you *always* want to defer checking a unique constraint, then you can set
the `deferred` option to `true`:

```ruby
add_unique_constraint :books, :isbn, deferred: true
```

If you really don't want the ability to optionally defer a unique constraint in
a transaction, then you can set the `deferrable` option to `false`:

```ruby
add_unique_constraint :authors, :name, deferrable: false
```

### Exclusion Constraints

An exclusion constraint is a lot like a unique constraint, but more general.
Whereas a unique constraint forbids two rows from having all constrained
columns be *equal*, an exclusion constraint forbids two rows from having all
constrained columns be *some relationship*, where the relationship is up to you
(and can be different for each column).  For instance you can prevent two
ranges from overlapping with the `&&` operator.  You can read more in [the
Postgres
docs](https://www.postgresql.org/docs/9.0/static/ddl-constraints.html#DDL-CONSTRAINTS-EXCLUSION)
or [a slideshow by the author, Jeff
Davis](https://www.slideshare.net/pgconf/not-just-unique-exclusion-constraints).

For example, no two people should own copyright to a book at the same time:

```ruby
add_exclusion_constraint :book_owners, [[:book_id, '='], [:owned_during, '&&']], using: :gist
```

By default, the database checks exclusion constraints immediately (i.e. as soon
as a record is created or updated). If a record with an excluded value exists,
then the database will raise an error.

Sometimes it is necessary to wait until the end of a transaction to do the
checking (e.g. maybe you want to move the date a copyright changed hands). To
do so, you need to tell the database to *defer* checking the constraint until
the end of the current transaction:

```sql
BEGIN;
SET CONSTRAINTS book_owners_exclude DEFERRED;
UPDATE book_owners
  SET owned_during = tsrange(lower(owned_during), '1943-12-22')
  WHERE book_id = 1 AND owner_id = 1;
UPDATE book_owners
  SET owned_during = tsrange('1943-12-22', upper(owned_during))
  WHERE book_id = 1 AND owner_id = 2;
COMMIT;
```

If you *always* want to defer checking a unique constraint, then you can set
the `deferred` option to `true`:

```ruby
add_exclusion_constraint :book_owners, [[:book_id, '='], [:owned_during, '&&']], using: :gist, deferred: true
```

If you really don't want the ability to optionally defer a unique constraint in
a transaction, then you can set the `deferrable` option to `false`:

```ruby
add_exclusion_constraint :book_owners, [[:book_id, '='], [:owned_during, '&&']], using: :gist, deferrable: false
```

If you want to specify something like a operator class for a attribute specific
attribute, you can add it to the attribute specification between attribute name
and the operator:

```ruby
add_exclusion_constraint :book_owners, [[:book_id, :gist_int8_ops, '='], [:owned_during, '&&']], using: :gist
```

If you want to set the constraint to a subset of the table, you can use a `where`
option to set the filter condition:

```ruby
add_exclusion_constraint :books, [[:isbn, '=']], using: :gist, where: "state='active'"
```

### Inclusion Constraints

An inclusion constraint specifies the possible values that a column value can
take.

For example, we can ensure that `state` column values can only ever be
`available` or `on_loan`:

```ruby
add_inclusion_constraint :books, :state, in: %w[available on_loan]
```

To remove an inclusion constraint:

```ruby
remove_inclusion_constraint :books, :state
```

You may also include an `if` option to enforce the constraint only under
certain conditions, like so:

```ruby
add_inclusion_constraint :books, :state,
  in: %w[available on_loan],
  if: "deleted_at IS NULL"
```

You may optionally provide a `name` option to customize the name:

```ruby
add_inclusion_constraint :books, :state,
  in: %w[available on_loan],
  name: "books_state_is_valid"
```

### Length Constraints

A length constraint specifies the range of values that the length of a string
column value can take.

For example, we can ensure that the `call_number` can only ever be a
value between 1 and 255:

```ruby
add_length_constraint :books, :call_number,
  greater_than_or_equal_to: 1,
  less_than_or_equal_to: 255
```

Here's all the options for constraining the values:

- `equal_to`
- `not_equal_to`
- `less_than`
- `less_than_or_equal_to`
- `greater_than`
- `greater_than_or_equal_to`

You may also include an `if` option to enforce the constraint only under
certain conditions, like so:

```ruby
add_length_constraint :books, :call_number,
  greater_than_or_equal_to: 1,
  less_than_or_equal_to: 12,
  if: "status = 'published'"
```

You may optionally provide a `name` option to customize the name:

```ruby
add_length_constraint :books, :call_number,
  greater_than_or_equal_to: 1,
  less_than_or_equal_to: 12,
  name: "books_call_number_is_valid"
```

To remove a length constraint:

```ruby
remove_length_constraint :books, :call_number
```

### Match Constraints

A match constraint ensures that a string column value matches (or does not match)
a POSIX-style regular expression.

For example, we can ensure that the `title` can only contain printable ASCII
characters, but not ampersands:

```ruby
add_match_constraint :books, :title, accepts: '\A[ -~]*\Z', rejects: '&'
```

Match constraints are case-sensitive. You make them case-insensitive by using 
`accepts_case_insensitive` and `rejects_case_insensitive` instead of `accepts` 
or `rejects`.

If you only want to enforce the constraint under certain conditions,
you can pass an optional `if` option:

```ruby
add_match_constraint :books, :title, accepts: '\A[ -~]*\Z', if: "status = 'published'"
```

You may optionally provide a `name` option to customize the name:

```ruby
add_match_constraint :books, :title, name: "books_title_is_valid"
```

To remove a match constraint:

```ruby
remove_match_constraint :books, :title
```

### Numericality Constraints

A numericality constraint specifies the range of values that a numeric column
value can take.

For example, we can ensure that the `publication_month` can only ever be a
value between 1 and 12:

```ruby
add_numericality_constraint :books, :publication_month,
  greater_than_or_equal_to: 1,
  less_than_or_equal_to: 12
```

Here's all the options for constraining the values:

- `equal_to`
- `not_equal_to`
- `less_than`
- `less_than_or_equal_to`
- `greater_than`
- `greater_than_or_equal_to`

You may also include an `if` option to enforce the constraint only under
certain conditions, like so:

```ruby
add_numericality_constraint :books, :publication_month,
  greater_than_or_equal_to: 1,
  less_than_or_equal_to: 12,
  if: "status = 'published'"
```

You may optionally provide a `name` option to customize the name:

```ruby
add_numericality_constraint :books, :publication_month,
  greater_than_or_equal_to: 1,
  less_than_or_equal_to: 12,
  name: "books_publication_month_is_valid"
```

To remove a numericality constraint:

```ruby
remove_numericality_constraint :books, :publication_month
```

### Presence Constraints

A presence constraint ensures that a string column value is non-empty.

A `NOT NULL` constraint will be satisfied by an empty string, but sometimes you
may want to ensure that there is an actual value for a string:

```ruby
add_presence_constraint :books, :title
```

If you only want to enforce the constraint under certain conditions,
you can pass an optional `if` option:

```ruby
add_presence_constraint :books, :isbn, if: "status = 'published'"
```

You may optionally provide a `name` option to customize the name:

```ruby
add_presence_constraint :books, :isbn, name: "books_isbn_is_valid"
```

To remove a presence constraint:

```ruby
remove_presence_constraint :books, :title
```

### Null Constraints

A null constraint ensures that a column does *not* contain a null value. This
is the same as adding `NOT NULL` to a column, the difference being that it can
be _applied conditionally_.

For example, we can add a constraint to enforce that a book has a `due_date`,
but only if it's `on_loan`:

```ruby
add_null_constraint :books, :due_date, if: "state = 'on_loan'"
```

To remove a null constraint:

```ruby
remove_null_constraint :books, :due_date
```

### Check Constraints

A check constraint lets you enforce any predicate about the current row.
You can use this if none of the other higher-level constraint types work for you.

For example, we can add a constraint to enforce that a book's title
never starts with an "r":

```ruby
add_check_constraint :books, "substring(title FROM 1 FOR 1) IS DISTINCT FROM 'r'", name: 'no_r_titles'
```

Note these types must have a `name` option.

To remove a check constraint:

```ruby
remove_check_constraint :books, "substring(title FROM 1 FOR 1) IS DISTINCT FROM 'r'", name: 'no_r_titles'
```

### Validate Constraints

Adding a constraint can be a very costly operation, especially on larger tables, as the database has to scan all rows in the table to check for violations of the new constraint. During this time, concurrent writes are blocked as an [`ACCESS EXCLUSIVE`](https://www.postgresql.org/docs/current/explicit-locking.html#LOCKING-TABLES) table lock is taken. In addition, adding a foreign key constraint obtains a `SHARE ROW EXCLUSIVE` lock on the referenced table. See the [docs](https://www.postgresql.org/docs/current/sql-altertable.html#SQL-ALTERTABLE-NOTES) for more details.

In order to allow constraints to be added concurrently on larger tables, and to allow the addition of constraints on tables containing rows with existing violations, Postgres supports adding constraints using the `NOT VALID` option (currently only for `CHECK` and foreign key constraints).

This allows the constraint to be added immediately, without validating existing rows, but enforcing the constraint for any new rows and updates. After that, a `VALIDATE CONSTRAINT` command can be issued to verify that existing rows satisfy the constraint, which is done in a way that does not lock out concurrent updates and "with the least impact on other work".

Rein supports adding `CHECK` and foreign key constraints with the `NOT VALID` option by passing `validate: false` to the options of the supported Rein DSL methods, [summarised above](#summary).

```ruby
add_null_constraint :books, :due_date, if: "state = 'on_loan'", validate: false
```

With Rails 5.2 or later, you can use [`validate_constraint`](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/PostgreSQL/SchemaStatements.html#method-i-validate_constraint) in a subsequent migration to validate a `NOT VALID` constraint. If you are using versions of Rails below 5.2, you can use Rein's `validate_table_constraint` method:

```ruby
validate_table_constraint :books, "no_r_titles"
```

It's safe (a no-op) to validate a constraint that is already marked as valid.

### Side note on `lock_timeout`

It's advisable to set a [sensibly low `lock_timeout`](https://gocardless.com/blog/zero-downtime-postgres-migrations-the-hard-parts/) in your database migrations, otherwise existing long-running transactions can prevent your migration from acquiring the required locks, resulting in a lock queue that prevents even selects on the target table, potentially bringing your production database grinding to a halt.

## Data Types

### Enumerated Types

An enum is a data type that represents a static, ordered set of values.

```ruby
create_enum_type :book_type, %w[paperback hardcover]
```

To drop an enum type from the database:

```ruby
drop_enum_type :book_type
```

## Views

A view is a named query that you can refer to just like an ordinary table. You
can even create ActiveRecord models that are backed by views in your database.

For example, we can define an `available_books` view that returns only the
books which are currently available:

```ruby
create_view :available_books, "SELECT * FROM books WHERE state = 'available'"
```

To drop a view from the database:

```ruby
drop_view :available_books
```

## Schemas

A database can contain one or more named schemas, which in turn contain tables.
Sometimes it might be helpful to split your database into multiple schemas to
logically group tables together.

```ruby
create_schema :archive
```

To drop a schema from the database:

```ruby
drop_schema :archive
```

## Examples

Let's have a look at some example migrations to constrain database values for
our simple library application:

```ruby
class CreateAuthorsTable < ActiveRecord::Migration
  def change
    # The authors table contains all the authors of the books in the library.
    create_table :authors do |t|
      t.string :name, null: false
      t.timestamps, null: false
    end

    # An author must have a name.
    add_presence_constraint :authors, :name
  end
end

class CreateBooksTable < ActiveRecord::Migration
  def change
    # The books table contains all the books in the library, and their state
    # (i.e. whether they are on loan or available).
    create_table :books do |t|
      t.belongs_to :author, null: false
      t.string :title, null: false
      t.string :state, null: false
      t.integer :published_year, null: false
      t.integer :published_month, null: false
      t.date :due_date
      t.timestamps, null: false
    end

    # A book should always belong to an author. The database should
    # automatically delete an author's books when we delete an author.
    add_foreign_key_constraint :books, :authors, on_delete: :cascade

    # A book must have a non-empty title.
    add_presence_constraint :books, :title

    # State is always either "available", "on_loan", or "on_hold".
    add_inclusion_constraint :books, :state, in: %w[available on_loan on_hold]

    # Our library doesn't deal in classics.
    add_numericality_constraint :books, :published_year,
      greater_than_or_equal_to: 1980

    # Month is always between 1 and 12.
    add_numericality_constraint :books, :published_month,
      greater_than_or_equal_to: 1,
      less_than_or_equal_to: 12

    # A book has a due date if it is on loan.
    add_null_constraint :books, :due_date, if: "state = 'on_loan'"
  end
end

class CreateArchivedBooksTable < ActiveRecord::Migration
  def change
    # The archive schema contains all of the archived data. We want to keep
    # this separate from the public schema.
    create_schema :archive

    # The archive.books table contains all the achived books.
    create_table "archive.books" do |t|
      t.belongs_to :author, null: false
      t.string :title, null: false
    end

    # A book should always belong to an author. The database should prevent us
    # from deleteing an author who has books.
    add_foreign_key_constraint "archive.books", :authors, on_delete: :restrict

    # A book must have a non-empty title.
    add_presence_constraint "archive.books", :title
  end
end
```

## Contribute

PRs are always welcome! :heart: To work with rein, there is a
[Makefile](https://en.wikipedia.org/wiki/Makefile) to keep things simple.

Before you do anything, you'll need to bootstrap your environment:

    make config

Make sure you run the tests before submitting a PR:

    make test

## License

Rein is licensed under the [MIT License](/LICENSE.md).
