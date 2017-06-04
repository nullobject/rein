require "active_record"
require "rein/constraint/foreign_key"
require "rein/constraint/inclusion"
require "rein/constraint/length"
require "rein/constraint/null"
require "rein/constraint/numericality"
require "rein/constraint/presence"
require "rein/constraint/primary_key"
require "rein/schema"
require "rein/type/enum"
require "rein/view"

module ActiveRecord
  class Migration # :nodoc:
    include Rein::Constraint::ForeignKey
    include Rein::Constraint::Inclusion
    include Rein::Constraint::Length
    include Rein::Constraint::Null
    include Rein::Constraint::Numericality
    include Rein::Constraint::Presence
    include Rein::Constraint::PrimaryKey
    include Rein::Schema
    include Rein::Type::Enum
    include Rein::View
  end
end
