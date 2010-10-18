module Rein
  module View
    def create_view(view_name, sql)
      sql = "CREATE VIEW #{view_name} AS #{sql}"
      execute(sql)
    end

    def drop_view(view_name)
      sql = "DROP VIEW #{view_name}"
      execute(sql)
    end
  end
end
