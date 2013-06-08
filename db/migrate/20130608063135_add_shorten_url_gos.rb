class AddShortenUrlGos < ActiveRecord::Migration
  def up
    add_column :gos, :sina_weibo_shorten_url, :string
  end

  def down
    remove_column :gos, :sina_weibo_shorten_url
  end
end
