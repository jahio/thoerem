require 'rails_helper'

RSpec.describe Device, type: :model do
  describe "registration" do
    it "uses created_at as its registration date/time" do
      Device.new(serial_no: 'abc123', firmware_version: '999.123').save
      @device = Device.first
      expect(@device.registered_at).to eq @device.created_at
    end
  end
  describe "validations" do
    before :each do
      @device = Device.new(serial_no: 'abc123', firmware_version: '999.123')
    end
    it "requires serial_no" do
      @device.serial_no = nil
      expect(@device.valid?).to eq false
      expect(@device.errors.include?(:serial_no)).to eq true
    end
    it "requires firmware_version" do
      @device.firmware_version = nil
      expect(@device.valid?).to eq false
      expect(@device.errors.include?(:firmware_version)).to eq true
    end
  end
end