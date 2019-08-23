require 'spec_helper'

class TableConstraint < ActiveRecord::Base
  self.table_name = 'information_schema.table_constraints'
end

class View < ActiveRecord::Base
  self.table_name = 'information_schema.views'
end

module Migrator
  module_function

  def migrate
    if ActiveRecord.version.release >= Gem::Version.new('6.0.0')
      ActiveRecord::MigrationContext.new(MIGRATIONS_PATH, ActiveRecord::SchemaMigration).migrate
    elsif ActiveRecord.version.release >= Gem::Version.new('5.2.0')
      ActiveRecord::MigrationContext.new(MIGRATIONS_PATH).migrate
    else
      ActiveRecord::Migrator.migrate(MIGRATIONS_PATH)
    end
  end

  def down(*args)
    if ActiveRecord.version.release >= Gem::Version.new('6.0.0')
      ActiveRecord::MigrationContext.new(MIGRATIONS_PATH, ActiveRecord::SchemaMigration).down(*args)
    elsif ActiveRecord.version.release >= Gem::Version.new('5.2.0')
      ActiveRecord::MigrationContext.new(MIGRATIONS_PATH).down(*args)
    else
      ActiveRecord::Migrator.down(MIGRATIONS_PATH, *args)
    end
  end
end

RSpec.describe 'Reversible' do
  before do
    Migrator.migrate
  end

  it 'reverses check constraints' do
    expect(TableConstraint.where(constraint_name: 'no_r_titles')).to exist
    Migrator.down(2)
    expect(TableConstraint.where(constraint_name: 'no_r_titles')).to_not exist
  end

  it 'reverses foreign key constraints' do
    expect(TableConstraint.where(constraint_name: 'books_author_id_fk')).to exist
    Migrator.down(2)
    expect(TableConstraint.where(constraint_name: 'books_author_id_fk')).to_not exist
  end

  it 'reverses unique constraints' do
    expect(TableConstraint.where(constraint_name: 'books_isbn_unique')).to exist
    Migrator.down(2)
    expect(TableConstraint.where(constraint_name: 'books_isbn_unique')).to_not exist
  end

  it 'reverses inclusion constraints' do
    expect(TableConstraint.where(constraint_name: 'books_state_inclusion')).to exist
    Migrator.down(2)
    expect(TableConstraint.where(constraint_name: 'books_state_inclusion')).to_not exist
  end

  it 'reverses null constraints' do
    expect(TableConstraint.where(constraint_name: 'books_due_date_null')).to exist
    Migrator.down(2)
    expect(TableConstraint.where(constraint_name: 'books_due_date_null')).to_not exist
  end

  it 'reverses numericality constraints' do
    expect(TableConstraint.where(constraint_name: 'books_published_month_numericality')).to exist
    Migrator.down(2)
    expect(TableConstraint.where(constraint_name: 'books_published_month_numericality')).to_not exist
  end

  it 'reverses presence constraints' do
    expect(TableConstraint.where(constraint_name: 'books_title_presence')).to exist
    Migrator.down(2)
    expect(TableConstraint.where(constraint_name: 'books_title_presence')).to_not exist
  end

  it 'reverses views' do
    expect(View.where(table_name: 'books_per_author')).to exist
    Migrator.down(2)
    expect(View.where(table_name: 'books_per_author')).to_not exist
  end
end
