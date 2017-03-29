require "active_record/connection_adapters/abstract/quoting"

module Rein
  module Constraint
    # This module contains methods for defining inclusion constraints.
    module Inclusion
      include ActiveRecord::ConnectionAdapters::Quoting
      include Rein::Constraint::Options

      def add_inclusion_constraint(table, attribute, options = {})
        name = constraint_name(table, attribute, options)
        values = options[:in].map { |value| quote(value) }.join(", ")
        conditions = conditions_with_if("#{attribute} IN (#{values})", options)
        execute("ALTER TABLE #{table} ADD CONSTRAINT #{name} CHECK (#{conditions})")
      end

      def remove_inclusion_constraint(table, attribute, options = {})
        name = constraint_name(table, attribute, options)
        execute("ALTER TABLE #{table} DROP CONSTRAINT #{name}")
      end
    end
  end
end
