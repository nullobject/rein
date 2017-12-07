require 'spec_helper'

RSpec.describe Rein::Schema do
  subject(:adapter) do
    Class.new do
      include Rein::Schema
    end.new
  end

  let(:dir) { double(up: nil, down: nil) }

  before do
    allow(dir).to receive(:up).and_yield
    allow(adapter).to receive(:reversible).and_yield(dir)
    allow(adapter).to receive(:execute)
  end

  describe '#create_schema' do
    it 'creates a schema' do
      expect(adapter).to receive(:execute).with('CREATE SCHEMA foo')
      adapter.create_schema(:foo)
    end
  end

  describe '#drop_schema' do
    it 'drops a schema' do
      expect(adapter).to receive(:execute).with('DROP SCHEMA foo')
      adapter.drop_schema(:foo)
    end
  end
end
