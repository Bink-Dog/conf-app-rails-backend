class AddHostUserToEvents < ActiveRecord::Migration[6.0]
  def change
    add_column :events, :host_user, :integer
  end
end
