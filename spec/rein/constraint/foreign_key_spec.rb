require 'spec_helper'

describe RC::ForeignKey do
  let(:adapter) do
    Class.new do
      include RC::ForeignKey
    end.new
  end

  describe "#add_foreign_key_constraint" do
    subject { adapter }

    before do
      adapter.stub(:execute)
      adapter.stub(:add_index)
    end

    context "with no options" do
      before { adapter.add_foreign_key_constraint(:books, :people) }
      it { should have_received(:execute).with("ALTER TABLE books ADD CONSTRAINT books_person_id_fk FOREIGN KEY (person_id) REFERENCES people (id)") }
    end

    context "with a given referencing attribute" do
      before { adapter.add_foreign_key_constraint(:books, :people, :referencing => :author_id) }
      it { should have_received(:execute).with("ALTER TABLE books ADD CONSTRAINT books_author_id_fk FOREIGN KEY (author_id) REFERENCES people (id)") }
    end

    context "with a given referenced attribute" do
      before { adapter.add_foreign_key_constraint(:books, :people, :referenced => :person_id) }
      it { should have_received(:execute).with("ALTER TABLE books ADD CONSTRAINT books_person_id_fk FOREIGN KEY (person_id) REFERENCES people (person_id)") }
    end

    context "with a given referencing attribute and referenced attribute" do
      before { adapter.add_foreign_key_constraint(:books, :people, :referencing => :author_id, :referenced => :person_id) }
      it { should have_received(:execute).with("ALTER TABLE books ADD CONSTRAINT books_author_id_fk FOREIGN KEY (author_id) REFERENCES people (person_id)") }
    end

    context "with a given name" do
      before { adapter.add_foreign_key_constraint(:books, :people, :name => :foo) }
      it { should have_received(:execute).with("ALTER TABLE books ADD CONSTRAINT foo FOREIGN KEY (person_id) REFERENCES people (id)") }
    end

    context "with a given on delete referential action" do
      before { adapter.add_foreign_key_constraint(:books, :people, :on_delete => :cascade) }
      it { should have_received(:execute).with("ALTER TABLE books ADD CONSTRAINT books_person_id_fk FOREIGN KEY (person_id) REFERENCES people (id) ON DELETE CASCADE") }
    end

    context "with a given on update referential action" do
      before { adapter.add_foreign_key_constraint(:books, :people, :on_update => :cascade) }
      it { should have_received(:execute).with("ALTER TABLE books ADD CONSTRAINT books_person_id_fk FOREIGN KEY (person_id) REFERENCES people (id) ON UPDATE CASCADE") }
    end

    context "with a 'cascade' on delete and update referential action" do
      before { adapter.add_foreign_key_constraint(:books, :people, :on_delete => :cascade, :on_update => :cascade) }
      it { should have_received(:execute).with("ALTER TABLE books ADD CONSTRAINT books_person_id_fk FOREIGN KEY (person_id) REFERENCES people (id) ON DELETE CASCADE ON UPDATE CASCADE") }
    end

    context "with a 'no action' on delete and update referential action" do
      before { adapter.add_foreign_key_constraint(:books, :people, :on_delete => :no_action, :on_update => :no_action) }
      it { should have_received(:execute).with("ALTER TABLE books ADD CONSTRAINT books_person_id_fk FOREIGN KEY (person_id) REFERENCES people (id) ON DELETE NO ACTION ON UPDATE NO ACTION") }
    end

    describe "with a given add_index option" do
      before { adapter.add_foreign_key_constraint(:books, :people, :add_index => true) }
      it { should have_received(:add_index).with(:books, :person_id) }
    end

    describe "with a referencing attribute and a add_index option" do
      before { adapter.add_foreign_key_constraint(:books, :people, :referencing => :author_id, :add_index => true) }
      it { should have_received(:add_index).with(:books, :author_id) }
    end
  end

  describe "#remove_foreign_key_constraint" do
    subject { adapter }

    before do
      adapter.stub(:execute)
      adapter.stub(:remove_index)
    end

    context "with no options" do
      before { adapter.remove_foreign_key_constraint(:books, :people) }
      it { should have_received(:execute).with("ALTER TABLE books DROP CONSTRAINT books_person_id_fk") }
    end

    context "with a given referencing attribute" do
      before { adapter.remove_foreign_key_constraint(:books, :people, :referencing => :author_id) }
      it { should have_received(:execute).with("ALTER TABLE books DROP CONSTRAINT books_author_id_fk") }
    end

    context "with a given name" do
      before { adapter.remove_foreign_key_constraint(:books, :people, :name => :foo) }
      it { should have_received(:execute).with("ALTER TABLE books DROP CONSTRAINT foo") }
    end

    describe "with a given remove_index option" do
      before { adapter.remove_foreign_key_constraint(:books, :people, :remove_index => true) }
      it { should have_received(:remove_index).with(:books, :person_id) }
    end

    describe "with a referencing attribute and a remove_index option" do
      before { adapter.remove_foreign_key_constraint(:books, :people, :referencing => :author_id, :remove_index => true) }
      it { should have_received(:remove_index).with(:books, :author_id) }
    end
  end
end
