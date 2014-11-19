class CreateHumanIntelligenceTasks < ActiveRecord::Migration
  def change
    create_table :human_intelligence_tasks do |t|
      t.references :account
      t.text       :question, :null => false
      t.text       :description
      t.string     :status, :default => "PENDING"
      t.timestamps
      t.datetime   :published_at
    end
  end
end
