module Rein
  # This module contains methods for creating/dropping views.
  module View
    def create_view(*args)
      reversible do |dir|
        dir.up { _create_view(*args) }
        dir.down { _drop_view(*args) }
      end
    end

    def drop_view(*args)
      reversible do |dir|
        dir.up { _drop_view(*args) }
        dir.down { _create_view(*args) }
      end
    end

    private

    def _create_view(view_name, sql)
      execute("CREATE VIEW #{view_name} AS #{sql}")
    end

    def _drop_view(view_name)
      execute("DROP VIEW #{view_name}")
    end
  end
end
