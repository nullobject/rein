module RC
  module Numericality
    OPERATORS = {
      :greater_than             => :>,
      :greater_than_or_equal_to => :>=,
      :equal_to                 => :==,
      :less_than                => :<,
      :less_than_or_equal_to    => :<=
    }.freeze

    def add_numericality_constraint(table, attribute, options)
      conditions = OPERATORS.slice(*options.keys).map do |key, operator|
        value = options[key]
        [attribute, operator, value].join(" ")
      end

      conditions_sql = conditions.map {|condition| "(#{condition})" }.join(" AND ")
      conditions_sql = "(#{conditions_sql})" if conditions.length > 1

      execute "ALTER TABLE #{table} ADD CONSTRAINT #{attribute} CHECK #{conditions_sql}"
    end
  end
end
