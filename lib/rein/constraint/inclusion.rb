require 'rein/util'

module Rein
  module Constraint
    # This module contains methods for defining inclusion constraints.
    module Inclusion
      include ActiveRecord::ConnectionAdapters::Quoting

      def add_inclusion_constraint(*args)
        reversible do |dir|
          dir.up do _add_inclusion_constraint(*args) end
          dir.down { _remove_inclusion_constraint(*args) }
        end
      end

      def remove_inclusion_constraint(*args)
        reversible do |dir|
          dir.up do _remove_inclusion_constraint(*args) end
          dir.down { _add_inclusion_constraint(*args) }
        end
      end

      private

      def _add_inclusion_constraint(table, attribute, options = {})
        name = Rein::Util.constraint_name(table, attribute, 'inclusion', options)
        values = options[:in].map { |value| quote(value) }.join(', ')
        attribute = Rein::Util.wrap_identifier(attribute)
        conditions = Rein::Util.conditions_with_if("#{attribute} IN (#{values})", options)
        execute("ALTER TABLE #{table} ADD CONSTRAINT #{name} CHECK (#{conditions})")
      end

      def _remove_inclusion_constraint(table, attribute, options = {})
        name = Rein::Util.constraint_name(table, attribute, 'inclusion', options)
        execute("ALTER TABLE #{table} DROP CONSTRAINT #{name}")
      end
    end
  end
end
