class TelemetryController < ApplicationController

  def create
    if params[:telemetry] && params[:device_sn]
      @device = Device.find_by_serial_no(params[:device_sn])
      t = (JSON.parse(params[:telemetry]).symbolize_keys)[:telemetry].symbolize_keys
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