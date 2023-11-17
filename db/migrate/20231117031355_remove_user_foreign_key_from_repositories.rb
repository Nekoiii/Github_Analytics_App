class RemoveUserForeignKeyFromRepositories < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :repositories, :users
  end
end
