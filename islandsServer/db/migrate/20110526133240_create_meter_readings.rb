class CreateMeterReadings < ActiveRecord::Migration
  def self.up
    create_table :meter_readings do |t|
      t.references :user
      t.integer :turn
      t.integer :reading

      t.timestamps
    end
  end

  def self.down
    drop_table :meter_readings
  end
end
