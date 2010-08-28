require 'spec_helper'

describe RC::Numericality, "#add_numericality_constraint" do
  let(:adapter) do
    Class.new do
      include RC::Numericality
    end.new
  end

  subject { adapter }

  before do
    stub(adapter).execute
  end

  context "greater_than" do
    before { adapter.add_numericality_constraint(:books, :published_month, :greater_than => 1) }
    it { should have_received.execute("ALTER TABLE books ADD CONSTRAINT published_month CHECK (published_month > 1)") }
  end

  context "greater_than_or_equal_to" do
    before { adapter.add_numericality_constraint(:books, :published_month, :greater_than_or_equal_to => 2) }
    it { should have_received.execute("ALTER TABLE books ADD CONSTRAINT published_month CHECK (published_month >= 2)") }
  end

  context "equal_to" do
    before { adapter.add_numericality_constraint(:books, :published_month, :equal_to => 3) }
    it { should have_received.execute("ALTER TABLE books ADD CONSTRAINT published_month CHECK (published_month == 3)") }
  end

  context "less_than" do
    before { adapter.add_numericality_constraint(:books, :published_month, :less_than => 4) }
    it { should have_received.execute("ALTER TABLE books ADD CONSTRAINT published_month CHECK (published_month < 4)") }
  end

  context "less_than_or_equal_to" do
    before { adapter.add_numericality_constraint(:books, :published_month, :less_than_or_equal_to => 5) }
    it { should have_received.execute("ALTER TABLE books ADD CONSTRAINT published_month CHECK (published_month <= 5)") }
  end

  context "greater_than_or_equal_to and less_than_or_equal_to" do
    before { adapter.add_numericality_constraint(:books, :published_month, :greater_than_or_equal_to => 5, :less_than_or_equal_to => 6) }
    it { should have_received.execute("ALTER TABLE books ADD CONSTRAINT published_month CHECK (published_month >= 5 AND published_month <= 6)") }
  end
end
