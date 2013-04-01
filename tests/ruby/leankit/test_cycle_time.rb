require 'test/unit'
require 'leankitkanban'
require_relative '../../../src/leankit/leankit.rb'

class TestCycleTime < Test::Unit::TestCase
  BOARD_ID = 32404545

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

  

  


  
end

