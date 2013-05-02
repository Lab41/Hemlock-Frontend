class Admin::HemlockTenantsController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @hemlock_tenants = HemlockTenant.all
  end
  
  def show
    @hemlock_tenant = HemlockTenant.find(params[:id])
    @hemlock_users = @hemlock_tenant.users
    @hemlock_systems = @hemlock_tenant.systems
  end

end
