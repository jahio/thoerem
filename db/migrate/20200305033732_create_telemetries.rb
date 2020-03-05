class CreateTelemetries < ActiveRecord::Migration[6.0]
  def change
    create_table :telemetries, id: :uuid do |t|
      t.uuid          :device_id, null: false
      t.float         :temp_c, null: false, default: 0.0
      t.float         :humidity_percentage, null: false, default: 0.0
      t.float         :carbon_monoxide, null: false, default: 0.0
      t.timestamps
    end
  end
end