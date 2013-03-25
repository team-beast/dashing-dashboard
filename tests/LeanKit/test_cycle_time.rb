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

class TestCycleTime < Test::Unit::TestCase
	def test_how_the_fuck_leankit_api_works		
		LeanKitKanban::Config.email    = "iain.mitchell@laterooms.com"
		LeanKitKanban::Config.password = "Forest66"
		LeanKitKanban::Config.url = "lrtest.leankit.com"

		# boards = LeanKitKanban::Board.all
		board = LeanKitKanban::Board.find(32404545).inspect

		p board
	end
end