require 'spec_helper'

RSpec.describe Rein::Type::Enum do
  subject(:adapter) do
    Class.new do
      include Rein::Type::Enum
    end.new
  end

  let(:dir) { double(up: nil, down: nil) }

  before do
    allow(dir).to receive(:up).and_yield
    allow(adapter).to receive(:reversible).and_yield(dir)
    allow(adapter).to receive(:execute)
  end

  describe '#create_enum_type' do
    it 'creates an enum type' do
      expect(adapter).to receive(:execute).with("CREATE TYPE book_type AS ENUM ('paperback', 'hardcover')")
      adapter.create_enum_type(:book_type, %w[paperback hardcover])
    end
  end

  describe '#drop_enum_type' do
    it 'drops an enum type' do
      expect(adapter).to receive(:execute).with('DROP TYPE book_type')
      adapter.drop_enum_type(:book_type)
    end
  end

  describe '#add_enum_value' do
    it 'adds a value to an enum type' do
      expect(adapter).to receive(:execute).with("ALTER TYPE book_type ADD VALUE 'ebook'")
      adapter.add_enum_value(:book_type, 'ebook')
    end
  end
end
