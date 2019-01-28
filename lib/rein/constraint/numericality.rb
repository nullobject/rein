require 'rein/util'

module Rein
  module Constraint
    # This module contains methods for defining numericality constraints.
    module Numericality
      OPERATORS = {
        greater_than: :>,
        greater_than_or_equal_to: :>=,
        equal_to: :"=",
        not_equal_to: :"!=",
        less_than: :<,
        less_than_or_equal_to: :<=
      }.freeze

      def add_numericality_constraint(*args)
        reversible do |dir|
          dir.up { _add_numericality_constraint(*args) }
          dir.down { _remove_numericality_constraint(*args) }
        end
      end

      def remove_numericality_constraint(*args)
        reversible do |dir|
          dir.up { _remove_numericality_constraint(*args) }
          dir.down { _add_numericality_constraint(*args) }
        end
      end

      private

      def _add_numericality_constraint(table, attribute, options = {})
        name = Util.constraint_name(table, attribute, 'numericality', options)
        table = Util.wrap_identifier(table)
        attribute = Util.wrap_identifier(attribute)
        conditions = OPERATORS.slice(*options.keys).map do |key, operator|
          value = options[key]
          [attribute, operator, value].join(' ')
        end.join(' AND ')
        conditions = Util.conditions_with_if(conditions, options)
        execute("ALTER TABLE #{table} ADD CONSTRAINT #{name} CHECK (#{conditions})")
      end

      def _remove_numericality_constraint(table, attribute, options = {})
        name = Util.constraint_name(table, attribute, 'numericality', options)
        table = Util.wrap_identifier(table)
        execute("ALTER TABLE #{table} DROP CONSTRAINT #{name}")
      end
    end
  end
end
