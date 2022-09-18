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
      title: { type: :text, width: "500px" },
      average_rating: { type: :numeric, width: nil },
      isbn: { type: :string, width: nil },
      isbn13: { type: :string, width: nil },
      language_code: { type: :enum, width: nil },
      num_pages: { type: :numeric, width: nil },
      ratings_count: { type: :numeric, width: nil },
      text_reviews_count: { type: :numeric, width: nil },
      published_on: { type: :date, width: nil },
      publisher: { type: :string, width: nil },
      created_at: { type: :datetime, width: nil },
      updated_at: { type: :datetime, width: nil }
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
