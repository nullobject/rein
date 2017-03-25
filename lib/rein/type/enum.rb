require "active_record/connection_adapters/abstract/quoting"

module Rein
  module Type
    # This module contains methods for defining enum types.
    module Enum
      include ActiveRecord::ConnectionAdapters::Quoting

      def create_enum_type(enum_name, enum_values = [])
        enum_values = enum_values.map { |value| quote(value) }.join(", ")
        execute("CREATE TYPE #{enum_name} AS ENUM (#{enum_values})")
      end

      def drop_enum_type(enum_name)
        execute("DROP TYPE #{enum_name}")
      end

      def add_enum_value(enum_name, new_value)
        execute("ALTER TYPE #{enum_name} ADD VALUE #{quote(new_value)}")
      end
    end
  end
end
