require "spec_helper"

class Book < ActiveRecord::Base; end

def create_book(attributes = {})
  attributes = {
    title: "foo",
    state: "available",
    published_month: 1
  }.update(attributes)

  Book.create!(attributes)
end

RSpec.describe "Constraints" do
  it "raises an error if the title is not present" do
    expect { create_book(title: "") }.to raise_error(ActiveRecord::StatementInvalid, /PG::CheckViolation/)
    expect { create_book(title: "The Origin of Species") }.to_not raise_error
  end

  it "raises an error if the state is invalid" do
    expect { create_book(state: "burned") }.to raise_error(ActiveRecord::StatementInvalid, /PG::CheckViolation/)
    expect { create_book(state: "available") }.to_not raise_error
  end

  it "raises an error if the due date is not present and the book is on loan" do
    expect { create_book(state: "on_loan") }.to raise_error(ActiveRecord::StatementInvalid, /PG::CheckViolation/)
    expect { create_book(state: "on_loan", due_date: Time.now) }.to_not raise_error
  end

  it "raises an error if holder is not present and the book is on hold" do
    expect { create_book(state: "on_hold") }.to raise_error(ActiveRecord::StatementInvalid, /PG::CheckViolation/)
    expect { create_book(state: "on_hold", holder: "Charles Darwin") }.to_not raise_error
  end

  it "raises an error if the published month is not between 1 and 12" do
    expect { create_book(published_month: 0) }.to raise_error(ActiveRecord::StatementInvalid, /PG::CheckViolation/)
    expect { create_book(published_month: 13) }.to raise_error(ActiveRecord::StatementInvalid, /PG::CheckViolation/)
    expect { create_book(published_month: 1) }.to_not raise_error
  end
end
