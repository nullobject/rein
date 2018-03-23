require 'spec_helper'

RSpec.describe Rein::Constraint::ForeignKey do
  subject(:adapter) do
    Class.new do
      include Rein::Constraint::ForeignKey
    end.new
  end

  let(:dir) { double(up: nil, down: nil) }

  before do
    allow(dir).to receive(:up).and_yield
    allow(adapter).to receive(:reversible).and_yield(dir)
    allow(adapter).to receive(:execute)
  end

  describe '#add_foreign_key_constraint' do
    before do
      allow(adapter).to receive(:add_index)
    end

    context 'with no options' do
      it 'adds a constraint' do
        expect(adapter).to receive(:execute).with(%(ALTER TABLE books ADD CONSTRAINT books_person_id_fk FOREIGN KEY ("person_id") REFERENCES people ("id")))
        adapter.add_foreign_key_constraint(:books, :people)
      end
    end

    context 'with a given referencing attribute' do
      it 'adds a constraint' do
        expect(adapter).to receive(:execute).with(%(ALTER TABLE books ADD CONSTRAINT books_author_id_fk FOREIGN KEY ("author_id") REFERENCES people ("id")))
        adapter.add_foreign_key_constraint(:books, :people, referencing: :author_id)
      end
    end

    context 'with a given referenced attribute' do
      it 'adds a constraint' do
        expect(adapter).to receive(:execute).with(%(ALTER TABLE books ADD CONSTRAINT books_person_id_fk FOREIGN KEY ("person_id") REFERENCES people ("person_id")))
        adapter.add_foreign_key_constraint(:books, :people, referenced: :person_id)
      end
    end

    context 'with a given referencing attribute and referenced attribute' do
      it 'adds a constraint' do
        expect(adapter).to receive(:execute).with(%(ALTER TABLE books ADD CONSTRAINT books_author_id_fk FOREIGN KEY ("author_id") REFERENCES people ("person_id")))
        adapter.add_foreign_key_constraint(:books, :people, referencing: :author_id, referenced: :person_id)
      end
    end

    context 'with a given name' do
      it 'adds a constraint' do
        expect(adapter).to receive(:execute).with(%(ALTER TABLE books ADD CONSTRAINT foo FOREIGN KEY ("person_id") REFERENCES people ("id")))
        adapter.add_foreign_key_constraint(:books, :people, name: :foo)
      end
    end

    context 'with a given on delete referential action' do
      it 'adds a constraint' do
        expect(adapter).to receive(:execute).with(%(ALTER TABLE books ADD CONSTRAINT books_person_id_fk FOREIGN KEY ("person_id") REFERENCES people ("id") ON DELETE CASCADE))
        adapter.add_foreign_key_constraint(:books, :people, on_delete: :cascade)
      end
    end

    context 'with a given on update referential action' do
      it 'adds a constraint' do
        expect(adapter).to receive(:execute).with(%(ALTER TABLE books ADD CONSTRAINT books_person_id_fk FOREIGN KEY ("person_id") REFERENCES people ("id") ON UPDATE CASCADE))
        adapter.add_foreign_key_constraint(:books, :people, on_update: :cascade)
      end
    end

    context "with a 'cascade' on delete and update referential action" do
      it 'adds a constraint' do
        expect(adapter).to receive(:execute).with(%(ALTER TABLE books ADD CONSTRAINT books_person_id_fk FOREIGN KEY ("person_id") REFERENCES people ("id") ON DELETE CASCADE ON UPDATE CASCADE))
        adapter.add_foreign_key_constraint(:books, :people, on_delete: :cascade, on_update: :cascade)
      end
    end

    context "with a 'no action' on delete and update referential action" do
      it 'adds a constraint' do
        expect(adapter).to receive(:execute).with(%(ALTER TABLE books ADD CONSTRAINT books_person_id_fk FOREIGN KEY ("person_id") REFERENCES people ("id") ON DELETE NO ACTION ON UPDATE NO ACTION))
        adapter.add_foreign_key_constraint(:books, :people, on_delete: :no_action, on_update: :no_action)
      end
    end

    describe 'with an index option' do
      it 'adds a constraint' do
        expect(adapter).to receive(:add_index).with(:books, :person_id)
        adapter.add_foreign_key_constraint(:books, :people, index: true)
      end
    end

    describe 'with a referencing attribute and an index option' do
      it 'adds a constraint' do
        expect(adapter).to receive(:add_index).with(:books, :author_id)
        adapter.add_foreign_key_constraint(:books, :people, referencing: :author_id, index: true)
      end
    end
  end

  describe '#remove_foreign_key_constraint' do
    before do
      allow(adapter).to receive(:remove_index)
    end

    context 'with no options' do
      it 'removes a constraint' do
        expect(adapter).to receive(:execute).with('ALTER TABLE books DROP CONSTRAINT books_person_id_fk')
        adapter.remove_foreign_key_constraint(:books, :people)
      end
    end

    context 'with a given referencing attribute' do
      it 'removes a constraint' do
        expect(adapter).to receive(:execute).with('ALTER TABLE books DROP CONSTRAINT books_author_id_fk')
        adapter.remove_foreign_key_constraint(:books, :people, referencing: :author_id)
      end
    end

    context 'with a given name' do
      it 'removes a constraint' do
        expect(adapter).to receive(:execute).with('ALTER TABLE books DROP CONSTRAINT foo')
        adapter.remove_foreign_key_constraint(:books, :people, name: :foo)
      end
    end

    describe 'with an index option' do
      it 'removes a constraint' do
        expect(adapter).to receive(:remove_index).with(:books, :person_id)
        adapter.remove_foreign_key_constraint(:books, :people, index: true)
      end
    end

    describe 'with a referencing attribute and an index option' do
      it 'removes a constraint' do
        expect(adapter).to receive(:remove_index).with(:books, :author_id)
        adapter.remove_foreign_key_constraint(:books, :people, referencing: :author_id, index: true)
      end
    end
  end
end
