class AddEventIdToEbAttendees < ActiveRecord::Migration[6.0]
  def change
    add_column :eb_attendees, :event_id, :string
  end
end
