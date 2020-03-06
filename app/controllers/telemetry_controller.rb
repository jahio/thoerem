class TelemetryController < ApplicationController

  #
  # bulk_update vs create
  #   The bulk_update method is intended for devices that are sending multiple
  #   telemetry events in one payload (see corresponding spec for JSON
  #   example), whereas the create method is intended for singular
  #   minute-by-minute updates containing only one update of telemetry data
  #   per request.
  #   

  def bulk_update
    if params[:telemetry] && params[:device_sn]
      #
      # Here we expect 
    else
      render plain: "Bad Request", status: 400
    end
  end

  def create
    if params[:telemetry] && params[:device_sn]
      @device = Device.find_by_serial_no(params[:device_sn])
      t = (JSON.parse(params[:telemetry], symbolize_names: true)[:telemetry])
      @device.telemetries << Telemetry.new(
        temp_c: t[:temp_c],
        humidity_percentage: t[:humidity_percentage],
        carbon_monoxide: t[:carbon_monoxide]
      )
      render plain: 'Telemetry Recorded', status: 200
    else
      render plain: 'Bad Request', status: 400
    end
  end
end