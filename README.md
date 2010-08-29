# Rein

Database constraints made easy for ActiveRecord. Rein currently supports PostgreSQL and MySQL (foreign keys only) for both Rails 2 & 3.


## Introduction

[Database integrity](http://en.wikipedia.org/wiki/Database_integrity) is a "good thing". Constraining the allowed values in your database at the database-level (rather than solely at the application-level) is a much more robust way of ensuring your data stays sane.

Unfortunately, ActiveRecord doesn't encourage (or even allow) you to use database integrity without resorting to hand-crafted SQL. Rein adds a handful of methods to your ActiveRecord migrations so that you can easily tame your database.


## FAQ

### How is Rein different to other gems like [foreigner](http://github.com/matthuhiggins/foreigner) or [redhillonrails](http://github.com/mlomnicki/redhillonrails_core), which do the same thing?

If you're using MySQL then there is no difference, Rein should work as a drop-in replacement. If you're using PostgreSQL however, then Rein provides you with extra methods for placing check constraints on your data.

### If [DHH](http://en.wikipedia.org/wiki/David_Heinemeier_Hansson) wanted my app to have database constraints then Rails would have been born with them?

Rails is an opinionated piece of software. One opinion is that your database should simply function as a "dumb" container which your application controls. This is the opinion of Rails.

Another opinion is that your database is actually a powerful [DBMS](http://en.wikipedia.org/wiki/Database_management_system) which has already solved problems like data integrity, and your application should wield this power.


## Quick Start

Install the gem:

    gem install rein

Add a foreign key constraint:

    add_foreign_key_constraint :books, :authors

Add a numericality constraint (PostgreSQL only):

    add_numericality_constraint :books, :publication_month, :greater_than_or_equal_to => 1, :less_than_or_equal_to => 12

Add an inclusion constraint (PostgreSQL only):

    add_inclusion_constraint :books, :state, :in => %w(available on_loan)


## Example

Let's look at constraining values for this simple library application.

Here we have a table of authors:

    create_table :authors do |t|
      t.string :name, :null => false

      t.timestamps
    end

And here we have a table of books:

    create_table :books do |t|
      t.belongs_to :author,          :null => false
      t.string     :name,            :null => false
      t.string     :state,           :null => false
      t.integer    :published_year,  :null => false
      t.integer    :published_month, :null => false

      t.timestamps
    end

    # A book should always belong to an author.
    # The database should prevent us from deleteing an author who has books.
    add_foreign_key_constraint :books, :authors, :on_delete => :restrict

    # Our library doesn't deal in classics.
    add_numericality_constraint :books, :published_year, :greater_than => 1980

    # Month is always between 1 and 12.
    add_numericality_constraint :books, :published_month, :greater_than_or_equal_to => 1, :less_than_or_equal_to => 12

    # State is always either "available" or "on_loan".
    add_inclusion_constraint :books, :state, :in => %w(available on_loan)


## Credits

* [Marcus Crafter](http://github.com/crafterm) for persevering when I recommended [foreigner](http://github.com/matthuhiggins/foreigner).
* [Xavier Shay](http://github.com/xaviershay) for reminding me that that [your database is your friend](http://www.dbisyourfriend.com/).
