class PositionsController < ApplicationController
  def index
    gon.lat = []
    gon.lng = []

    if user_signed_in?
      ps = Position.where("created_at >= ?", 1.hour.ago)
      ps.each do |p|
        current_user.imeis.each do |imei|
          if p.imei.to_s.include?(imei.number.to_s) && imei.private
            gon.lat.push(p.latitude)
            gon.lng.push(p.longitude)
          elsif
            imeis = Imei.where("private = ?", false)
            imeis.each do |im|
              if p.imei.to_s.include?(im.number.to_s)
                gon.lat.push(p.latitude.to_f)
                gon.lng.push(p.longitude.to_f)
              end
            end
          end
        end
      end
    else
      imeis = Imei.where("private = ?", false)
      ps = Position.where("created_at >= ?", 1.hour.ago)
      ps.each do |p|
        imeis.each do |imei|
          if p.imei.to_s.include?(imei.number.to_s)
            gon.lat.push(p.latitude.to_f) 
            gon.lng.push(p.longitude.to_f)
          end
        end
      end
    end

    gon.id = user_signed_in? ? current_user.id : nil
  end

  def create
    params[:imei] = "211473"
    Position.create(latitude: params[:lat], longitude: params[:lng], imei: params[:imei]) unless params[:lat].blank? && params[:lng].blank?
    position = JSON.generate({:lat => params[:lat], :lng => params[:lng], :count => Position.count})
    
    flag = true

    users = User.all
    imeis = Imei.all
    imeis.each do |imei|
      if params[:imei].include?(imei.number)
        if !imei.private
          users.each do |user|
            WebsocketRails[user.id.to_s].trigger :new_position, position
          end
          flag = false
        else
          users.each do |user|
            user.imeis.each do |u_imei|
              if u_imei.number == imei.number
                p "ok"
                WebsocketRails[user.id.to_s].trigger :new_position, position
                flag = false
              end
            end
          end 
        end  
      end
    end
  
    if flag
      imeis.each do |imei|
        if params[:imei].include?(imei.number) && !imei.private
          WebsocketRails[:broadcast_channel].trigger :new_position, position
        end
      end
    end
  

  end
end
