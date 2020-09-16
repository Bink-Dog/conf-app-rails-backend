class CreateLivestreams < ActiveRecord::Migration[6.0]
  def change
    create_table :livestreams do |t|
      t.string :mux_id, null: false
      t.timestamp :last_update, null: false
      t.string :data, null: false

      t.timestamps
    end
    add_index :livestreams, :mux_id, unique: true
  end
end
