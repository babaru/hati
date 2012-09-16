class AddWeiboImageUrlColumnPosts < ActiveRecord::Migration
  def up
    add_column :posts, :weibo_image_url, :string
  end

  def down
    remove_column :posts, :weibo_image_url
  end
end
