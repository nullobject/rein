module Rein
  # This module contains methods for creating/dropping schemas.
  module Schema
    def create_schema(name)
      sql = "CREATE SCHEMA #{name}"
      execute(sql)
    end

    def drop_schema(name)
      sql = "DROP SCHEMA #{name}"
      execute(sql)
    end
  end
end
