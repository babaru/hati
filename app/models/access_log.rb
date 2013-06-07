class AccessLog < ActiveRecord::Base
  belongs_to :go
  attr_accessible :forwarded_for, :go_code, :header, :real_ip, :referal, :remote_ip, :go_id
end
