class Go < ActiveRecord::Base
  has_many :access_logs
  attr_accessible :code, :url, :sina_weibo_shorten_url, :is_monitoring, :monitor_group_name

  validates :code, uniqueness: true
  # validates :url, uniqueness: true
  # validates :sina_weibo_shorten_url, uniqueness: true

  before_validation :strip_whitespace, :only => [:code, :url]

  private
  def strip_whitespace
    self.code = self.code.strip
    self.url = self.url.strip
  end
end
