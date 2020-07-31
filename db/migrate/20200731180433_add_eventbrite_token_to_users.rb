class AddEventbriteTokenToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :eventbrite_token, :string
  end
end
