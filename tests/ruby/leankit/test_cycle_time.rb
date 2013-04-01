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

    p LeanKit::CardCycleTimeFactory.new.create(1)


		# File.open("output.txt", "w+") do |file|
  #     file.puts(moved_history )
  #   end
	end
end

module LeanKit
  class CardCycleTimeFactory
    def initialize
      @datetime_from_leankit_datetime_factory = DateTimeFromLeanKitFactory.new
      @cycle_time_calculator = CycleTimeCalculator.new
      @card_cycle_history_factory = CardCycleHistoryFactory.new
    end

    def create(external_id)
      card_cycle_history = @card_cycle_history_factory.create(external_id)
      cycle_time = @cycle_time_calculator.calculate(
        card_cycle_history.start_cycle_date_time, 
        card_cycle_history.end_cycle_date_time)
      LeanKit::CardCycleTime.new(time_period: cycle_time, end_date: card_cycle_history.end_cycle_date_time)
    end
  end 

  class CardCycleHistoryFactory
    START_CYCLE_LANE = 'Development: In Progress'
    END_CYCLE_LANE = 'Release: Live'

    def initialize
      @card_transistion_history_repository = CardTransitionHistoryRespository.new
      @datetime_from_leankit_datetime_factory = DateTimeFromLeanKitFactory.new
      @transition_date_time_mapper = TransitionDateTimeMapper.new(DateTimeFromLeanKitFactory.new())
    end

    def create(external_id)
      card_transistion_history = @card_transistion_history_repository.get(external_id)
      start_cycle_date_time = @transition_date_time_mapper.map_from(card_transistion_history, START_CYCLE_LANE)
      end_cycle_date_time = @transition_date_time_mapper.map_from(card_transistion_history, END_CYCLE_LANE)
      CardCycleHistory.new(start_cycle_date_time: start_cycle_date_time, end_cycle_date_time:  end_cycle_date_time)
    end
  end

  class TransitionDateTimeMapper
    DATE_TIME_KEY = 'DateTime'
    DESTINATION_LANE_KEY = 'ToLaneTitle'

    def initialize(date_time_adapter)
      @date_time_adapter = date_time_adapter
    end

    def map_from(card_transistion_history, to_lane_title)
      transition = get_transition_to(to_lane_title, card_transistion_history)
      transition_date_time = @date_time_adapter.create(transition[DATE_TIME_KEY])
    end

    private
    def get_transition_to(to_lane_title, card_transistion_history)
      card_transistion_history.select {|card_transistion_history_item | card_transistion_history_item[DESTINATION_LANE_KEY] == to_lane_title}[0]
    end
  end

  class CardCycleHistory
    attr_reader :start_cycle_date_time, :end_cycle_date_time

    def initialize(values)
      @start_cycle_date_time = values[:start_cycle_date_time]
      @end_cycle_date_time = values[:end_cycle_date_time]
    end
  end

  class DateTimeFromLeanKitFactory
    LEANKIT_DATETIME_FORMAT = "%d/%m/%Y at %l:%M:%S %p"

    def create(leankit_date_time)
      DateTime.strptime(leankit_date_time, LEANKIT_DATETIME_FORMAT)
    end
  end

  class CycleTimeCalculator
    def calculate(start_date, end_date)
      (end_date - start_date).to_f
    end
  end

  class CardHistoryRespository
    def get(external_id)
      card = LeanKitKanban::Card.find_by_external_id(BOARD_ID, external_id)[0][0]
      card_id = card["Id"]
      LeanKitKanban::Card.get_card_history(BOARD_ID, card_id)[0]
    end
  end

  class CardTransitionHistoryRespository
    CARD_TRANSISITION_KEY_NAME = "FromLaneId" 

    def initialize
      @card_history_respository = CardHistoryRespository.new()
    end

    def get(external_id)
      card_history = @card_history_respository.get(external_id)
      card_transistion_history = card_history.select { |card_history_item| card_history_item.key? CARD_TRANSISITION_KEY_NAME }
    end
  end

  class CardCycleTime
    attr_reader :time_period, :end_date

    def initialize(values)
      @time_period = values[:time_period]
      @end_date = values[:end_date]
    end
  end
end

