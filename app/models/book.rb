class Book < ApplicationRecord
  has_many :book_authors
  has_many :authors, through: :book_authors

  # Whitelist the model attributes for sorting
  def self.ransortable_attributes(_auth_object = nil)
    column_names - ['id', 'created_at', 'updated_at']
  end

  # Whitelist the model attributes for search
  def self.ransackable_attributes(_auth_object = nil)
    ransortable_attributes + _ransackers.keys
  end
end
