class CreateOpenCalls < ActiveRecord::Migration
  def change
    create_table :open_calls do |t|
      t.references :account
      t.string     :name, :null => false
      t.text       :description, :null => false
      t.string     :status, :default => "PENDING"
      t.timestamps
      t.datetime   :published_at
      t.datetime   :finished_at
    end
    add_foreign_key :open_calls, :accounts, :column => 'account_id'
    add_index :open_calls, :account_id
  end
end
