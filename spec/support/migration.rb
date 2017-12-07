# Support the new rails 5 migration syntax, while retaining backwards
# compatibility with the old sytax.
Migration = # rubocop:disable Naming/ConstantName
  if ActiveRecord::VERSION::STRING >= '5.0.0'
    ActiveRecord::Migration["#{ActiveRecord::VERSION::MAJOR}.#{ActiveRecord::VERSION::MINOR}"]
  else
    ActiveRecord::Migration
  end
