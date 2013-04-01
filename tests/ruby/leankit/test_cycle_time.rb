require 'test/unit'
require 'leankitkanban'
require_relative '../../../src/leankit/leankit.rb'

class TestCycleTime < Test::Unit::TestCase
  BOARD_ID = 32404545

	def test_kanban_calculate_cycle_time
    LeanKit::KanbanBoard.new(BOARD_ID, self, TestCycleRange.new).calculate_cycle_time
    p @cycle_time
	end

  def show_cycle_time(cycle_time)
    @cycle_time = cycle_time
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
    def initialize(board_id, display_cycle_time, within_cycle_range_specification = LeanKit::InLastNinetyDaysSpecification.new)
      @within_cycle_range_specification = within_cycle_range_specification
      @archieved_cards_respository = ArchivedCardsRepository.new(board_id)
      @card_cycle_time_factory = CardCycleTimeFactory.new(board_id)
      @display_cycle_time = display_cycle_time
      LeanKitKanban::Config.email    = "iain.mitchell@laterooms.com"
      LeanKitKanban::Config.password = "Forest66"
      LeanKitKanban::Config.url = "lrtest.leankit.com"
    end

    def calculate_cycle_time
      overall_cycle_time = OverallCycleTime.new(@display_cycle_time)

      archive = @archieved_cards_respository.get
      archive.each do | archived_card | 
        card_last_moved_date = DateTime.strptime(archived_card['LastMove'], '%d/%m/%Y')
        if @within_cycle_range_specification.is_satisfied_by(card_last_moved_date)
          card_cycle_time = @card_cycle_time_factory.create(archived_card["Id"])
          if card_cycle_time.time_period != 0.0
            overall_cycle_time.add_card_cycle_time(card_cycle_time)
          end
        end
      end
      overall_cycle_time.total
    end
  end

    

  

  


  
end

