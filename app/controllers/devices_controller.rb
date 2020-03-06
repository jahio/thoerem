class DevicesController < ApplicationController
  def register
    if params[:device]
      d = JSON.parse(params[:device], symbolize_names: true)[:device]
      if Device.create(serial_no: d[:serial_number], firmware_version: d[:firmware_version])
        render plain: "Device Registered", status: 200
      end
    else
      render plain: "Bad Request", status: 400
    end
  end
end