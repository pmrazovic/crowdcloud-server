class AddEnabledToSensingDataTypes < ActiveRecord::Migration
  def change
    add_column :sensing_data_types, :enabled, :boolean, :default => :true
  end
end
