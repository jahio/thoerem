class TelemetryController < ApplicationController

  def create
    if params[:telemetry] && params[:device_sn]
      #
      # Here we expect params[:telemetry] to be an array of at most 500 elements
      # that we can then parse and loop through to create individual telmetry
      # objects.
      #
      # Note that since we're dealing with a LOT of objects here potentially,
      # we _could_ use Rails 6's insert_all method. The problem with this
      # approach, however, is that it bypasses ActiveModel/ActiveRecord, not
      # instantiating objects and therefore not running callbacks on save.
      # Without those callbacks, we could have somewhat errant data inserted
      # by a given device/API client. This is why we're not making use of it
      # here, even though it would be more efficient. We want *correct* data,
      # not a bunch of junk.
      #
      JSON.parse(params[:telemetry], symbolize_names: true)[:telemetry].each do |t|
        #
        # TODO: implement some kind of counter so we don't process more than
        # say 500 of these at a time.
        #
        # NOTE: Whatever app server we use here (Passenger, Unicorn, etc.),
        # we should increase the length of a request timeout.
        #
        device = Device.find_by_serial_no(params[:device_sn])
        device.telemetries << Telemetry.new(
          temp_c: t[:temp_c],
          humidity_percentage: t[:humidity_percentage],
          carbon_monoxide: t[:carbon_monoxide],
          health: t[:health],
          recorded_at: t[:recorded_at]
        )
      end
      render plain: "Telemetry Recorded", status: 200
    else
      render plain: "Bad Request", status: 400
    end
  end
end