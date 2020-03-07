class Device < ApplicationRecord
  validates :serial_no, presence: true
  validates :firmware_version, presence: true
  has_many :telemetries
  has_many :notifications

  #
  # Before saving, upcase the serial number so we don't run into case
  # insensitive search problems later on.
  #
  before_save :upcase_sn

  #
  # Since each device has a registration date/time, and since Rails already
  # provides "created_at", just make use of it.
  #
  def registered_at
    return self.created_at
  end

private

  def upcase_sn
    serial_no.upcase!
  end
end