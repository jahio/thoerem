class CreateNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :notifications, id: :uuid do |t|
      t.string      :msg
      t.boolean     :dismissed
      t.uuid        :device_id
      t.timestamps
    end
  end
end