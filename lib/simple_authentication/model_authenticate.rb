module SimpleAuthentication
  module ModelAuthenticate
    extend ActiveSupport::Concern
 
    included do
    end
 
    module ClassMethods
      def model_authenticate
        cattr_accessor :remember_token, :activation_token
        include SimpleAuthentication::ModelAuthenticate::LocalInstanceMethods      
      end

      def digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
         BCrypt::Password.create(string, cost: cost)
      end

      def new_token
        SecureRandom.urlsafe_base64
      end
    end

    module LocalInstanceMethods
      def authenticated?(attribute, token)
        digest = send("#{attribute}_digest")
        return false if digest.nil?
        BCrypt::Password.new(digest).is_password?(token)
      end

      def remember
        self.remember_token = User.new_token
        update_attribute(:remember_digest, User.digest(remember_token))
      end

      def forget
        update_attribute(:remember_digest, nil)
      end

      def create_activation_digest
        self.activation_token  = User.new_token
        self.activation_digest = User.digest(activation_token)
      end 
    end
  end
end
