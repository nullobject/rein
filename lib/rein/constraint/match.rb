require 'rein/util'

module Rein
  module Constraint
    # This module contains methods for defining regex match constraints.
    module Match
      include ActiveRecord::ConnectionAdapters::Quoting

      OPERATORS = {
        accepts: :~,
        rejects: :"!~"
      }.freeze

      def add_match_constraint(*args)
        reversible do |dir|
          dir.up do _add_match_constraint(*args) end
          dir.down { _remove_match_constraint(*args) }
        end
      end

      def remove_match_constraint(*args)
        reversible do |dir|
          dir.up do _remove_match_constraint(*args) end
          dir.down { _add_match_constraint(*args) }
        end
      end

      private

      def _add_match_constraint(table, attribute, options = {})
        name = Util.constraint_name(table, attribute, 'match', options)
        attribute = Util.wrap_identifier(attribute)
        conditions = OPERATORS.slice(*options.keys).map { |key, operator|
          value = options[key]
          [attribute, operator, "'#{value}'"].join(' ')
        }.join(' AND ')
        conditions = Util.conditions_with_if(conditions, options)
        execute("ALTER TABLE #{table} ADD CONSTRAINT #{name} CHECK (#{conditions})")
      end

      def _remove_match_constraint(table, attribute, options = {})
        name = Util.constraint_name(table, attribute, 'match', options)
        execute("ALTER TABLE #{table} DROP CONSTRAINT #{name}")
      end
    end
  end
end
