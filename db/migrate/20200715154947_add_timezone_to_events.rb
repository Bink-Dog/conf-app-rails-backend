class AddTimezoneToEvents < ActiveRecord::Migration[6.0]
  def change
    add_column :events, :timezone, :string
  end
end
