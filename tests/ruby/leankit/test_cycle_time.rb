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
	def test_kanban_calculate_cycle_time
    p LeanKit::KanbanBoard.new(BOARD_ID, TestCycleRange.new).calculate_cycle_time
	end
end

class TestCycleRange 
  def initialize
    @today = DateTime.now - 14
  end

  def is_satisfied_by(date_time)
    date_time >= @today
  end
end

module LeanKit
  class KanbanBoard
    def initialize(board_id, within_cycle_range_specification = LeanKit::InLastNinetyDaysSpecification.new)
      @within_cycle_range_specification = within_cycle_range_specification
      @archieved_cards_respository = ArchivedCardsRepository.new(board_id)
      @card_cycle_time_factory = LeanKit::CardCycleTimeFactory.new(board_id)
      LeanKitKanban::Config.email    = "iain.mitchell@laterooms.com"
      LeanKitKanban::Config.password = "Forest66"
      LeanKitKanban::Config.url = "lrtest.leankit.com"
    end

    def calculate_cycle_time
      card_count = 0
      card_total_cycle_time = 0

      archive = @archieved_cards_respository.get
      archive.each do | archived_card | 
        card_last_moved_date = DateTime.strptime(archived_card['LastMove'], '%d/%m/%Y')
        if @within_cycle_range_specification.is_satisfied_by(card_last_moved_date)
          card_cycle_time = @card_cycle_time_factory.create(archived_card["Id"])
          if card_cycle_time.time_period != 0.0
            card_count += 1
            card_total_cycle_time +=  card_cycle_time.time_period
          end
        end
      end
      (card_count != 0 ) ? card_total_cycle_time / card_count : 0
    end
  end

  class ArchivedCardsRepository
    def initialize(board_id)
      @board_id = board_id
    end

    def get
      archive = get_archive_live_cards + get_archive_waste_cards
    end

    private
    def get_archive_live_cards
      LeanKitKanban::Archive.fetch(@board_id)[0][0]['ChildLanes'][0]['Lane']['Cards']
    end

    def get_archive_waste_cards
      LeanKitKanban::Archive.fetch(@board_id)[0][0]['ChildLanes'][1]['Lane']['Cards']
    end
  end

  class InLastNinetyDaysSpecification
    def initialize
      @ninety_days_ago = DateTime.now - 90
    end

    def is_satisfied_by(date_time)
      date_time >= @ninety_days_ago
    end
  end


  class CardCycleTimeFactory
    def initialize(board_id)
      @cycle_time_calculator = CycleTimeCalculator.new
      @card_cycle_history_factory = CardCycleHistoryFactory.new(
        CardTransitionHistoryRespository.new(
          CardHistoryRespository.new(board_id)))
    end

    def create(card_id)
      card_cycle_history = @card_cycle_history_factory.create(card_id)
      cycle_time = @cycle_time_calculator.calculate(
        card_cycle_history.start_cycle_date_time, 
        card_cycle_history.end_cycle_date_time)
      LeanKit::CardCycleTime.new(time_period: cycle_time, end_date: card_cycle_history.end_cycle_date_time)
    end
  end 

  class CardCycleHistoryFactory
    START_CYCLE_LANE = 'Development: In Progress'
    END_CYCLE_LANE = 'Release: Live'

    def initialize(card_transistion_history_repository)
      @card_transistion_history_repository = card_transistion_history_repository
      @datetime_from_leankit_datetime_factory = DateTimeFromLeanKitFactory.new
      @transition_date_time_mapper = TransitionDateTimeMapper.new(DateTimeFromLeanKitFactory.new())
    end

    def create(card_id)
      card_transistion_history = @card_transistion_history_repository.get(card_id)
      start_cycle_date_time = @transition_date_time_mapper.map_start_from(card_transistion_history)
      end_cycle_date_time = @transition_date_time_mapper.map_end_from(card_transistion_history)
      CardCycleHistory.new(start_cycle_date_time: start_cycle_date_time, end_cycle_date_time:  end_cycle_date_time)
    end
  end

  class TransitionDateTimeMapper
    DATE_TIME_KEY = 'DateTime'
    DESTINATION_LANE_KEY = 'ToLaneTitle'
    START_CYCLE_LANE = 'Development: In Progress'
    END_CYCLE_LANE = 'Release: Live'

    def initialize(date_time_adapter)
      @date_time_adapter = date_time_adapter
    end

    def map_start_from(card_transistion_history)
      transition = get_transition_to(START_CYCLE_LANE, card_transistion_history)
      transition = card_transistion_history[0] if transition.nil?
      transition_date_time = @date_time_adapter.create(transition[DATE_TIME_KEY])
    end

    def map_end_from(card_transistion_history)
      transition = get_transition_to(END_CYCLE_LANE, card_transistion_history)
      transition = card_transistion_history[card_transistion_history.length-1] if transition.nil?
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
    def initialize(board_id)
      @board_id = board_id
    end

    def get(card_id)
      LeanKitKanban::Card.get_card_history(@board_id, card_id)[0]
    end
  end

  class CardTransitionHistoryRespository
    CARD_TRANSISITION_KEY_NAME = "FromLaneId" 

    def initialize(card_history_respository)
      @card_history_respository = card_history_respository
    end

    def get(card_id)
      card_history = @card_history_respository.get(card_id)
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

