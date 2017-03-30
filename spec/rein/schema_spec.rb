require "spec_helper"

RSpec.describe Rein::Schema do
  subject(:adapter) do
    Class.new do
      include Rein::Schema
    end.new
  end

  before { allow(adapter).to receive(:execute) }

  describe "#create_schema" do
    it "creates a schema" do
      expect(adapter).to receive(:execute).with("CREATE SCHEMA foo")
      adapter.create_schema(:foo)
    end
  end

  describe "#drop_schema" do
    it "drops a schema" do
      expect(adapter).to receive(:execute).with("DROP SCHEMA foo")
      adapter.drop_schema(:foo)
    end
  end
end
