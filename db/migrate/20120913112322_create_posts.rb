class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.text              :body                
      t.string            :weibo_id          
      t.string            :weibo_url         
      t.datetime          :scheduled_at    
      t.boolean           :is_sent          
      t.datetime          :sent_at         
      t.datetime          :weibo_created_at
      t.has_attached_file :image  
      t.string :access_token

      t.timestamps
    end
  end
end
