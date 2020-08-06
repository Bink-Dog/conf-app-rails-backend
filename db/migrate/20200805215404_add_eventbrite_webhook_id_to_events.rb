class AddEventbriteWebhookIdToEvents < ActiveRecord::Migration[6.0]
  def change
    add_column :events, :eventbrite_webhook_id, :string
  end
end
