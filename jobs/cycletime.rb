require_relative '../src/leankit/leankit.rb'
require_relative '../src/cycletime/CycleTimeRepository'

class CycleTimeScheduler
	BOARD_ID = 32404545
	attr_reader :points
	def initialize
		@cycle_time_repository = CycleTime::CycleTimeRepository.new
	end

	def start
  			LeanKit::KanbanBoard.new(BOARD_ID, self).calculate_cycle_time
	end

	def show_cycle_time(cycle_time)
  		rounded_cycle_time = cycle_time.round(2)
  		@cycle_time_repository.add(rounded_cycle_time)
  		@points = @cycle_time_repository.get
  		
	end
end

cycle_time_scheduler = CycleTimeScheduler.new()

SCHEDULER.every '120m', :first_in => 0 do
	cycle_time_scheduler.start
	send_event('cycletime', points: cycle_time_scheduler.points )
end