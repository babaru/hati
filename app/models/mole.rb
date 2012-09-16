class Mole < ActiveRecord::Base
  attr_accessible :access_token, :name, :weibo_id, :is_expired

  scope :availables, where(:is_expired => false)

  class << self

    def token
    	mole = self.availables.first
    	if mole.nil?
    		return nil
    	else
    		return mole.access_token
      end
    end

    def expire(token)
      mole = Mole.where(:access_token => token)
      mole.is_expired = true
      mole.save
    end
    
  end
end
