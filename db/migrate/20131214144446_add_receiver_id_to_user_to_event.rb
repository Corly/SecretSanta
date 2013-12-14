class AddReceiverIdToUserToEvent < ActiveRecord::Migration
  def change
		add_column :user_to_events, :receiver_id, :integer	
  end
end
