require 'spec_helper'

RSpec.describe Rein::Constraint::Match do
  subject(:adapter) do
    Class.new do
      include Rein::Constraint::Match
    end.new
  end

  let(:dir) { double(up: nil, down: nil) }

  before do
    allow(dir).to receive(:up).and_yield
    allow(adapter).to receive(:reversible).and_yield(dir)
    allow(adapter).to receive(:execute)
  end

  describe '#add_match_constraint' do
    context 'accept' do
      it 'adds a constraint' do
        expect(adapter).to receive(:execute).with(%(ALTER TABLE "books" ADD CONSTRAINT books_title_match CHECK (\"title\" ~ '\\A[a-z0-9]*\\Z')))
        adapter.add_match_constraint(:books, :title, accepts: '\A[a-z0-9]*\Z')
      end
    end

    context 'accept if' do
      it 'adds a constraint' do
        expect(adapter).to receive(:execute).with(%(ALTER TABLE "books" ADD CONSTRAINT books_title_match CHECK (NOT (status = 'published') OR (\"title\" ~ '\\A[a-z0-9]*\\Z'))))
        adapter.add_match_constraint(:books, :title, accepts: '\A[a-z0-9]*\Z', if: "status = 'published'")
      end
    end

    context 'accept_case_insensitive' do
      it 'adds a constraint' do
        expect(adapter).to receive(:execute).with(%(ALTER TABLE "books" ADD CONSTRAINT books_title_match CHECK (\"title\" ~* '\\A[a-z0-9]*\\Z')))
        adapter.add_match_constraint(:books, :title, accepts_case_insensitive: '\A[a-z0-9]*\Z')
      end
    end

    context 'reject' do
      it 'adds a constraint' do
        expect(adapter).to receive(:execute).with(%(ALTER TABLE "books" ADD CONSTRAINT books_title_match CHECK (\"title\" !~ '\\A[a-z0-9]*\\Z')))
        adapter.add_match_constraint(:books, :title, rejects: '\A[a-z0-9]*\Z')
      end
    end

    context 'reject_case_insensitive' do
      it 'adds a constraint' do
        expect(adapter).to receive(:execute).with(%(ALTER TABLE "books" ADD CONSTRAINT books_title_match CHECK (\"title\" !~* '\\A[a-z0-9]*\\Z')))
        adapter.add_match_constraint(:books, :title, rejects_case_insensitive: '\A[a-z0-9]*\Z')
      end
    end

    context 'accept and reject' do
      it 'adds a constraint' do
        expect(adapter).to receive(:execute).with(%(ALTER TABLE "books" ADD CONSTRAINT books_title_match CHECK (\"title\" ~ '\\A[a-z0-9]*\\Z' AND \"title\" !~ '\\A[0-9]*\\Z')))
        adapter.add_match_constraint(:books, :title, accepts: '\A[a-z0-9]*\Z', rejects: '\A[0-9]*\Z')
      end
    end

    context 'given a name option' do
      it 'adds a constraint with that name' do
        expect(adapter).to receive(:execute).with(%(ALTER TABLE "books" ADD CONSTRAINT books_title_is_valid CHECK (\"title\" ~ '\\A[a-z0-9]*\\Z')))
        adapter.add_match_constraint(:books, :title, accepts: '\A[a-z0-9]*\Z', name: 'books_title_is_valid')
      end
    end

    context 'with a validate option of false' do
      it 'adds a constraint with NOT VALID' do
        expect(adapter).to receive(:execute).with(%(ALTER TABLE "books" ADD CONSTRAINT books_title_is_valid CHECK (\"title\" ~ '\\A[a-z0-9]*\\Z') NOT VALID))
        adapter.add_match_constraint(:books, :title, accepts: '\A[a-z0-9]*\Z', name: 'books_title_is_valid', validate: false)
      end
    end
  end

  describe '#remove_match_constraint' do
    it 'removes a constraint' do
      expect(subject).to receive(:execute).with(%(ALTER TABLE "books" DROP CONSTRAINT books_title_match))
      subject.remove_match_constraint(:books, :title)
    end
  end
end
