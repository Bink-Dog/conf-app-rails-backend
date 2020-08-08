class AddMaxAttendeesToEvents < ActiveRecord::Migration[6.0]
  def change
    add_column :events, :max_attendees, :integer, :null => false, :default => 50
    add_column :events, :event_length, :integer, :null => false, :default => 120
    add_column :events, :amount_paid, :integer, :null => false, :default => 0
  end
end
