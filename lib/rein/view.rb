module Rein
  # This module contains methods for creating/dropping views.
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
