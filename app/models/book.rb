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
      title: :text,
      average_rating: :numeric,
      isbn: :string,
      isbn13: :string,
      language_code: :enum,
      num_pages: :numeric,
      ratings_count: :numeric,
      text_reviews_count: :numeric,
      published_on: :date,
      publisher: :string,
      created_at: :datetime,
      updated_at: :datetime
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
