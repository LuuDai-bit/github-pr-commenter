class CreateCommentTemplates < ActiveRecord::Migration[8.1]
  def change
    create_table :comment_templates do |t|
      t.text :content, null: false
      t.string :status, null: false, default: 'draft'
      t.references :repository, null: false, foreign_key: true

      t.timestamps
    end
  end
end
