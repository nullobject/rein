require 'spec_helper'

describe RC::Presence, "#add_presence_constraint" do
  let(:adapter) do
    Class.new do
      include RC::Presence
    end.new
  end

  subject { adapter }

  before { stub(adapter).execute }

  context "given a table and attribute" do
    before { adapter.add_presence_constraint(:books, :state) }
    it { should have_received.execute("ALTER TABLE books ADD CONSTRAINT books_state CHECK (state !~ '^\s*$')") }
  end
end
