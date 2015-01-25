class CreateSensingTasks < ActiveRecord::Migration
  def change
    create_table :sensing_tasks do |t|
      t.references :crowdsourcer, :polymorphic => true, :null => false
      t.string     :name, :null => false
      t.text       :description, :null => false
      t.string     :status, :default => "PENDING"
      t.timestamps
      t.datetime   :published_at
    end
    add_index :sensing_tasks, :crowdsourcer_id
    add_index :sensing_tasks, [:crowdsourcer_id, :crowdsourcer_type], :name => 'index_polymorphic_st'
  end
end
