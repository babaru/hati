module SinaWeibo
  module Api
    class AccessTokenProvider
      @@mole_id = 0
      @@token = nil

      class << self
        def reset
          Mole.update_all is_expired: false
        end

        def change
          unless @@token.nil?
            mole = Mole.find(@@mole_id)
            mole.is_expired = true
            mole.save
          end

          mole = Mole.where(:is_expired => false).first
          if mole.nil?
            @@token = nil
            @@mole_id = 0
          else
            @@mole_id = mole.id
            @@token = mole.access_token
          end

          @@token
        end

        def token
          if @@token.nil?
            change
          else
            @@token
          end
        end
      end
    end
  end
end
