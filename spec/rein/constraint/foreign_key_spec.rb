require 'spec_helper'

describe RC::ForeignKey, "#add_foreign_key_constraint" do
  include RC::ForeignKey

  before do
    mock(self).execute(is_a(String)) {|sql| sql }
  end

  context "with no options" do
    subject { add_foreign_key_constraint(:books, :people) }
    it { should == "ALTER TABLE books ADD CONSTRAINT person_id_fk FOREIGN KEY (person_id) REFERENCES people (id)" }
  end

  context "with a given referencing attribute" do
    subject { add_foreign_key_constraint(:books, :people, :referencing => :author_id) }
    it { should == "ALTER TABLE books ADD CONSTRAINT author_id_fk FOREIGN KEY (author_id) REFERENCES people (id)" }
  end

  context "with a given name" do
    subject { add_foreign_key_constraint(:books, :people, :name => :foo) }
    it { should == "ALTER TABLE books ADD CONSTRAINT foo FOREIGN KEY (person_id) REFERENCES people (id)" }
  end

  context "with a given on delete referential action" do
    subject { add_foreign_key_constraint(:books, :people, :on_delete => :restrict) }
    it { should == "ALTER TABLE books ADD CONSTRAINT person_id_fk FOREIGN KEY (person_id) REFERENCES people (id) ON DELETE RESTRICT" }
  end

  context "with a given on update referential action" do
    subject { add_foreign_key_constraint(:books, :people, :on_update => :restrict) }
    it { should == "ALTER TABLE books ADD CONSTRAINT person_id_fk FOREIGN KEY (person_id) REFERENCES people (id) ON UPDATE RESTRICT" }
  end

  context "with a given on delete and update referential action" do
    subject { add_foreign_key_constraint(:books, :people, :on_delete => :cascade, :on_update => :cascade) }
    it { should == "ALTER TABLE books ADD CONSTRAINT person_id_fk FOREIGN KEY (person_id) REFERENCES people (id) ON DELETE CASCADE ON UPDATE CASCADE" }
  end
end
