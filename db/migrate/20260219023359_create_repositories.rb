class CreateRepositories < ActiveRecord::Migration[8.1]
  def change
    create_table :repositories do |t|
      t.string :owner, null: false
      t.string :name, null: false
      t.string :added_method, null: false, default: 'auto'

      t.timestamps
    end
  end
end
