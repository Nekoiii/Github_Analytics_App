class CreateStatistics < ActiveRecord::Migration[7.0]
  def change
    create_table :statistics do |t|
      t.references :repository, foreign_key: true
      t.references :user, foreign_key: true
      t.boolean :is_overall, default: true 
      t.integer :year
      t.integer :month
      t.integer :created_pr_count, default: 0
      t.integer :merged_pr_count, default: 0
      t.integer :closed_pr_count, default: 0
      t.integer :open_pr_count, default: 0
      t.integer :draft_pr_count, default: 0
      t.integer :approval_count, default: 0
      t.float :average_close_time
      t.float :average_merge_time
      t.float :average_merge_main_time
      t.float :total_close_time
      t.float :total_merge_time
      t.float :total_merge_main_time

      t.timestamps
    end
  end
end
