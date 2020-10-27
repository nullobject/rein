require 'rein/util'

module Rein
  module Constraint
    # This module contains methods for defining regex match constraints.
    module Match
      include ActiveRecord::ConnectionAdapters::Quoting

      OPERATORS = {
        accepts: :~,
        accepts_case_insensitive: :"~*",
        rejects: :"!~",
        rejects_case_insensitive: :"!~*"
      }.freeze

      def add_match_constraint(*args)
        reversible do |dir|
          dir.up { _add_match_constraint(*args) }
          dir.down { _remove_match_constraint(*args) }
        end
      end

      def remove_match_constraint(*args)
        reversible do |dir|
          dir.up { _remove_match_constraint(*args) }
          dir.down { _add_match_constraint(*args) }
        end
      end

      private

      def _add_match_constraint(table, attribute, options = {})
        name = Util.constraint_name(table, attribute, 'match', options)
        table = Util.wrap_identifier(table)
        attribute = Util.wrap_identifier(attribute)
        conditions = OPERATORS.slice(*options.keys).map do |key, operator|
          value = options[key]
          [attribute, operator, "'#{value}'"].join(' ')
        end.join(' AND ')
        conditions = Util.conditions_with_if(conditions, options)
        sql = "ALTER TABLE #{table} ADD CONSTRAINT #{name} CHECK (#{conditions})"
        execute(Util.add_not_valid_suffix_if_required(sql, options))
      end

      def _remove_match_constraint(table, attribute, options = {})
        name = Util.constraint_name(table, attribute, 'match', options)
        table = Util.wrap_identifier(table)
        execute("ALTER TABLE #{table} DROP CONSTRAINT #{name}")
      end
    end
  end
end
