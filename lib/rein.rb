module Rein
  module Constraint
  end
end

RC = Rein::Constraint

require "active_record"
require "active_support/core_ext/hash"
require "active_support/inflector"

require "rein/constraint/primary_key"
require "rein/constraint/foreign_key"
require "rein/constraint/inclusion"
require "rein/constraint/numericality"
require "rein/constraint/presence"
require "rein/view"

module ActiveRecord::ConnectionAdapters
  class MysqlAdapter < AbstractAdapter
    include RC::PrimaryKey
    include RC::ForeignKey
    include Rein::View
  end

  class Mysql2Adapter < AbstractAdapter
    include RC::PrimaryKey
    include RC::ForeignKey
    include Rein::View
  end

  class PostgreSQLAdapter < AbstractAdapter
    include RC::PrimaryKey
    include RC::ForeignKey
    include RC::Inclusion
    include RC::Numericality
    include RC::Presence
    include Rein::View
  end
end
