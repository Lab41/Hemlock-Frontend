class Admin::HemlockUsersController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @hemlock_users = HemlockUser.all
  end
  
  def show
    @hemlock_user = HemlockUser.find(params[:id])
    @hemlock_tenants = @hemlock_user.tenants
    @hemlock_roles = @hemlock_user.roles
  end

end
