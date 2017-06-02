require "spec_helper"

RSpec.describe Rein::Constraint::Length do
  subject(:adapter) do
    Class.new do
      include Rein::Constraint::Length
    end.new
  end

  let(:dir) { double(up: nil, down: nil) }

  before do
    allow(dir).to receive(:up).and_yield
    allow(adapter).to receive(:reversible).and_yield(dir)
    allow(adapter).to receive(:execute)
  end

  describe "#add_length_constraint" do
    context "greater_than" do
      it "adds a constraint" do
        expect(adapter).to receive(:execute).with("ALTER TABLE books ADD CONSTRAINT books_call_number_length CHECK (length(call_number) > 1)")
        adapter.add_length_constraint(:books, :call_number, greater_than: 1)
      end
    end

    context "greater_than if" do
      it "adds a constraint" do
        expect(adapter).to receive(:execute).with("ALTER TABLE books ADD CONSTRAINT books_call_number_length CHECK (NOT (status = 'published') OR (length(call_number) > 1))")
        adapter.add_length_constraint(:books, :call_number, greater_than: 1, if: "status = 'published'")
      end
    end

    context "greater_than_or_equal_to" do
      it "adds a constraint" do
        expect(adapter).to receive(:execute).with("ALTER TABLE books ADD CONSTRAINT books_call_number_length CHECK (length(call_number) >= 2)")
        adapter.add_length_constraint(:books, :call_number, greater_than_or_equal_to: 2)
      end
    end

    context "equal_to" do
      it "adds a constraint" do
        expect(adapter).to receive(:execute).with("ALTER TABLE books ADD CONSTRAINT books_call_number_length CHECK (length(call_number) = 3)")
        adapter.add_length_constraint(:books, :call_number, equal_to: 3)
      end
    end

    context "not_equal_to" do
      it "adds a constraint" do
        expect(adapter).to receive(:execute).with("ALTER TABLE books ADD CONSTRAINT books_call_number_length CHECK (length(call_number) != 0)")
        adapter.add_length_constraint(:books, :call_number, not_equal_to: 0)
      end
    end

    context "less_than" do
      it "adds a constraint" do
        expect(adapter).to receive(:execute).with("ALTER TABLE books ADD CONSTRAINT books_call_number_length CHECK (length(call_number) < 4)")
        adapter.add_length_constraint(:books, :call_number, less_than: 4)
      end
    end

    context "less_than_or_equal_to" do
      it "adds a constraint" do
        expect(adapter).to receive(:execute).with("ALTER TABLE books ADD CONSTRAINT books_call_number_length CHECK (length(call_number) <= 5)")
        adapter.add_length_constraint(:books, :call_number, less_than_or_equal_to: 5)
      end
    end

    context "greater_than_or_equal_to and less_than_or_equal_to" do
      it "adds a constraint" do
        expect(adapter).to receive(:execute).with("ALTER TABLE books ADD CONSTRAINT books_call_number_length CHECK (length(call_number) >= 5 AND length(call_number) <= 6)")
        adapter.add_length_constraint(:books, :call_number, greater_than_or_equal_to: 5, less_than_or_equal_to: 6)
      end
    end

    context "given a name option" do
      it "adds a constraint with that name" do
        expect(adapter).to receive(:execute).with("ALTER TABLE books ADD CONSTRAINT books_call_number_length CHECK (length(call_number) > 1)")
        adapter.add_length_constraint(:books, :call_number, greater_than: 1, name: "books_call_number_length")
      end
    end
  end

  describe "#remove_length_constraint" do
    it "removes a constraint" do
      expect(subject).to receive(:execute).with("ALTER TABLE books DROP CONSTRAINT books_call_number_length")
      subject.remove_length_constraint(:books, :call_number)
    end
  end
end
