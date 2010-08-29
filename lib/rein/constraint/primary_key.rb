module RC
  module PrimaryKey
    def add_primary_key(table, options = {})
      attribute = "id".to_sym
      sql = "ALTER TABLE #{table} ADD PRIMARY KEY (#{attribute})"
      execute(sql)
    end
  end
end
