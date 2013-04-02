require 'test/unit'
require 'leankitkanban'
require_relative '../../../src/leankit/leankit.rb'

class TestCycleTime < Test::Unit::TestCase
  BOARD_ID = 32404545

	def test_kanban_calculate_cycle_time
    LeanKit::KanbanBoard.new(BOARD_ID, self, TestCycleRange.new).calculate_cycle_time
    assert_equal(true, @cycle_time >= 0)
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