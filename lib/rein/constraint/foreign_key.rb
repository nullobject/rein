module Rein
  module Constraint
    # This module contains methods for defining foreign key constraints.
    module ForeignKey
      def add_foreign_key_constraint(referencing_table, referenced_table, options = {})
        referencing_attribute = (options[:referencing] || "#{referenced_table.to_s.singularize}_id").to_sym
        referenced_attribute = (options[:referenced] || "id").to_sym

        name = options[:name] || default_constraint_name(referencing_table, referencing_attribute)

        sql = "ALTER TABLE #{referencing_table}"
        sql << " ADD CONSTRAINT #{name}"
        sql << " FOREIGN KEY (#{referencing_attribute})"
        sql << " REFERENCES #{referenced_table} (#{referenced_attribute})"
        sql << " ON DELETE #{referential_action(options[:on_delete])}" if options[:on_delete].present?
        sql << " ON UPDATE #{referential_action(options[:on_update])}" if options[:on_update].present?

        execute(sql)

        # A foreign key constraint doesn't have an implicit index.
        add_index(referencing_table, referencing_attribute) if options[:add_index] == true
      end
      alias add_foreign_key add_foreign_key_constraint

      def remove_foreign_key_constraint(referencing_table, referenced_table, options = {})
        referencing_attribute = options[:referencing] || "#{referenced_table.to_s.singularize}_id".to_sym

        name = options[:name] || default_constraint_name(referencing_table, referencing_attribute)

        if mysql_adapter?
          execute "ALTER TABLE #{referencing_table} DROP FOREIGN KEY #{name}"
        else
          execute "ALTER TABLE #{referencing_table} DROP CONSTRAINT #{name}"
        end

        # A foreign key constraint doesn't have an implicit index.
        remove_index(referencing_table, referencing_attribute) if options[:remove_index] == true
      end
      alias remove_foreign_key remove_foreign_key_constraint

      private

      def referential_action(action)
        case action.to_sym
        when :no_action then "NO ACTION"
        when :cascade then "CASCADE"
        when :restrict then "RESTRICT"
        when :set_null, :nullify then "SET NULL"
        when :set_default, :default then "SET DEFAULT"
        else
          raise "Unknown referential action '#{action}'"
        end
      end

      def mysql_adapter?
        self.class.to_s =~ /Mysql[2]?Adapter/
      end

      def default_constraint_name(referencing_table, referencing_attribute)
        "#{referencing_table}_#{referencing_attribute}_fk".to_sym
      end
    end
  end
end
