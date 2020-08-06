class AddEventbriteUserIdToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :eventbrite_user_id, :string
  end
end
