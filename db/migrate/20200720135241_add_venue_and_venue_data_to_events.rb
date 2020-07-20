class AddVenueAndVenueDataToEvents < ActiveRecord::Migration[6.0]
  def change
    add_column :events, :venue, :string
    add_column :events, :venueData, :string
  end
end
