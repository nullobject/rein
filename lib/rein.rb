require 'active_support/core_ext/hash'

module Rein
  module Constraint
  end
end

RC = Rein::Constraint

require 'rein/constraint/foreign_key'
require 'rein/constraint/inclusion'
require 'rein/constraint/numericality'
require 'rein/version'

if defined?(ActiveRecord)
  module ActiveRecord::ConnectionAdapters
    class PostgreSQLAdapter < AbstractAdapter
      include RC::ForeignKey
      include RC::Inclusion
      include RC::Numericality
    end
  end
end
