# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
require 'csv'

book_data = CSV.read(Rails.root.join('db', 'books.csv'), headers: true, liberal_parsing: true)
authors = book_data.by_col['authors'].flat_map { _1.split('/') }.uniq.map { { name: _1 } }

Author.upsert_all(
  authors,
  unique_by: :name
)

Book.upsert_all(
  book_data.map do |book|
    {
      title: book['title'],
      average_rating: book['average_rating'],
      isbn: book['isbn'],
      isbn13: book['isbn13'],
      language_code: book['language_code'],
      num_pages: book['num_pages'],
      ratings_count: book['num_pages'],
      text_reviews_count: book['text_reviews_count'],
      published_on: (book['publication_date'].blank? ? nil : Date.strptime(book['publication_date'], '%m/%d/%Y')),
      publisher: book['publisher']
    }
  end,
  unique_by: :isbn
)

author_name_to_id = Author.pluck(:name, :id).to_h
book_isbn_to_id = Book.pluck(:isbn, :id).to_h

BookAuthor.upsert_all(
  book_data.flat_map do |book|
    book['authors'].split('/').map do |author_name|
      {
        book_id: book_isbn_to_id.fetch(book['isbn'], nil),
        author_id: author_name_to_id.fetch(author_name, nil)
      }
    end
  end
)

View.create!(name: "Books", parameters: {})
