class CreateHitChoices < ActiveRecord::Migration
  def change
    create_table :hit_choices do |t|
      t.references :hit
      t.string     :description
      t.timestamps
    end
    add_foreign_key :hit_choices, :hits, :column => 'hit_id'
    add_index :hit_choices, :hit_id    
  end
end
