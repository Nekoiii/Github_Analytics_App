class CreateReviews < ActiveRecord::Migration[7.0]
  def change
    create_table :reviews do |t|
      t.references :pull_request, foreign_key: true
      t.references :author, null: true, foreign_key: { to_table: :users }

      t.integer :state  #enum
      
      t.timestamps
    end
  end
end
