require "spec_helper"

RSpec.describe Rein::Constraint::Inclusion do
  subject(:adapter) do
    Class.new do
      include Rein::Constraint::Inclusion
    end.new
  end

  let(:dir) { double(up: nil, down: nil) }

  before do
    allow(dir).to receive(:up).and_yield
    allow(adapter).to receive(:reversible).and_yield(dir)
    allow(adapter).to receive(:execute)
  end

  describe "#add_inclusion_constraint" do
    context "given an array of string values" do
      it "adds a constraint" do
        expect(adapter).to receive(:execute).with("ALTER TABLE books ADD CONSTRAINT books_state_inclusion CHECK (state IN ('available', 'on_loan'))")
        adapter.add_inclusion_constraint(:books, :state, in: %w[available on_loan])
      end
    end

    context "given an array of string values and an if option" do
      it "adds a constraint" do
        expect(adapter).to receive(:execute).with("ALTER TABLE books ADD CONSTRAINT books_state_inclusion CHECK (NOT (deleted_at IS NULL) OR (state IN ('available', 'on_loan')))")
        adapter.add_inclusion_constraint(:books, :state, in: %w[available on_loan], if: "deleted_at IS NULL")
      end
    end

    context "given a name option" do
      it "adds a constraint with that name" do
        expect(adapter).to receive(:execute).with("ALTER TABLE books ADD CONSTRAINT books_state_is_valid CHECK (state IN ('available', 'on_loan'))")
        adapter.add_inclusion_constraint(:books, :state, in: %w[available on_loan], name: "books_state_is_valid")
      end
    end

    context "given an array of numeric values" do
      it "adds a constraint" do
        expect(adapter).to receive(:execute).with("ALTER TABLE books ADD CONSTRAINT books_state_inclusion CHECK (state IN (1, 2, 3))")
        adapter.add_inclusion_constraint(:books, :state, in: [1, 2, 3])
      end
    end
  end

  describe "#remove_inclusion_constraint" do
    it "removes a constraint" do
      expect(subject).to receive(:execute).with("ALTER TABLE books DROP CONSTRAINT books_state_inclusion")
      subject.remove_inclusion_constraint(:books, :state)
    end
  end
end
