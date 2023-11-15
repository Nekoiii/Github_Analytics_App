class AddOmniauthToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :provider, :string, null: true, default: ''
    add_column :users, :uid, :string, null: true, default: ''
    
    # add_index :users, %i[uid provider], unique: true
  end
end
