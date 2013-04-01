module LeanKitKanban
  module Config
    class NoCredentials < StandardError; end
    class NoAccount < StandardError; end

    class << self
      attr_accessor :email, :password, :url      
      
      def validate
        raise NoCredentials if email.nil? || password.nil?        
      end

      def uri
        validate
        "http://#{@url}#{API_SUFFIX}"
      end

      def basic_auth_hash
        validate
        {:basic_auth => {:username => email, :password => password}}
      end
    end
  end

  module Card
    CARD_HISTORY = "/Card/History/{boardID}/{cardID}"

    def self.get_card_history(board_id, card_id)
      api_call = CARD_HISTORY.gsub("{boardID}", board_id.to_s).gsub("{cardID}", card_id.to_s)
      get(api_call)
    end
  end
end