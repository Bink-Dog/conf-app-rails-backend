class CreateEbAttendees < ActiveRecord::Migration[6.0]
  def change
    create_table :eb_attendees do |t|
      t.string :user_eventbrite_id
      t.string :email
      t.boolean :used

      t.timestamps
    end
  end
end
