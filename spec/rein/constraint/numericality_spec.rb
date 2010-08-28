require 'spec_helper'

describe RC::Numericality, ".add_numericality_constraint" do
  include RC::Numericality

  before do
    mock(self).execute(is_a(String)) {|sql| sql }
  end

  context "greater_than" do
    subject { add_numericality_constraint(:foo, :bar, :greater_than => 1) }
    it { should == "ALTER TABLE foo ADD CONSTRAINT bar CHECK (bar > 1)" }
  end

  context "greater_than_or_equal_to" do
    subject { add_numericality_constraint(:foo, :bar, :greater_than_or_equal_to => 2) }
    it { should == "ALTER TABLE foo ADD CONSTRAINT bar CHECK (bar >= 2)" }
  end

  context "equal_to" do
    subject { add_numericality_constraint(:foo, :bar, :equal_to => 3) }
    it { should == "ALTER TABLE foo ADD CONSTRAINT bar CHECK (bar == 3)" }
  end

  context "less_than" do
    subject { add_numericality_constraint(:foo, :bar, :less_than => 4) }
    it { should == "ALTER TABLE foo ADD CONSTRAINT bar CHECK (bar < 4)" }
  end

  context "less_than_or_equal_to" do
    subject { add_numericality_constraint(:foo, :bar, :less_than_or_equal_to => 5) }
    it { should == "ALTER TABLE foo ADD CONSTRAINT bar CHECK (bar <= 5)" }
  end

  context "greater_than_or_equal_to and less_than_or_equal_to" do
    subject { add_numericality_constraint(:foo, :bar, :greater_than_or_equal_to => 5, :less_than_or_equal_to => 6) }
    it { should == "ALTER TABLE foo ADD CONSTRAINT bar CHECK ((bar >= 5) AND (bar <= 6))" }
  end
end
