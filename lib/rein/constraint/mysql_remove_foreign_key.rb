module RC
  module MysqlRemoveForeignKey
    def remove_foreign_key_constraint(referencing_table, column_name)
      index_name = "#{column_name}_fk"
      execute "ALTER TABLE #{referencing_table} DROP FOREIGN KEY #{index_name}"
      remove_index :atc_applications, :name => index_name.to_s
    end

    alias_method :remove_foreign_key, :remove_foreign_key_constraint

  end
end
