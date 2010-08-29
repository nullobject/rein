require 'active_record/connection_adapters/abstract/quoting'

module RC
  module Inclusion
    include ActiveRecord::ConnectionAdapters::Quoting

    def add_inclusion_constraint(table, attribute, options = {})
      name       = "#{table}_#{attribute}"
      values     = options[:in].map {|value| quote(value) }.join(", ")
      conditions = "#{attribute} IN (#{values})"
      execute("ALTER TABLE #{table} ADD CONSTRAINT #{name} CHECK (#{conditions})")
    end
  end
end
