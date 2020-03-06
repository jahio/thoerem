require 'rails_helper'

RSpec.describe TelemetryController, type: :controller do
  describe "single telemetry entry" do
    before :each do
      @device = Device.new(serial_no: SecureRandom.hex(5), firmware_version: SecureRandom.hex(3))
      @device.save
      expect(@device.telemetries.count).to eq 0
      #
      # Set up some telemetry JSON
      # 
      @t_hash = <<~EOF
        {
          "telemetry": {
            "carbon_monoxide":"0.01",
            "temp_c":"45.2",
            "humidity_percentage":"35.5"
          }
        }
      EOF

    end
    it "records single telemetry entries" do
      post :create, params: { device_sn: @device.serial_no, telemetry: @t_hash }, format: :json
      expect(response.status).to eq 200
    end
    it "throws a 400 (bad request) without device_sn and telemetry" do
      post :create, params: { device_sn: 'abc123' }
      expect(response.status).to eq 400
    end
  end
end