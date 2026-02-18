class CreateGithubAuthTokens < ActiveRecord::Migration[8.1]
  def change
    create_table :github_auth_tokens do |t|
      t.string :token, null: false
      t.datetime :expire_date

      t.timestamps
    end
  end
end
