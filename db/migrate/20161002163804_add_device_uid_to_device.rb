class AddDeviceUidToDevice < ActiveRecord::Migration
  def change
    add_column :devices, :device_uid, :string
  end
end
