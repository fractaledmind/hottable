class View < ApplicationRecord
  validates :name, presence: true

  serialize :parameters, JSON
end
