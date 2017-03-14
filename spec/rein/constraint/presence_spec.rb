require "spec_helper"

describe Rein::Constraint::Presence, "#add_presence_constraint" do
  let(:adapter) do
    Class.new do
      include Rein::Constraint::Presence
    end.new
  end

  subject { adapter }

  before { allow(adapter).to receive(:execute) }

  context "given a table and attribute" do
    before { adapter.add_presence_constraint(:books, :state) }
    it { is_expected.to have_received(:execute).with("ALTER TABLE books ADD CONSTRAINT books_state CHECK (state !~ '^\s*$')") }
  end
end
