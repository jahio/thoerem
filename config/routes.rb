Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

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
  #   }
  # }
  # 
  post '/t/:device_sn', to: 'telemetry#create'
end