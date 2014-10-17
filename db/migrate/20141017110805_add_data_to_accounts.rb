class AddDataToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :first_name, :string, :null => false, :default => ''
    add_column :accounts, :last_name, :string, :null => false, :default => ''
    add_column :accounts, :role, :string, :null => false, :default => 'CROWDSOURCER'
  end
end
