require "spec_helper"

class TableConstraint < ActiveRecord::Base
  self.table_name = "information_schema.table_constraints"
end

RSpec.describe "Reversible" do
  before do
    ActiveRecord::Migrator.migrate(MIGRATIONS_PATH)
  end

  it "reverses foreign key constraints" do
    expect(TableConstraint.where(constraint_name: "books_author_id_fk")).to exist
    ActiveRecord::Migrator.down(MIGRATIONS_PATH, 2)
    expect(TableConstraint.where(constraint_name: "books_author_id_fk")).to_not exist
  end

  it "reverses inclusion constraints" do
    expect(TableConstraint.where(constraint_name: "books_state_inclusion")).to exist
    ActiveRecord::Migrator.down(MIGRATIONS_PATH, 1)
    expect(TableConstraint.where(constraint_name: "books_state_inclusion")).to_not exist
  end

  it "reverses null constraints" do
    expect(TableConstraint.where(constraint_name: "books_due_date_null")).to exist
    ActiveRecord::Migrator.down(MIGRATIONS_PATH, 1)
    expect(TableConstraint.where(constraint_name: "books_due_date_null")).to_not exist
  end

  it "reverses numericality constraints" do
    expect(TableConstraint.where(constraint_name: "books_published_month_numericality")).to exist
    ActiveRecord::Migrator.down(MIGRATIONS_PATH, 1)
    expect(TableConstraint.where(constraint_name: "books_published_month_numericality")).to_not exist
  end

  it "reverses presence constraints" do
    expect(TableConstraint.where(constraint_name: "books_title_presence")).to exist
    ActiveRecord::Migrator.down(MIGRATIONS_PATH, 1)
    expect(TableConstraint.where(constraint_name: "books_title_presence")).to_not exist
  end
end
