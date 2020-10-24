class ChangeImageUrlToImage < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :image_url, :image
  end
end
