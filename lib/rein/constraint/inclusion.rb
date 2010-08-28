module RC
  module Inclusion
    def add_inclusion_constraint(table, attribute, options = {})
      name       = "#{table}_#{attribute}"
      values     = options[:in].map {|x| "'#{x}'" }.join(", ")
      conditions = "#{attribute} IN (#{values})"

      execute("ALTER TABLE #{table} ADD CONSTRAINT #{name} CHECK (#{conditions})")
    end
  end
end
