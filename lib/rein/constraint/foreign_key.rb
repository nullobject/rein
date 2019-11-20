require 'active_support/inflector'
require 'rein/util'

module Rein
  module Constraint
    # This module contains methods for defining foreign key constraints.
    module ForeignKey
      def add_foreign_key_constraint(*args)
        reversible do |dir|
          dir.up { _add_foreign_key_constraint(*args) }
          dir.down { _remove_foreign_key_constraint(*args) }
        end
      end

      def remove_foreign_key_constraint(*args)
        reversible do |dir|
          dir.up { _remove_foreign_key_constraint(*args) }
          dir.down { _add_foreign_key_constraint(*args) }
        end
      end

      private

      def _add_foreign_key_constraint(referencing_table, referenced_table, options = {})
        referencing_attribute = (options[:referencing] || "#{referenced_table.to_s.singularize}_id").to_sym
        referenced_attribute = (options[:referenced] || 'id').to_sym
        name = Util.constraint_name(referencing_table, referencing_attribute, 'fk', options)
        sql = "ALTER TABLE #{Util.wrap_identifier(referencing_table)}"
        sql << " ADD CONSTRAINT #{name}"
        sql << " FOREIGN KEY (#{Util.wrap_identifier(referencing_attribute)})"
        sql << " REFERENCES #{referenced_table} (#{Util.wrap_identifier(referenced_attribute)})"
        sql << " ON DELETE #{referential_action(options[:on_delete])}" if options[:on_delete].present?
        sql << " ON UPDATE #{referential_action(options[:on_update])}" if options[:on_update].present?
        execute(Util.add_not_valid_suffix_if_required(sql, options))
        add_index(referencing_table, referencing_attribute) if options[:index] == true
      end

      def _remove_foreign_key_constraint(referencing_table, referenced_table, options = {})
        referencing_attribute = options[:referencing] || "#{referenced_table.to_s.singularize}_id".to_sym
        name = Util.constraint_name(referencing_table, referencing_attribute, 'fk', options)
        execute("ALTER TABLE #{Util.wrap_identifier(referencing_table)} DROP CONSTRAINT #{name}")
        remove_index(referencing_table, referencing_attribute) if options[:index] == true
      end

      def referential_action(action)
        case action.to_sym
        when :no_action then 'NO ACTION'
        when :cascade then 'CASCADE'
        when :restrict then 'RESTRICT'
        when :set_null, :nullify then 'SET NULL'
        when :set_default, :default then 'SET DEFAULT'
        else raise "Unknown referential action '#{action}'"
        end
      end

      def default_constraint_name(referencing_table, referencing_attribute)
        "#{referencing_table}_#{referencing_attribute}_fk".to_sym
      end
    end
  end
end
