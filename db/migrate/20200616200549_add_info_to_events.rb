class AddInfoToEvents < ActiveRecord::Migration[6.0]
  def change
    add_column :events, :start, :string
    add_column :events, :end, :string
    add_column :events, :description, :string
    add_column :events, :price, :integer
  end
end
