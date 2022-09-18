class View < ApplicationRecord
<<<<<<< Updated upstream
  validates :name, presence: true
=======
  def parameters
    JSON.parse(super)
  end

  def parameters=(value)
    super(value.to_json)
  end
>>>>>>> Stashed changes
end
