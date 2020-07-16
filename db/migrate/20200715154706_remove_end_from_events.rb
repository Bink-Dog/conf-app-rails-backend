class RemoveEndFromEvents < ActiveRecord::Migration[6.0]
  def change
    remove_column :events, :end, :string
  end
end
