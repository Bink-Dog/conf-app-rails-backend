class ChangeRoleColumnInUserEvents < ActiveRecord::Migration[6.0]
  def change
    execute "UPDATE user_events SET role = 'Attendee' "
    change_column :user_events, :role, :string, :null => false, :default => 'Attendee'
  end
end
