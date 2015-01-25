class CreateHits < ActiveRecord::Migration
  def change
    create_table :hits do |t|
      t.references :crowdsourcer, :polymorphic => true, :null => false
      t.text       :question, :null => false
      t.text       :description
      t.string     :status, :default => "PENDING"
      t.timestamps
      t.datetime   :published_at
    end
    add_index :hits, :crowdsourcer_id
    add_index :hits, [:crowdsourcer_id, :crowdsourcer_type], :name => 'index_polymorphic_hit'
  end
end
