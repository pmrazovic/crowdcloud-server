class AddEnabledToResponseDataTypes < ActiveRecord::Migration
  def change
    add_column :response_data_types, :enabled, :boolean, :default => :true
  end
end
