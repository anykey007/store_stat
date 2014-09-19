class CreateRows < ActiveRecord::Migration
  def change
    create_table :rows do |t|
      t.datetime :visit_data
      t.string :mac_address
      t.integer :a
      t.integer :b
      t.integer :c
      t.integer :d
      t.integer :e
      t.integer :f
      t.integer :g
      t.integer :h
      t.references :document, index: true

      t.timestamps
    end
  end
end
