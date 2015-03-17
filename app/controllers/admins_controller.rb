class AdminsController < ApplicationController
  before_action :require_admin
   
  private
  def require_admin
    if !current_user.admin?
      flash[:error] = 'Sorry but you are not authorized to do that.'
      redirect_to home_path
    end
  end
end
