require "spec_helper"

RSpec.describe Rein::Type::Enum do
  let(:adapter) do
    Class.new do
      include Rein::Type::Enum
    end.new
  end

  subject { adapter }

  before { allow(adapter).to receive(:execute) }

  describe "#add_enum_type" do
    context "with name and fields" do
      before { adapter.add_enum_type(:book_type, %w(paperback hardcover)) }
      it { is_expected.to have_received(:execute).with("CREATE TYPE book_type AS ENUM ('paperback', 'hardcover')") }
    end
  end

  describe "#drop_enum_type" do
    context "remove an enum" do
      before { adapter.drop_enum_type(:book_type) }
      it { is_expected.to have_received(:execute).with("DROP TYPE book_type") }
    end
  end

  describe "#add_enum_value" do
    context "add a value to an enum" do
      before { adapter.add_enum_value(:book_type, "ebook") }
      it { is_expected.to have_received(:execute).with("ALTER TYPE book_type ADD VALUE 'ebook'") }
    end
  end
end
