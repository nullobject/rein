class CreateBooksPerAuthorView < CompatibleMigration
  def change
    create_view(
      :books_per_author,
      "SELECT author_id, count(id) FROM books GROUP BY author_id"
    )
  end
end
