require 'rein/util'

module Rein
  module Constraint
    # This module contains methods for defining exclusion constraints.
    module Exclusion
      include ActiveRecord::ConnectionAdapters::Quoting

      def add_exclusion_constraint(*args)
        reversible do |dir|
          dir.up { _add_exclusion_constraint_adapter(*args) }
          dir.down { _remove_exclusion_constraint_adapter(*args) }
        end
      end

      def remove_exclusion_constraint(*args)
        reversible do |dir|
          dir.up { _remove_exclusion_constraint_adapter(*args) }
          dir.down { _add_exclusion_constraint_adapter(*args) }
        end
      end

      private

      def _add_exclusion_constraint_adapter(*args)
        if args[1].is_a? Array
          _add_exclusion_constraint(*args)
        else
          _add_exclusion_constraint(args[0], [[args[1], args[2]]], args[3] || {})
        end
      end

      def _remove_exclusion_constraint_adapter(*args)
        if args[1].is_a? Array
          _remove_exclusion_constraint(*args)
        else
          _remove_exclusion_constraint(args[0], [[args[1], args[2]]], args[3] || {})
        end
      end

      def _add_exclusion_constraint(table, attributes, options = {})
        name = Util.constraint_name(table, attributes.map { |att| att[0] }.join('_'), 'exclude', options)
        table = Util.wrap_identifier(table)
        attributes = attributes.map do |attribute|
          _get_attribute_expression(attribute)
        end
        initially = options[:deferred] ? 'DEFERRED' : 'IMMEDIATE'
        using = options[:using] ? " USING #{options[:using]}" : ''
        sql = "ALTER TABLE #{table} ADD CONSTRAINT #{name} EXCLUDE#{using} (#{attributes.join(', ')})"
        sql << " WHERE (#{options[:where]})" if options[:where].present?
        sql << " DEFERRABLE INITIALLY #{initially}" unless options[:deferrable] == false
        execute(sql)
      end

      def _get_attribute_expression(attribute)
        if attribute.size > 2
          "#{Util.wrap_identifier(attribute[0])} #{attribute[1, attribute.size - 2].join(' ')} WITH #{attribute.last}"
        else
          "#{Util.wrap_identifier(attribute[0])} WITH #{attribute[1]}"
        end
      end

      def _remove_exclusion_constraint(table, attributes, options = {})
        name = Util.constraint_name(table, attributes.map { |att| att[0] }.join('_'), 'exclude', options)
        table = Util.wrap_identifier(table)
        execute("ALTER TABLE #{table} DROP CONSTRAINT #{name}")
      end
    end
  end
end
