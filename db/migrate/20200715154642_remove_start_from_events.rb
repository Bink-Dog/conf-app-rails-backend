class RemoveStartFromEvents < ActiveRecord::Migration[6.0]
  def change
    remove_column :events, :start, :string
  end
end
