class AddStaticVenueDataToEvents < ActiveRecord::Migration[6.0]
  def change
    add_column :events, :static_venue_data, :string, :null => false, :default => '{}'
  end
end
