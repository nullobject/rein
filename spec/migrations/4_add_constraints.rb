class AddConstraints < Migration
  def change
    add_foreign_key_constraint :books, :authors, on_delete: :cascade, index: true
    add_unique_constraint :books, :isbn
    add_exclusion_constraint :book_owners, [[:book_id, '=']]
    add_presence_constraint :books, :title
    add_inclusion_constraint :books, :state, in: %w[available on_loan on_hold]
    add_match_constraint :books, :title, accepts: '\A[a-zA-Z0-9\s]*\Z', rejects: '\t'
    add_numericality_constraint :books, :published_month, greater_than_or_equal_to: 1, less_than_or_equal_to: 12
    add_null_constraint :books, :due_date, if: "state = 'on_loan'"
    add_presence_constraint :books, :holder, if: "state = 'on_hold'"
    add_length_constraint :books, :call_number, greater_than_or_equal_to: 1, less_than_or_equal_to: 255
  end
end
