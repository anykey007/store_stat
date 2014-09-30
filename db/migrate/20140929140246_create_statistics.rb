class CreateStatistics < ActiveRecord::Migration
  def change
    create_table :statistics do |t|
      t.references :store, index: true
      t.datetime :period_start
      t.datetime :period_end
      t.float :avg_dwell_time, default: 0.0
      t.integer :unique_visitors_count, default: 0
      t.integer :repeating_visitors_count, default: 0
      t.string :period_type

      t.timestamps
    end
  end
end
