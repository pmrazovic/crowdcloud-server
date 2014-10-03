class CreateOpenCalls < ActiveRecord::Migration
  def change
    create_table :open_calls do |t|
      t.references :account
      t.string     :name
      t.string     :description
      t.timestamps
    end
    add_foreign_key :open_calls, :accounts, :column => 'account_id'
    add_index :open_calls, :account_id
  end
end
