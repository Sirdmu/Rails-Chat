class RoomMessagesController < ApplicationController
  before_action :load_entities

  def create
    message = params.dig(:room_message, :message)
    has_gif = message.split.include?"!gif"
    gif_url = nil
    if has_gif 
      query_index = message.split.index("!gif") + 1
      term = message.split[query_index]
      response = HTTParty.get("https://api.giphy.com/v1/gifs/search?api_key=#{ENV['GIPHY_API_KEY']}&q=#{term}&limit=1")
      gif_url = response.parsed_response["data"][0]["embed_url"]

      # message = "<image src='#{gif_url}'>"
    end
    # p message
    # response = HTTParty.get("https://api.giphy.com/v1/gifs/search?api_key=#{ENV['GIPHY_API_KEY']}&q=cheeseburger&limit=1")
    # p response.parsed_response["data"][0]["embed_url"]
    @room_message = RoomMessage.create user: current_user,
                                       room: @room,
                                       message: message,
                                       link: gif_url
    RoomChannel.broadcast_to @room, @room_message
  end

  protected

  def load_entities
    @room = Room.find params.dig(:room_message, :room_id)
  end
end
