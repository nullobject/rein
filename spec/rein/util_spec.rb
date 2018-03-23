require 'spec_helper'

RSpec.describe Rein::Util do
  describe '.wrap_identifier' do
    it 'wraps identifiers' do
      expect(Rein::Util.wrap_identifier('foo')).to eq('"foo"')
    end

    it "doesn't re-wrap identifiers" do
      expect(Rein::Util.wrap_identifier('"foo"')).to eq('"foo"')
    end
  end
end
