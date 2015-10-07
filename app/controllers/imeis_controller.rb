class ImeisController < ApplicationController
  def create
    state = params[:imei][:private].blank? ? false : true
    @imei = Imei.create(user_id: params[:imei][:user_id], number: params[:imei][:number], private: state)
    redirect_to edit_user_registration_path
  end

  def update
    imei = Imei.find(params[:imei][:id])
    imei.private = params[:imei][:private].blank? ? false : true
    imei.save

    redirect_to edit_user_registration_path
  end

  def destroy
    Imei.find(params[:id]).destroy
    redirect_to edit_user_registration_path
  end
end
