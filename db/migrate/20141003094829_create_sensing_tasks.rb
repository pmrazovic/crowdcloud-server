class CreateSensingTasks < ActiveRecord::Migration
  def change
    create_table :sensing_tasks do |t|
      t.references :account
      t.string     :name, :null => false
      t.text       :description, :null => false
      t.string     :status, :default => "PENDING"
      t.timestamps
      t.datetime   :published_at
    end
    add_foreign_key :sensing_tasks, :accounts, :column => 'account_id'
    add_index :sensing_tasks, :account_id
  end
end
