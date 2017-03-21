require "spec_helper"

RSpec.describe Rein::Constraint::PrimaryKey, "#add_primary_key" do
  let(:adapter) do
    Class.new do
      include Rein::Constraint::PrimaryKey
    end.new
  end

  subject { adapter }

  before { allow(adapter).to receive(:execute) }

  context "with no options" do
    before { adapter.add_primary_key(:books) }
    it { is_expected.to have_received(:execute).with("ALTER TABLE books ADD PRIMARY KEY (id)") }
  end

  context "with 'column' option" do
    before { adapter.add_primary_key(:books, column: :code) }
    it { is_expected.to have_received(:execute).with("ALTER TABLE books ADD PRIMARY KEY (code)") }
  end
end
