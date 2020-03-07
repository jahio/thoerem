class CreateTelemetries < ActiveRecord::Migration[6.0]
  def change
    create_table :telemetries, id: :uuid do |t|
      t.uuid          :device_id, null: false
      t.float         :temp_c, null: false, default: 0.0
      t.float         :humidity_percentage, null: false, default: 0.0
      t.float         :carbon_monoxide, null: false, default: 0.0
      t.string        :health, null: true, default: nil
      t.timestamps
    end

    add_index :telemetries, :device_id
    add_index :telemetries, :carbon_monoxide
    add_index :telemetries, :health
  end
end