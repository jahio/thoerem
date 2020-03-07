require 'rails_helper'

RSpec.describe Notification, type: :model do
  describe "a valid notification" do
    it "passes validations and saves" do
      Device.create(serial_no: 'abc123', firmware_version: 'asdf')
      @n = Notification.new(msg: "abc123", dismissed: false, device: Device.first)
      expect { @n.save }.to change { Notification.count }.by(1)
    end
  end
end