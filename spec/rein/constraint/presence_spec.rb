require "spec_helper"

RSpec.describe Rein::Constraint::Presence, "#add_presence_constraint" do
  let(:adapter) do
    Class.new do
      include Rein::Constraint::Presence
    end.new
  end

  subject { adapter }

  before { allow(adapter).to receive(:execute) }

  context "given a table and attribute" do
    before { adapter.add_presence_constraint(:books, :state) }
    it { is_expected.to have_received(:execute).with("ALTER TABLE books ADD CONSTRAINT books_state CHECK (state !~ '^\\s*$')") }
  end

  context "given a table and attribute and if option" do
    before { adapter.add_presence_constraint(:books, :isbn, if: "state = 'published'") }
    it { is_expected.to have_received(:execute).with("ALTER TABLE books ADD CONSTRAINT books_isbn CHECK (NOT (state = 'published') OR (isbn !~ '^\\s*$'))") }
  end
end
