module RC
  module Numericality
    OPERATORS = {
      :greater_than             => :>,
      :greater_than_or_equal_to => :>=,
      :equal_to                 => :==,
      :less_than                => :<,
      :less_than_or_equal_to    => :<=
    }.freeze

    def add_numericality_constraint(table, attribute, options = {})
      conditions = OPERATORS.slice(*options.keys).map do |key, operator|
        value = options[key]
        [attribute, operator, value].join(" ")
      end

      conditions = conditions.join(" AND ")

      execute "ALTER TABLE #{table} ADD CONSTRAINT #{attribute} CHECK (#{conditions})"
    end
  end
end
