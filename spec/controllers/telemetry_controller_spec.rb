require 'rails_helper'

RSpec.describe TelemetryController, type: :controller do
  describe "bulk insert" do
    before :each do
      @json = <<~EOF
        {
          "telemetry": [
            {
              "carbon_monoxide":"0.05",
              "temp_c":"22.3",
              "humidity_percentage":"75.5"
            },
            {
              "carbon_monoxide":"0.05",
              "temp_c":"22.3",
              "humidity_percentage":"75.5"
            },
            {
              "carbon_monoxide":"0.05",
              "temp_c":"22.3",
              "humidity_percentage":"75.5"
            }
          ]
        }
      EOF
    end
    it "records all the records provided" do
      @device = Device.new(serial_no: SecureRandom.hex(5), firmware_version: SecureRandom.hex(3))
      @device.save
      expect(@device.telemetries.count).to eq 0
      expect {
        post :create, params: { device_sn: @device.serial_no, telemetry: @json }
        expect(response.status).to eq 200
      }.to change { @device.reload.telemetries.count }.by(3)
    end
  end
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
          "telemetry": [
            {
              "carbon_monoxide":"0.01",
              "temp_c":"45.2",
              "humidity_percentage":"35.5"
            }
          ]
        }
      EOF

    end
    it "records single telemetry entries" do
      expect {
        post :create, params: { device_sn: @device.serial_no, telemetry: @t_hash }, format: :json
      }.to change { @device.reload.telemetries.count }.by(1)
      expect(response.status).to eq 200
    end
    it "throws a 400 (bad request) without device_sn and telemetry" do
      expect {
        post :create, params: { device_sn: 'abc123' }
      }.to_not change { @device.reload.telemetries.count }
      expect(response.status).to eq 400
    end
  end
end