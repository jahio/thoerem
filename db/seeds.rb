#
# db/seeds.rb
#
# Herein are contained a myriad of database entries to set up a working
# DEMO system. This is only for demonstration or testing purposes.
#

#
# Create 100 devices
#
@devices = []
10.times do |i|
  d = Device.new(serial_no: SecureRandom.hex(5), firmware_version: SecureRandom.hex(5))
  if d.save
    @devices << d
  end
end

#
# Create telemetry data for each of those devices
#
@devices.each do |d|
  100.times do |i|
    d.telemetries << Telemetry.new(
      temp_c: (rand(1000) * 0.1),
      humidity_percentage: (rand(1000) * 0.1),
      carbon_monoxide: (rand(100) * 0.1),
      health: ["needs_service", "needs_new_filter", "gas_leak", "just_fine", "", nil, nil, nil, nil, nil].sample,
      recorded_at: Time.now - (i * 2).minutes
    )
  end
end