class Device < ApplicationRecord
  validates :serial_no, presence: true
  validates :firmware_version, presence: true
  has_many :telemetries
  has_many :notifications

  #
  # Since each device has a registration date/time, and since Rails already
  # provides "created_at", just make use of it.
  # 
  def registered_at
    return self.created_at
  end
end