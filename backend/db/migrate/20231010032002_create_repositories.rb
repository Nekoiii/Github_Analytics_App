class CreateRepositories < ActiveRecord::Migration[7.0]
  def change
    create_table :repositories do |t|
      t.references :owner, foreign_key: { to_table: :users }
      
      t.string :github_id
      t.string :name
      t.string :url
      t.text :description
      t.datetime :github_created_at

      t.timestamps
    end
  end
end
