class Book < ApplicationRecord
  has_many :book_authors
  has_many :authors, through: :book_authors

  # Whitelist the model attributes for sorting
  def self.ransortable_attributes(_auth_object = nil)
    column_names - ['id', 'created_at', 'updated_at', 'isbn13']
  end

  # Whitelist the model attributes for search
  def self.ransackable_attributes(_auth_object = nil)
    ransortable_attributes + _ransackers.keys
  end

  def self.primary_attribute
    'title'
  end

  def self.attribute_schema
    {
      title: { type: :text, width: "500px", sort: { asc: "A ⮕ Z", desc: "Z ⮕ A", icon: "alpha" } },
      average_rating: { type: :decimal, width: nil, sort: { asc: "1 ⮕ 9", desc: "9 ⮕ 1", icon: "numeric" } },
      isbn: { type: :numeric, width: nil, sort: { asc: "0 ⮕ 9", desc: "9 ⮕ 0", icon: "numeric" } },
      isbn13: { type: :numeric, width: nil, sort: { asc: "0 ⮕ 9", desc: "9 ⮕ 0", icon: "numeric" } },
      language_code: { type: :enum, width: nil, sort: { asc: "first ⮕ last", desc: "last ⮕ first", icon: nil } },
      num_pages: { type: :numeric, width: nil, sort: { asc: "1 ⮕ 9", desc: "9 ⮕ 1", icon: "numeric" } },
      ratings_count: { type: :numeric, width: nil, sort: { asc: "1 ⮕ 9", desc: "9 ⮕ 1", icon: "numeric" } },
      text_reviews_count: { type: :numeric, width: nil, sort: { asc: "1 ⮕ 9", desc: "9 ⮕ 1", icon: "numeric" } },
      published_on: { type: :date, width: nil, sort: { asc: "1 ⮕ 9", desc: "9 ⮕ 1", icon: "numeric" } },
      publisher: { type: :string, width: nil, sort: { asc: "A ⮕ Z", desc: "Z ⮕ A", icon: "alpha" } },
      created_at: { type: :datetime, width: nil, sort: { asc: "1 ⮕ 9", desc: "9 ⮕ 1", icon: "numeric" } },
      updated_at: { type: :datetime, width: nil, sort: { asc: "1 ⮕ 9", desc: "9 ⮕ 1", icon: "numeric" } }
    }
  end
  
  def self.to_csv(csv_attributes = [], include_blank = false)
    attributes = if defined?(csv_attributes) && csv_attributes.any?
      csv_attributes
    else
      attribute_names - ["created_at", "updated_at"]
    end
  
    CSV.generate(headers: true, col_sep: ";") do |csv|
      csv << attributes
  
      all.each do |record|
        csv << record.attributes.values_at(*attributes)
      end
  
      csv << [nil] * attributes.size if include_blank
    end
  end
end
