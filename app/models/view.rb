class View < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  serialize :parameters, JSON
end
