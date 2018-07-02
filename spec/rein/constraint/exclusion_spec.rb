require 'spec_helper'

RSpec.describe Rein::Constraint::Exclusion do
  subject(:adapter) do
    Class.new do
      include Rein::Constraint::Exclusion
    end.new
  end

  let(:dir) { double(up: nil, down: nil) }

  before do
    allow(dir).to receive(:up).and_yield
    allow(adapter).to receive(:reversible).and_yield(dir)
    allow(adapter).to receive(:execute)
  end

  describe '#add_exclusion_constraint' do
    context 'given an single attribute/operator pair' do
      it 'adds a constraint' do
        expect(adapter).to receive(:execute).with(%(ALTER TABLE "book_owners" ADD CONSTRAINT book_owners_book_id_exclude EXCLUDE ("book_id" WITH =) DEFERRABLE INITIALLY IMMEDIATE))
        adapter.add_exclusion_constraint(:book_owners, :book_id, '=')
      end
    end

    context 'given an array of attribute/operator pairs' do
      it 'adds a deferrable constraint that is initially immediate' do
        expect(adapter).to receive(:execute).with(%(ALTER TABLE "book_owners" ADD CONSTRAINT book_owners_book_id_owned_during_exclude EXCLUDE USING gist ("book_id" WITH =, "owned_during" WITH &&) DEFERRABLE INITIALLY IMMEDIATE))
        adapter.add_exclusion_constraint(:book_owners, [[:book_id, '='], [:owned_during, '&&']], using: :gist)
      end
    end

    context 'given a name option' do
      it 'adds a constraint with that name' do
        expect(adapter).to receive(:execute).with(%(ALTER TABLE "book_owners" ADD CONSTRAINT never_two_owners EXCLUDE ("book_id" WITH =) DEFERRABLE INITIALLY IMMEDIATE))
        adapter.add_exclusion_constraint(:book_owners, :book_id, '=', name: 'never_two_owners')
      end
    end

    context 'given a deferred option' do
      it 'adds a deferrable constraint that is initially deferred' do
        expect(adapter).to receive(:execute).with(%(ALTER TABLE "book_owners" ADD CONSTRAINT book_owners_book_id_exclude EXCLUDE ("book_id" WITH =) DEFERRABLE INITIALLY DEFERRED))
        adapter.add_exclusion_constraint(:book_owners, :book_id, '=', deferred: true)
      end
    end

    context 'given a deferrable option' do
      it 'adds an immediate constraint' do
        expect(adapter).to receive(:execute).with(%(ALTER TABLE "book_owners" ADD CONSTRAINT book_owners_book_id_exclude EXCLUDE ("book_id" WITH =)))
        adapter.add_exclusion_constraint(:book_owners, :book_id, '=', deferrable: false)
      end
    end
  end

  describe '#remove_exclusion_constraint' do
    it 'removes a constraint' do
      expect(subject).to receive(:execute).with(%(ALTER TABLE "book_owners" DROP CONSTRAINT book_owners_book_id_exclude))
      subject.remove_exclusion_constraint(:book_owners, :book_id, '=')
    end
  end
end
