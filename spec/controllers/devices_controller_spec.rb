require 'rails_helper'

RSpec.describe DevicesController, type: :controller do
  describe "registering a device" do
    before :each do
      @json = <<~EOF
        {
          "device": {
            "serial_number":"#{SecureRandom.hex(5)}",
            "firmware_version":"#{SecureRandom.hex(5)}"
          }
        }
      EOF
    end

    it "registers a new device" do
      expect {
        post :register, params: { device: @json }
      }.to change { Device.count }.by(1)
    end
  end
end