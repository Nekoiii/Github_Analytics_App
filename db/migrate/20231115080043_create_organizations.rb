class CreateOrganizations < ActiveRecord::Migration[7.0]
  def change
    create_table :organizations do |t|
      t.string :github_login
      t.string :avatar_url

      t.timestamps
    end
  end
end
