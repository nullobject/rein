require 'spec_helper'

RSpec.describe Rein::Constraint::Unique do
  subject(:adapter) do
    Class.new do
      include Rein::Constraint::Unique
    end.new
  end

  let(:dir) { double(up: nil, down: nil) }

  before do
    allow(dir).to receive(:up).and_yield
    allow(adapter).to receive(:reversible).and_yield(dir)
    allow(adapter).to receive(:execute)
  end

  describe '#add_unique_constraint' do
    context 'given an single attribute' do
      it 'adds a constraint' do
        expect(adapter).to receive(:execute).with(%(ALTER TABLE "books" ADD CONSTRAINT books_call_number_unique UNIQUE ("call_number") DEFERRABLE INITIALLY IMMEDIATE))
        adapter.add_unique_constraint(:books, :call_number)
      end
    end

    context 'given an array of attributes' do
      it 'adds a deferrable constraint that is initially immediate' do
        expect(adapter).to receive(:execute).with(%(ALTER TABLE "books" ADD CONSTRAINT books_call_number_title_unique UNIQUE ("call_number", "title") DEFERRABLE INITIALLY IMMEDIATE))
        adapter.add_unique_constraint(:books, %w[call_number title])
      end
    end

    context 'given a name option' do
      it 'adds a constraint with that name' do
        expect(adapter).to receive(:execute).with(%(ALTER TABLE "books" ADD CONSTRAINT books_call_number_is_unique UNIQUE ("call_number") DEFERRABLE INITIALLY IMMEDIATE))
        adapter.add_unique_constraint(:books, :call_number, name: 'books_call_number_is_unique')
      end
    end

    context 'given a deferred option' do
      it 'adds a deferrable constraint that is initially deferred' do
        expect(adapter).to receive(:execute).with(%(ALTER TABLE "books" ADD CONSTRAINT books_call_number_unique UNIQUE ("call_number") DEFERRABLE INITIALLY DEFERRED))
        adapter.add_unique_constraint(:books, :call_number, deferred: true)
      end
    end

    context 'given a deferrable option' do
      it 'adds an immediate constraint' do
        expect(adapter).to receive(:execute).with(%(ALTER TABLE "books" ADD CONSTRAINT books_call_number_unique UNIQUE ("call_number")))
        adapter.add_unique_constraint(:books, :call_number, deferrable: false)
      end
    end
  end

  describe '#remove_unique_constraint' do
    it 'removes a constraint' do
      expect(subject).to receive(:execute).with(%(ALTER TABLE "books" DROP CONSTRAINT books_state_unique))
      subject.remove_unique_constraint(:books, :state)
    end
  end
end
