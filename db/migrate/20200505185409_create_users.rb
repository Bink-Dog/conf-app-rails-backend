class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :name
      t.string :uid
      t.string :auth_provider
      t.string :auth_token
      t.string :twitter_handle
      t.string :github_username
      t.string :company
      t.string :bio
      t.string :image_url

      t.timestamps
    end
  end
end
