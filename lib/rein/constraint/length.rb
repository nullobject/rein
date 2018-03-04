require 'rein/util'

module Rein
  module Constraint
    # This module contains methods for defining length constraints.
    module Length
      OPERATORS = {
        greater_than: :>,
        greater_than_or_equal_to: :>=,
        equal_to: :"=",
        not_equal_to: :"!=",
        less_than: :<,
        less_than_or_equal_to: :<=
      }.freeze

      def add_length_constraint(*args)
        reversible do |dir|
          dir.up do _add_length_constraint(*args) end
          dir.down { _remove_length_constraint(*args) }
        end
      end

      def remove_length_constraint(*args)
        reversible do |dir|
          dir.up do _remove_length_constraint(*args) end
          dir.down { _add_length_constraint(*args) }
        end
      end

      private

      def _add_length_constraint(table, attribute, options = {})
        name = Util.constraint_name(table, attribute, 'length', options)
        attribute = Util.attribute_name(attribute)
        attribute_length = "length(#{attribute})"
        conditions = OPERATORS.slice(*options.keys).map { |key, operator|
          value = options[key]
          [attribute_length, operator, value].join(' ')
        }.join(' AND ')
        conditions = Util.conditions_with_if(conditions, options)
        execute("ALTER TABLE #{table} ADD CONSTRAINT #{name} CHECK (#{conditions})")
      end

      def _remove_length_constraint(table, attribute, options = {})
        name = Util.constraint_name(table, attribute, 'length', options)
        execute("ALTER TABLE #{table} DROP CONSTRAINT #{name}")
      end
    end
  end
end
