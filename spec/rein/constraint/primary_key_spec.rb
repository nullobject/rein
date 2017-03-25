require "spec_helper"

RSpec.describe Rein::Constraint::PrimaryKey, "#add_primary_key" do
  subject(:adapter) do
    Class.new do
      include Rein::Constraint::PrimaryKey
    end.new
  end

  before { allow(adapter).to receive(:execute) }

  context "with no options" do
    it "adds a primary key" do
      expect(adapter).to receive(:execute).with("ALTER TABLE books ADD PRIMARY KEY (id)")
      adapter.add_primary_key(:books)
    end
  end

  context "with 'column' option" do
    it "adds a primary key" do
      expect(adapter).to receive(:execute).with("ALTER TABLE books ADD PRIMARY KEY (code)")
      adapter.add_primary_key(:books, column: :code)
    end
  end
end
