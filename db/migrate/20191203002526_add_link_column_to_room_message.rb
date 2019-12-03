class AddLinkColumnToRoomMessage < ActiveRecord::Migration[5.2]
  def change
    add_column :room_messages, :link, :string
  end
end
