require "spec_helper"

RSpec.describe Rein::View do
  subject(:adapter) do
    Class.new do
      include Rein::View
    end.new
  end

  before { allow(adapter).to receive(:execute) }

  describe "#create_view" do
    it "creates a view" do
      expect(adapter).to receive(:execute).with("CREATE VIEW foo AS SELECT * FROM bar")
      adapter.create_view(:foo, "SELECT * FROM bar")
    end
  end

  describe "#drop_view" do
    it "drops a view" do
      expect(adapter).to receive(:execute).with("DROP VIEW foo")
      adapter.drop_view(:foo)
    end
  end
end
