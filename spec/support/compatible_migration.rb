# Support the new rails 5 migration syntax, while retaining backwards
# compatibility with the old sytax
migration_class =
  if ActiveRecord::VERSION::STRING >= "5.0.0"
    ActiveRecord::Migration[
      "#{ActiveRecord::VERSION::MAJOR}.#{ActiveRecord::VERSION::MINOR}"]
  else
    ActiveRecord::Migration
  end

class CompatibleMigration < migration_class
end
