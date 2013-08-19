require 'spec_helper'

describe RC::PrimaryKey, "#add_primary_key" do
  let(:adapter) do
    Class.new do
      include RC::PrimaryKey
    end.new
  end

  subject { adapter }

  before { adapter.stub(:execute) }

  context "with no options" do
    before { adapter.add_primary_key(:books) }
    it { should have_received(:execute).with("ALTER TABLE books ADD PRIMARY KEY (id)") }
  end
end
