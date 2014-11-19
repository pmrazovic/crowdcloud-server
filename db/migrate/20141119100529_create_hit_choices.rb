class CreateHitChoices < ActiveRecord::Migration
  def change
    create_table :hit_choices do |t|
      t.references :human_intelligence_task
      t.string     :description
      t.timestamps
    end
    add_foreign_key :hit_choices, :human_intelligence_tasks, :column => 'human_intelligence_task_id'
    add_index :hit_choices, :human_intelligence_task_id    
  end
end
