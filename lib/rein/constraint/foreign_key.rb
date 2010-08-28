module RC
  module ForeignKey
    def add_foreign_key_constraint(referencing_table, referenced_table, options = {})
      referencing_attribute = options[:referencing] || "#{referenced_table.to_s.singularize}_id"
      referenced_attribute  = "id"
      constraint_name       = options[:name] || "#{referencing_attribute}_fk"

      sql = "ALTER TABLE #{referencing_table} ADD CONSTRAINT #{constraint_name} FOREIGN KEY (#{referencing_attribute}) REFERENCES #{referenced_table} (#{referenced_attribute})"
      sql << " ON DELETE #{referential_action(options[:on_delete])}" if options[:on_delete]
      sql << " ON UPDATE #{referential_action(options[:on_update])}" if options[:on_update]

      execute(sql)
    end

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
  end
end
