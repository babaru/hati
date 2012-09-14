class Post < ActiveRecord::Base
	include AttachmentAccessToken

	before_create :generate_access_token

  attr_accessible :body, :image, :is_sent, :scheduled_at, :sent_at, :weibo_created_at, :weibo_id, :weibo_url

  has_attached_file :image, :styles => { :thumb => "100x100>" }, :path => ":rails_root/public:url", :url => "/system/images/:access_token/pic_:style.:extension"

end
