require 'rails_helper'

RSpec.describe Telemetry, type: :model do
  describe "validations" do
    before :each do
      @device = Device.new(serial_no: "abc123", firmware_version: "123.45")
      @t = Telemetry.new(
        device:              @device,
        temp_c:              9.3,
        humidity_percentage: 33.5,
        carbon_monoxide:     0.01,
        recorded_at:         Time.now
      )
      @device.save
      @t.save
    end
    it "requires a device" do
      @t.device = nil
      expect(@t.valid?).to eq false
      expect(@t.errors.include?(:device)).to eq true
    end
    it "requires temp_c" do
      @t.temp_c = nil
      expect(@t.valid?).to eq false
      expect(@t.errors.include?(:temp_c)).to eq true
    end
    it "requires humidity_percentage" do
      @t.humidity_percentage = nil
      expect(@t.valid?).to eq false
      expect(@t.errors.include?(:humidity_percentage)).to eq true
    end
    it "requires carbon_monoxide" do
      @t.carbon_monoxide = nil
      expect(@t.valid?).to eq false
      expect(@t.errors.include?(:carbon_monoxide)).to eq true
    end
    it "requires recorded_at" do
      @t.recorded_at = nil
      expect(@t.valid?).to eq false
      expect(@t.errors.include?(:recorded_at)).to eq true
    end
  end
end