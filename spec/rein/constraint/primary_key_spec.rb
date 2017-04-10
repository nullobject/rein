require "spec_helper"

RSpec.describe Rein::Constraint::PrimaryKey do
  subject(:adapter) do
    Class.new do
      include Rein::Constraint::PrimaryKey
    end.new
  end

  let(:dir) { double(up: nil, down: nil) }

  before do
    allow(dir).to receive(:up).and_yield
    allow(adapter).to receive(:reversible).and_yield(dir)
    allow(adapter).to receive(:execute)
  end

  describe "#add_primary_key" do
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

  describe "#remove_primary_key" do
    it "removes a constraint" do
      expect(subject).to receive(:execute).with("ALTER TABLE books DROP CONSTRAINT id_pkey")
      subject.remove_primary_key(:books)
    end
  end
end
