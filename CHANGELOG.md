# Changelog

## 3.5.0 / 2018-05-09

  * Add support for ActiveRecord 5.2

## 3.4.0 / 2018-03-23

  * Wrap column and table names in foreign key constraints

## 3.3.0
- Add unique constraint.

## 3.2.0
- Add match constraint.
- Fix the rollback of change view migrations.

## 3.1.0
- Add length constraint.

## 3.0.0

- Dropped MySQL support.
- Reversible migrations.
- Add `index` option to `add_foreign_key_constraint`.

## 2.1.0

- Add `if` option to inclusion constraints.
- Add `name` option to constraints.
- Add null constraint.
- Ensure presence constraint enforces not null.

## 2.0.0

- Add support for enumerated types.
- Add `if` option to numericality constraints.
- Add `if` option to presence constraints.
- Fix a bug in presence contraints.

## 1.1.0

- Update README.
- Code cleanups.
- Disable monkey patching in rspec.

## 1.0.0

- Fix `Mysql2Adapter` for Rails 3.2.
- Add `column` option to `add_primary_key`.
