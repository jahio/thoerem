class AdminController < ApplicationController
  before_action :authenticate, except: [:index, :login]

  def index
    # Display the login form
  end

  def logout
    cookies[:auth] = nil
    redirect_to :auth
  end

  def dashboard
    @notifications = Notification.where(dismissed: false)
  end

  #
  # A word about the "security" in use here:
  #   In a perfect world, we'd have time to build a proper authentication
  #   system with support for multiple admins, registering them, sending
  #   invite links, all that. But for the very first _prototype_, non-production
  #   iteration of this app, a hard-coded user/pass is just fine. This can
  #   be extended later as needed.
  #
  def login
    if params[:username] && params[:username] == 'admin'
      if params[:password] && params[:password] == 'lolpassword'
        cookies[:auth] = params[:password]
        redirect_to :dashboard
      else
        redirect_to :auth, error: "Wrong username or password"
      end
    else
      redirect_to :auth, error: "Wrong username or password"
    end
  end

  private

  def authenticate
    if cookies[:auth] && cookies[:auth] == 'lolpassword'
      return true
    end
    redirect_to :auth, error: "Login required"
  end
end