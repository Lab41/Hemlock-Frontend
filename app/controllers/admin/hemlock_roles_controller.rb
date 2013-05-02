class Admin::HemlockRolesController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @hemlock_roles = HemlockRole.all
  end
  
  def show
    @hemlock_role = HemlockRole.find(params[:id])
    @hemlock_users = @hemlock_role.users
  end

end
