class CreateAuthors < ActiveRecord::Migration[7.0]
  def change
    create_table :authors do |t|
      t.string :name, index: { unique: true }

      t.timestamps
    end
  end
end
