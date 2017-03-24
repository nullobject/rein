require "spec_helper"

RSpec.describe Rein::Type::Enum do
  let(:adapter) do
    Class.new do
      include Rein::Type::Enum
    end.new
  end

  describe "#add_enum" do
    subject { adapter }

    before do
      allow(adapter).to receive(:execute)
    end

    context "with name and fields" do
      before { adapter.add_enum(:type, %w(paperback hardcover)) }
      it { is_expected.to have_received(:execute).with("CREATE TYPE type AS ENUM ('paperback', 'hardcover')") }
    end
  end

  describe "#remove_enum" do
    subject { adapter }

    before do
      allow(adapter).to receive(:execute)
    end

    context "remove an enum" do
      before { adapter.remove_enum(:type) }
      it { is_expected.to have_received(:execute).with("DROP TYPE type") }
    end
  end
end
