module RC
  module ForeignKey
    def add_foreign_key_constraint(referencing_table, referenced_table, options = {})
      referencing_attribute = (options[:referencing] || "#{referenced_table.to_s.singularize}_id").to_sym
      referenced_attribute  = (options[:referenced] || "id").to_sym

      name = (options[:name] || "#{referencing_attribute}_fk").to_sym

      sql = "ALTER TABLE #{referencing_table}".tap do |sql|
        sql << " ADD CONSTRAINT #{name}"
        sql << " FOREIGN KEY (#{referencing_attribute})"
        sql << " REFERENCES #{referenced_table} (#{referenced_attribute})"
        sql << " ON DELETE #{referential_action(options[:on_delete] || :restrict)}"
        sql << " ON UPDATE #{referential_action(options[:on_update] || :restrict)}"
      end

      execute(sql)

      # A foreign key constraint doesn't have an implicit index.
      add_index(referencing_table, referencing_attribute) if options[:add_index] == true
    end
    alias_method :add_foreign_key, :add_foreign_key_constraint

    def remove_foreign_key_constraint(referencing_table, referenced_table, options = {})
      referencing_attribute = options[:referencing] || "#{referenced_table.to_s.singularize}_id".to_sym

      name = options[:name] || "#{referencing_attribute}_fk".to_sym

      if is_a_mysql_adapter?
        execute "ALTER TABLE #{referencing_table} DROP FOREIGN KEY #{name}"
      else
        execute "ALTER TABLE #{referencing_table} DROP CONSTRAINT #{name}"
      end

      # A foreign key constraint doesn't have an implicit index.
      remove_index(referencing_table, referencing_attribute) if options[:remove_index] == true
    end
    alias_method :remove_foreign_key, :remove_foreign_key_constraint

  private
    def referential_action(action)
      case action.to_sym
      when :cascade
        "CASCADE"
      when :restrict
        "RESTRICT"
      when :nullify
        "SET NULL"
      when :default
        "SET DEFAULT"
      else
        raise "Unknown referential action '#{action}'"
      end
    end

    def is_a_mysql_adapter?
      self.class.to_s =~ /Mysql[2]?Adapter/
    end
  end
end
