class CreateDevices < ActiveRecord::Migration[6.0]
  def change
    create_table :devices, id: :uuid do |t|
      t.string        :serial_no
      t.string        :firmware_version
      t.timestamps
    end
  end
end