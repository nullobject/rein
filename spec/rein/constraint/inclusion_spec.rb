require 'spec_helper'

describe RC::Inclusion, "#add_inclusion_constraint" do
  let(:adapter) do
    Class.new do
      include RC::Inclusion
    end.new
  end

  subject { adapter }

  before do
    stub(adapter).execute
  end

  context "with a given array of values" do
    before { adapter.add_inclusion_constraint(:books, :state, :in => [:on_shelf, :on_loan]) }
    it { should have_received.execute("ALTER TABLE books ADD CONSTRAINT books_state CHECK (state IN ('on_shelf', 'on_loan'))") }
  end
end
