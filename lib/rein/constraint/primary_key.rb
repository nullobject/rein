module Rein
  module Constraint
    # This module contains methods for defining primary key constraints.
    module PrimaryKey
      def add_primary_key(table, options = {})
        attribute = (options[:column] || "id").to_sym
        sql = "ALTER TABLE #{table} ADD PRIMARY KEY (#{attribute})"
        execute(sql)
      end
    end
  end
end
