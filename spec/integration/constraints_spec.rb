require "spec_helper"

class CreateBooksTable < ActiveRecord::Migration
  def change
    suppress_messages do
      execute "DROP TABLE IF EXISTS books"

      create_table :books do |t|
        t.string :title, null: false
        t.string :state, null: false
        t.integer :published_month, null: false
        t.date :due_date
      end

      add_presence_constraint :books, :title
      add_inclusion_constraint :books, :state, in: %w[available on_loan on_hold]
      add_null_constraint :books, :due_date, if: "state = 'on_loan'"
      add_numericality_constraint :books, :published_month, greater_than_or_equal_to: 1, less_than_or_equal_to: 12
    end
  end
end

class Book < ActiveRecord::Base; end

def create_book(attributes = {})
  attributes = {
    title: "foo",
    state: "available",
    published_month: 1
  }.update(attributes)

  Book.create!(attributes)
end

RSpec.describe Book do
  before(:all) do
    ActiveRecord::Base.establish_connection(adapter: "postgresql", database: "rein_test")
    CreateBooksTable.new.migrate(:up)
  end

  it "raises an error if the title is not present" do
    expect { create_book(title: "") }.to raise_error(ActiveRecord::StatementInvalid, /PG::CheckViolation/)
    expect { create_book(title: "The Origin of Species") }.to_not raise_error
  end

  it "raises an error if the state is invalid" do
    expect { create_book(state: "burned") }.to raise_error(ActiveRecord::StatementInvalid, /PG::CheckViolation/)
    expect { create_book(state: "on_hold") }.to_not raise_error
  end

  it "raises an error if the due date is not present and the book is on loan" do
    expect { create_book(state: "on_loan") }.to raise_error(ActiveRecord::StatementInvalid, /PG::CheckViolation/)
    expect { create_book(state: "on_loan", due_date: Time.now) }.to_not raise_error
  end

  it "raises an error if the published month is not between 1 and 12" do
    expect { create_book(published_month: 0) }.to raise_error(ActiveRecord::StatementInvalid, /PG::CheckViolation/)
    expect { create_book(published_month: 13) }.to raise_error(ActiveRecord::StatementInvalid, /PG::CheckViolation/)
    expect { create_book(published_month: 1) }.to_not raise_error
  end
end
