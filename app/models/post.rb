require 'rufus/scheduler'

class Post < ActiveRecord::Base
	include AttachmentAccessToken

	before_create :generate_access_token
  after_create :schedule_trigger

  attr_accessible :body, :image, :is_sent, :scheduled_at, :sent_at, :weibo_created_at, :weibo_id, :weibo_url, :weibo_image_url

  has_attached_file :image, :styles => { :thumb => "100x100>" }, :path => ":rails_root/public:url", :url => "/system/images/:access_token/pic_:style.:extension"

  def schedule_trigger
    unless self.scheduled_at.nil?
      scheduler = ::Rufus::Scheduler.start_new
      scheduler.at self.scheduled_at.to_s do
        Post.trigger self.id
      end
    end
  end

  class << self
    def trigger(id)
      post = Post.find id
      unless post.nil?
        api = Weibo::API.new
        response = nil
        if post.image.exists?
          response = api.status_upload post.body, post.image.path
        else
          response = api.status_update post.body
        end
        if response["error_code"].nil?
          post.weibo_created_at = response["created_at"]
          post.weibo_id = response["id"]
          mid = api.querymid response["id"]
          post.weibo_url = "http://weibo.com/#{response['user']['id']}/#{mid}"
          post.is_sent = true
          post.weibo_image_url = response["original_pic"]
          return post.save
        else
          # TODO: error handling
          return false
        end
      end
    end
  end

end
