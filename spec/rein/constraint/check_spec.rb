require 'spec_helper'

RSpec.describe Rein::Constraint::Check do
  subject(:adapter) do
    Class.new do
      include Rein::Constraint::Check
    end.new
  end

  let(:dir) { double(up: nil, down: nil) }

  before do
    allow(dir).to receive(:up).and_yield
    allow(adapter).to receive(:reversible).and_yield(dir)
    allow(adapter).to receive(:execute)
  end

  describe '#add_check_constraint' do
    context 'with no options' do
      it 'requires a name' do
        expect {
          adapter.add_check_constraint(:books, "substring(title FROM 1 FOR 1) IS DISTINCT FROM 'r'")
        }.to raise_error 'Generic CHECK constraints must have a name'
      end
    end

    context 'with a name' do
      it 'adds a constraint' do
        expect(adapter).to receive(:execute).with(%(ALTER TABLE "books" ADD CONSTRAINT "no_r_titles" CHECK (substring(title FROM 1 FOR 1) IS DISTINCT FROM 'r')))
        adapter.add_check_constraint(:books, "substring(title FROM 1 FOR 1) IS DISTINCT FROM 'r'", name: 'no_r_titles')
      end
    end
  end

  describe '#remove_check_constraint' do
    before do
      allow(adapter).to receive(:remove_index)
    end

    context 'with no options' do
      it 'requires a name' do
        expect {
          adapter.remove_check_constraint(:books, "substring(title FROM 1 FOR 1) IS DISTINCT FROM 'r'")
        }.to raise_error 'Generic CHECK constraints must have a name'
      end
    end

    context 'with a name' do
      it 'removes a constraint' do
        expect(adapter).to receive(:execute).with(%(ALTER TABLE "books" DROP CONSTRAINT "no_r_titles"))
        adapter.remove_check_constraint(:books, "substring(title FROM 1 FOR 1) IS DISTINCT FROM 'r'", name: 'no_r_titles')
      end
    end
  end
end
