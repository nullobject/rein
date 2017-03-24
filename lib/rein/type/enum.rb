require "active_record/connection_adapters/abstract/quoting"

module Rein
  module Type
    # This module contains methods for defining enum types.
    module Enum
      include ActiveRecord::ConnectionAdapters::Quoting

      def add_enum(enum_name, enum_values = [])
        enum_values = enum_values.map { |value| quote(value) }.join(", ")
        execute("CREATE TYPE #{enum_name} AS ENUM (#{enum_values})")
      end

      def remove_enum(enum_name)
        execute("DROP TYPE #{enum_name}")
      end
    end
  end
end
