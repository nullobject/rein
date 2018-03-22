require 'spec_helper'

RSpec.describe Rein::Constraint::Numericality do
  subject(:adapter) do
    Class.new do
      include Rein::Constraint::Numericality
    end.new
  end

  let(:dir) { double(up: nil, down: nil) }

  before do
    allow(dir).to receive(:up).and_yield
    allow(adapter).to receive(:reversible).and_yield(dir)
    allow(adapter).to receive(:execute)
  end

  describe '#add_numericality_constraint' do
    context 'greater_than' do
      it 'adds a constraint' do
        expect(adapter).to receive(:execute).with('ALTER TABLE books ADD CONSTRAINT books_published_month_numericality CHECK ("published_month" > 1)')
        adapter.add_numericality_constraint(:books, :published_month, greater_than: 1)
      end
    end

    context 'greater_than if' do
      it 'adds a constraint' do
        expect(adapter).to receive(:execute).with("ALTER TABLE books ADD CONSTRAINT books_published_month_numericality CHECK (NOT (status = 'published') OR (\"published_month\" > 1))")
        adapter.add_numericality_constraint(:books, :published_month, greater_than: 1, if: "status = 'published'")
      end
    end

    context 'greater_than_or_equal_to' do
      it 'adds a constraint' do
        expect(adapter).to receive(:execute).with('ALTER TABLE books ADD CONSTRAINT books_published_month_numericality CHECK ("published_month" >= 2)')
        adapter.add_numericality_constraint(:books, :published_month, greater_than_or_equal_to: 2)
      end
    end

    context 'equal_to' do
      it 'adds a constraint' do
        expect(adapter).to receive(:execute).with('ALTER TABLE books ADD CONSTRAINT books_published_month_numericality CHECK ("published_month" = 3)')
        adapter.add_numericality_constraint(:books, :published_month, equal_to: 3)
      end
    end

    context 'not_equal_to' do
      it 'adds a constraint' do
        expect(adapter).to receive(:execute).with('ALTER TABLE books ADD CONSTRAINT books_published_month_numericality CHECK ("published_month" != 0)')
        adapter.add_numericality_constraint(:books, :published_month, not_equal_to: 0)
      end
    end

    context 'less_than' do
      it 'adds a constraint' do
        expect(adapter).to receive(:execute).with('ALTER TABLE books ADD CONSTRAINT books_published_month_numericality CHECK ("published_month" < 4)')
        adapter.add_numericality_constraint(:books, :published_month, less_than: 4)
      end
    end

    context 'less_than_or_equal_to' do
      it 'adds a constraint' do
        expect(adapter).to receive(:execute).with('ALTER TABLE books ADD CONSTRAINT books_published_month_numericality CHECK ("published_month" <= 5)')
        adapter.add_numericality_constraint(:books, :published_month, less_than_or_equal_to: 5)
      end
    end

    context 'greater_than_or_equal_to and less_than_or_equal_to' do
      it 'adds a constraint' do
        expect(adapter).to receive(:execute).with('ALTER TABLE books ADD CONSTRAINT books_published_month_numericality CHECK ("published_month" >= 5 AND "published_month" <= 6)')
        adapter.add_numericality_constraint(:books, :published_month, greater_than_or_equal_to: 5, less_than_or_equal_to: 6)
      end
    end

    context 'given a name option' do
      it 'adds a constraint with that name' do
        expect(adapter).to receive(:execute).with('ALTER TABLE books ADD CONSTRAINT books_published_month_is_valid CHECK ("published_month" > 1)')
        adapter.add_numericality_constraint(:books, :published_month, greater_than: 1, name: 'books_published_month_is_valid')
      end
    end
  end

  describe '#remove_numericality_constraint' do
    it 'removes a constraint' do
      expect(subject).to receive(:execute).with('ALTER TABLE books DROP CONSTRAINT books_published_month_numericality')
      subject.remove_numericality_constraint(:books, :published_month)
    end
  end
end
