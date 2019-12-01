class RoomMessagesController < ApplicationController
  before_action :load_entities

  def create
    response = HTTParty.get("https://api.giphy.com/v1/gifs/search?api_key=#{ENV['GIPHY_API_KEY']}&q=cheeseburger&limit=1")
    p response.parsed_response["data"][0]["embed_url"]
    @room_message = RoomMessage.create user: current_user,
                                       room: @room,
                                       message: params.dig(:room_message, :message)
    RoomChannel.broadcast_to @room, @room_message
  end

  protected

  def load_entities
    @room = Room.find params.dig(:room_message, :room_id)
  end
end
