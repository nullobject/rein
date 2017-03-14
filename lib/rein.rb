require "active_record"
require "active_record/connection_adapters/abstract_mysql_adapter"

require "rein/constraint/primary_key"
require "rein/constraint/foreign_key"
require "rein/constraint/inclusion"
require "rein/constraint/numericality"
require "rein/constraint/presence"
require "rein/view"

module ActiveRecord
  module ConnectionAdapters # :nodoc:
    class MysqlAdapter < AbstractAdapter # :nodoc:
      include Rein::Constraint::PrimaryKey
      include Rein::Constraint::ForeignKey
      include Rein::View
    end

    class Mysql2Adapter < AbstractMysqlAdapter # :nodoc:
      include Rein::Constraint::PrimaryKey
      include Rein::Constraint::ForeignKey
      include Rein::View
    end

    class PostgreSQLAdapter < AbstractAdapter # :nodoc:
      include Rein::Constraint::PrimaryKey
      include Rein::Constraint::ForeignKey
      include Rein::Constraint::Inclusion
      include Rein::Constraint::Numericality
      include Rein::Constraint::Presence
      include Rein::View
    end
  end
end
