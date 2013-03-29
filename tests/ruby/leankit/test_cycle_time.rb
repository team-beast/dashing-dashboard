require 'test/unit'
require 'leankitkanban'

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
end

module LeanKitKanban
  module Card
    CARD_HISTORY = "/Card/History/{boardID}/{cardID}"

    def self.get_card_history(board_id, card_id)
      api_call = CARD_HISTORY.gsub("{boardID}", board_id.to_s).gsub("{cardID}", card_id.to_s)
      get(api_call)
    end
  end
end

BOARD_ID = 32404545

class TestCycleTime < Test::Unit::TestCase
	def test_how_the_fuck_leankit_api_works		
		LeanKitKanban::Config.email    = "iain.mitchell@laterooms.com"
		LeanKitKanban::Config.password = "Forest66"
		LeanKitKanban::Config.url = "lrtest.leankit.com"

    card_history = get_card_history(1)[0]

    moved_history = card_history.select { |item| item.key? "FromLaneId" }



		# File.open("output.txt", "w+") do |file|
  #     file.puts(moved_history )
  #   end
	end

  def get_card_history(external_id)
    card = LeanKitKanban::Card.find_by_external_id(BOARD_ID, external_id)[0][0]
    card_id = card["Id"]
    history = LeanKitKanban::Card.get_card_history(BOARD_ID, card_id)
  end
end