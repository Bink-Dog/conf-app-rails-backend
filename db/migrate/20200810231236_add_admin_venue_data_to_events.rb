class AddAdminVenueDataToEvents < ActiveRecord::Migration[6.0]
  def change
    add_column :events, :admin_venue_data, :string, :null => false, :default => '{}'
  end
end
