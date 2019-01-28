require 'spec_helper'

class Author < ActiveRecord::Base; end
class Book < ActiveRecord::Base; end
class BookOwner < ActiveRecord::Base; end

def create_book(attributes = {})
  attributes = {
    author_id: 1,
    isbn: '0451529065',
    title: 'On the Origin of Species',
    state: 'available',
    published_month: 1
  }.update(attributes)

  Book.create!(attributes)
end

def create_book_owner(attributes = {})
  attributes = {
    book_id: 1,
    owned_during: Date.parse('1859-11-24')..Date.parse('1882-04-19'),
    owner_id: 1
  }.update(attributes)

  BookOwner.create!(attributes)
end

RSpec.describe 'Constraints' do
  before do
    Author.delete_all
    Author.create!(id: 1, name: 'Charles Darwin')
  end

  it 'raises an error if the author is not present' do
    expect { create_book(author_id: 2) }.to raise_error(ActiveRecord::InvalidForeignKey)
    expect { create_book(author_id: 1) }.to_not raise_error
  end

  it 'raises an error if the ISBN is not unique' do
    expect { create_book(isbn: 'foo') }.to_not raise_error
    expect { create_book(isbn: 'bar') }.to_not raise_error
    expect { create_book(isbn: 'foo') }.to raise_error(ActiveRecord::RecordNotUnique)
  end

  it 'allows checking unique ISBNs to be deferred' do
    foo = create_book(isbn: 'foo')
    bar = create_book(isbn: 'bar')

    Author.transaction do
      Author.connection.execute 'SET CONSTRAINTS books_isbn_unique DEFERRED'
      foo.update!(isbn: 'bar')
      bar.update!(isbn: 'foo')
    end
  end

  it 'raises an error if the book has two owners' do
    expect { create_book_owner(book_id: 1, owner_id: 1) }.to_not raise_error
    expect { create_book_owner(book_id: 2, owner_id: 2) }.to_not raise_error
    expect { create_book_owner(book_id: 1, owner_id: 3) }.to raise_error(ActiveRecord::StatementInvalid, /PG::ExclusionViolation/)
  end

  it 'raises an error if the title is not present' do
    expect { create_book(title: '') }.to raise_error(ActiveRecord::StatementInvalid, /PG::CheckViolation/)
    expect { create_book(title: 'On the Origin of Species') }.to_not raise_error
  end

  it 'raises an error if the title contains a non-ASCII letter, non-number, or non-whitespace, non-tab character' do
    expect { create_book(title: '&') }.to raise_error(ActiveRecord::StatementInvalid, /PG::CheckViolation/)
    expect { create_book(title: "\tOn the Origin of Species") }.to raise_error(ActiveRecord::StatementInvalid, /PG::CheckViolation/)
    expect { create_book(title: 'On the Origin of Species') }.to_not raise_error
  end

  it 'raises an error if the state is invalid' do
    expect { create_book(state: 'burned') }.to raise_error(ActiveRecord::StatementInvalid, /PG::CheckViolation/)
    expect { create_book(state: 'available') }.to_not raise_error
  end

  it 'raises an error if the due date is not present and the book is on loan' do
    expect { create_book(state: 'on_loan') }.to raise_error(ActiveRecord::StatementInvalid, /PG::CheckViolation/)
    expect { create_book(state: 'on_loan', due_date: Time.now) }.to_not raise_error
  end

  it 'raises an error if holder is not present and the book is on hold' do
    expect { create_book(state: 'on_hold') }.to raise_error(ActiveRecord::StatementInvalid, /PG::CheckViolation/)
    expect { create_book(state: 'on_hold', holder: 'Jane Citizen') }.to_not raise_error
  end

  it 'raises an error if the published month is not between 1 and 12' do
    expect { create_book(published_month: 0) }.to raise_error(ActiveRecord::StatementInvalid, /PG::CheckViolation/)
    expect { create_book(published_month: 13) }.to raise_error(ActiveRecord::StatementInvalid, /PG::CheckViolation/)
    expect { create_book(published_month: 1) }.to_not raise_error
  end

  it 'raises an error if the call number length is not between 1 and 255' do
    expect { create_book(call_number: '') }.to raise_error(ActiveRecord::StatementInvalid, /PG::CheckViolation/)
    expect { create_book(call_number: 'K' * 256) }.to raise_error(ActiveRecord::StatementInvalid, /PG::CheckViolation/)
    expect { create_book(call_number: 'KF8840 .F72 1999') }.to_not raise_error
  end

  it 'raises an error if the title starts with an r' do
    expect { create_book(title: 'r u okay') }.to raise_error(ActiveRecord::StatementInvalid, /PG::CheckViolation/)
  end
end
