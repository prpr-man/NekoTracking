class PositionsController < ApplicationController
  def index
    gon.lat = Position.select('latitude')
    gon.lng = Position.select('longitude') 
  end

  def create
    Position.create(latitude: params[:lat], longitude: params[:lng]) unless params[:lat].blank? && params[:lng].blank?
    
    gon

    position = JSON.generate({:lat => params[:lat], :lng => params[:lng], :count => Position.count})
    WebsocketRails[:broadcast_channel].trigger :new_position, position
  end
end
