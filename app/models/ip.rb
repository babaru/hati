class Ip < ActiveRecord::Base
  attr_accessible :ip_start, :ip_end, :region, :comment
end
