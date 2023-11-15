class CreatePullRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :pull_requests do |t|
      t.references :repository, null: false, foreign_key: true
      # The to_table option allows specifying a different table name 
      # for the foreign key reference when the column name doesn't 
      # match the table's name.
      t.references :author, null: true, foreign_key: { to_table: :users }
      t.references :merger, foreign_key: { to_table: :users }
      
      t.string :github_id
      t.string :title
      t.string :permalink
      t.string :base_ref_name
      t.string :base_ref_oid
      t.string :head_ref_name
      t.string :head_ref_oid
      t.integer :number
      t.text :merge_commit
      
      t.boolean :is_draft
      t.boolean :closed
      t.boolean :merged

      t.datetime :merged_at
      t.datetime :closed_at
      t.datetime :github_created_at
      t.datetime :github_updated_at
      t.datetime :github_published_at

      t.timestamps
    end
  end
end
