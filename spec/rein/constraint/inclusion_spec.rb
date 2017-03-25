require "spec_helper"

RSpec.describe Rein::Constraint::Inclusion do
  let(:adapter) do
    Class.new do
      include Rein::Constraint::Inclusion
    end.new
  end

  subject { adapter }

  before { allow(adapter).to receive(:execute) }

  describe "#add_inclusion_constraint" do
    context "given an array of string values" do
      before { adapter.add_inclusion_constraint(:books, :state, in: %w(available on_loan)) }
      it { is_expected.to have_received(:execute).with("ALTER TABLE books ADD CONSTRAINT books_state CHECK (state IN ('available', 'on_loan'))") }
    end

    context "given an array of numeric values" do
      before { adapter.add_inclusion_constraint(:books, :state, in: [1, 2, 3]) }
      it { is_expected.to have_received(:execute).with("ALTER TABLE books ADD CONSTRAINT books_state CHECK (state IN (1, 2, 3))") }
    end
  end

  describe "#remove_inclusion_constraint" do
    it "removes the constraint from the table" do
      expect(subject).to receive(:execute).with("ALTER TABLE books DROP CONSTRAINT books_state")
      subject.remove_inclusion_constraint(:books, :state)
    end
  end
end
