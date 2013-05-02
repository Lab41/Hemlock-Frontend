class HomeController < ApplicationController
  def index
    if current_user
      @hemlock_users = HemlockUser.all
      @hemlock_systems = HemlockSystem.all
      @hemlock_tenants = HemlockTenant.all
    else
      redirect_to new_user_registration_url unless user_signed_in?
    end
  end
end
