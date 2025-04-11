class AddProfilesToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :body, :string
    add_column :users, :x_account, :string
    add_column :users, :instagram_account, :string
    add_column :users, :youtube_account, :string
  end
end
