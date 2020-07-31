class AddEventbriteIdToEvents < ActiveRecord::Migration[6.0]
  def change
    add_column :events, :eventbrite_id, :string
  end
end
