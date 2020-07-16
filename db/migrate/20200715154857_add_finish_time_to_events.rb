class AddFinishTimeToEvents < ActiveRecord::Migration[6.0]
  def change
    add_column :events, :finish_time, :datetime
  end
end
