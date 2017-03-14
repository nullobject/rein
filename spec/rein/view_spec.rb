require "spec_helper"

describe Rein::View do
  let(:adapter) do
    Class.new do
      include Rein::View
    end.new
  end

  subject { adapter }

  before { allow(adapter).to receive(:execute) }

  describe "#create_view" do
    before { adapter.create_view(:foo, "SELECT * FROM bar") }
    it { is_expected.to have_received(:execute).with("CREATE VIEW foo AS SELECT * FROM bar") }
  end

  describe "#drop_view" do
    before { adapter.drop_view(:foo) }
    it { is_expected.to have_received(:execute).with("DROP VIEW foo") }
  end
end
