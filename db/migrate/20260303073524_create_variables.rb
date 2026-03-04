class CreateVariables < ActiveRecord::Migration[8.1]
  def change
    create_table :variables do |t|
      t.string :name, null: false
      t.string :format
      t.references :repository, null: false, foreign_key: true
      t.timestamps
    end
  end
end
