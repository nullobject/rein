require "spec_helper"

RSpec.describe Rein::Constraint::Presence do
  let(:adapter) do
    Class.new do
      include Rein::Constraint::Presence
    end.new
  end

  subject { adapter }

  before { allow(adapter).to receive(:execute) }

  describe "#add_presence_constraint" do
    context "given a table and attribute" do
      before { adapter.add_presence_constraint(:books, :state) }
      it { is_expected.to have_received(:execute).with("ALTER TABLE books ADD CONSTRAINT books_state CHECK (state !~ '^\\s*$')") }
    end

    context "given a table and attribute and if option" do
      before { adapter.add_presence_constraint(:books, :isbn, if: "state = 'published'") }
      it { is_expected.to have_received(:execute).with("ALTER TABLE books ADD CONSTRAINT books_isbn CHECK (NOT (state = 'published') OR (isbn !~ '^\\s*$'))") }
    end
  end

  describe "#remove_presence_constraint" do
    it "removes the constraint from the table" do
      expect(subject).to receive(:execute).with("ALTER TABLE books DROP CONSTRAINT books_state")
      subject.remove_presence_constraint(:books, :state)
    end
  end
end
