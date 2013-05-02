class Admin::HemlockSystemsController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @hemlock_systems = HemlockSystem.all
  end
  
  def show
    @hemlock_system = HemlockSystem.find(params[:id])
    @hemlock_tenants = @hemlock_system.tenants
  end

end
