class AddConstraints < Migration
  def change
    add_check_constraint :books, "substring(title FROM 1 FOR 1) IS DISTINCT FROM 'r'", name: 'no_r_titles', validate: false
    validate_table_constraint :books, 'no_r_titles'

    add_foreign_key_constraint :books, :authors, on_delete: :cascade, index: true, validate: false
    validate_table_constraint :books, 'books_author_id_fk'

    add_unique_constraint :books, :isbn

    add_exclusion_constraint :book_owners, [[:book_id, '=']]

    add_presence_constraint :books, :title, validate: false
    validate_table_constraint :books, 'books_title_presence'

    add_inclusion_constraint :books, :state, in: %w[available on_loan on_hold], validate: false
    validate_table_constraint :books, 'books_state_inclusion'

    add_match_constraint :books, :title, accepts: '\A[a-zA-Z0-9\s]*\Z', rejects: '\t', validate: false
    validate_table_constraint :books, 'books_title_match'

    add_numericality_constraint :books, :published_month, greater_than_or_equal_to: 1, less_than_or_equal_to: 12, validate: false
    validate_table_constraint :books, 'books_published_month_numericality'

    add_null_constraint :books, :due_date, if: "state = 'on_loan'", validate: false
    validate_table_constraint :books, 'books_due_date_null'

    add_presence_constraint :books, :holder, if: "state = 'on_hold'", validate: false
    validate_table_constraint :books, 'books_holder_presence'

    add_length_constraint :books, :call_number, greater_than_or_equal_to: 1, less_than_or_equal_to: 255, validate: false
    validate_table_constraint :books, 'books_call_number_length'
  end
end
