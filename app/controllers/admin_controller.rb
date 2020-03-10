class AdminController < ApplicationController
  before_action :authenticate, except: [:index, :login]
  before_action :verify_params, only: [:device_by_sn]

  def index
    # Display the login form
  end

  def dismiss_notification
    unless @notification = Notification.find(params[:notification_id])
      render plain: "Notification not found", status: 404
      return false
    end
    @notification.dismissed = true
    @notification.save
    redirect_to :dashboard
  end

  def device_by_sn
    @device = Device.find_by_serial_no(params[:device_sn].upcase)
    @telemetry_entries = Telemetry.where(device: @device).order(recorded_at: :desc).page(params[:page])

    #
    # Here we define a default timeframe for the data points to put on the graph
    # By default it's 1 day, but if params[:time] is one of day, week, month or year
    # it'll use that instead.
    #
    if params[:time]
      time = params[:time]
    else
      time = "week"
    end

    #
    # Look up telemetry data for the device over the last 24 hours
    # NOTE: This query should *definitely* be optimized. Each hour returned
    # will result in 60 rows of data and 60 * 24 = 1,440 rows. JUST FOR A GRAPH.
    #
    @telemetries = Telemetry.where('recorded_at > ? AND device_id = ?', 1.send(time.to_sym).ago, @device.id).order(recorded_at: :asc)
  end

  def logout
    cookies[:auth] = nil
    redirect_to :auth
  end

  def dashboard
    @notifications = Notification.where(dismissed: false).order(created_at: :desc).page(params[:n_page])
    @devices = Device.order(created_at: :asc).page(params[:page])
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

  def verify_params
    #
    # Ensure we only have whitelisted param values for time
    #
    if params[:time] && !params[:time].blank?
      times = ['day', 'week', 'month', 'year']
      if !times.include?(params[:time])
        redirect_to :dashboard
        return false
      end
    end
  end

end