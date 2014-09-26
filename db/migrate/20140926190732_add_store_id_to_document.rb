class AddStoreIdToDocument < ActiveRecord::Migration
  def change
    add_column :documents, :store_id, :integer

    add_index(:documents, :store_id)
  end
end
