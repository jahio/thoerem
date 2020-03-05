class Telemetry < ApplicationRecord
  belongs_to :device
  validates :carbon_monoxide, presence: true
  validates :temp_c, presence: true
  validates :humidity_percentage, presence: true
end