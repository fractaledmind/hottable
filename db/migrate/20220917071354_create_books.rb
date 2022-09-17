class CreateBooks < ActiveRecord::Migration[7.0]
  def change
    create_table :books do |t|
      t.string :title
      t.decimal :average_rating, precision: 3, scale: 2
      t.string :isbn, index: { unique: true }
      t.string :isbn13
      t.string :language_code
      t.integer :num_pages
      t.integer :ratings_count
      t.integer :text_reviews_count
      t.date :published_on
      t.string :publisher

      t.timestamps
    end
  end
end
