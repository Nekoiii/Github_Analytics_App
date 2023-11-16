class AddPolymorphicOwnerToRepositories < ActiveRecord::Migration[7.0]
  def change
    add_column :repositories, :owner_type, :string
    add_index :repositories, [:owner_id, :owner_type]
  end
end
