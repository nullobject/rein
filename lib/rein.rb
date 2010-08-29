module Rein
  module Constraint
  end
end

RC = Rein::Constraint

require 'active_record'
require 'active_support/core_ext/hash'

require 'rein/constraint/foreign_key'
require 'rein/constraint/inclusion'
require 'rein/constraint/numericality'

module ActiveRecord::ConnectionAdapters
  class PostgreSQLAdapter < AbstractAdapter
    include RC::ForeignKey
    include RC::Inclusion
    include RC::Numericality
  end
end
