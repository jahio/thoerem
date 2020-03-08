Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  post '/login', to: 'admin#login'
  get  '/auth',  to: 'admin#index', as: :auth
  get  '/admin/dashboard', to: 'admin#dashboard', as: :dashboard
  get  '/admin/logout', to: 'admin#logout', as: :logout
  get  '/devices/:device_sn', to: 'admin#device_by_sn', as: :device_by_sn
  post '/notifications/:notification_id/dismiss', to: 'admin#dismiss_notification', as: :dismiss_notification

  #
  # POST /t/abc123
  # Expects a param of "telemetry" that is JSON specifying the telemetry
  # information to be recorded for device with a serial number of abc123:
  #
  # {
  #   "telemetry":
  #   [
  #     {
  #       "carbon_monoxide":"0.01",
  #       "temp_c":"45.2",
  #       "humidity_percentage":"35.5"
  #     }
  #   ]
  # }
  #
  post '/t/:device_sn', to: 'telemetry#create'
  post '/register', to: 'devices#register'

  root to: 'admin#login'
end