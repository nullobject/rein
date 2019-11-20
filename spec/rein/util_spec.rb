require 'spec_helper'

RSpec.describe Rein::Util do
  describe '.add_not_valid_suffix_if_required' do
    let(:sql) { '' }

    it 'adds the suffix if validate is false' do
      expect(
        described_class.add_not_valid_suffix_if_required(sql, validate: false)
      ).to eq ' NOT VALID'
    end

    it 'does not add the suffix if validate is not provided' do
      expect(
        described_class.add_not_valid_suffix_if_required(sql, {})
      ).to eq sql
    end
  end

  describe '.wrap_identifier' do
    it 'wraps identifiers' do
      expect(Rein::Util.wrap_identifier('foo')).to eq('"foo"')
    end

    it "doesn't re-wrap identifiers" do
      expect(Rein::Util.wrap_identifier('"foo"')).to eq('"foo"')
    end
  end
end
