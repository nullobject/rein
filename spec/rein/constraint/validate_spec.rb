require 'spec_helper'

RSpec.describe Rein::Constraint::Validate do
  subject(:adapter) do
    Class.new do
      include Rein::Constraint::Validate
    end.new
  end

  let(:dir) { double(up: nil, down: nil) }

  before do
    allow(dir).to receive(:up).and_yield
    allow(adapter).to receive(:reversible).and_yield(dir)
    allow(adapter).to receive(:execute)
  end

  describe '#validate_table_constraint' do
    it 'validates a constraint' do
      expect(adapter).to receive(:execute).with(%(ALTER TABLE "books" VALIDATE CONSTRAINT no_r_titles))
      adapter.validate_table_constraint(:books, 'no_r_titles')
    end
  end
end
