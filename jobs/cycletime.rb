require_relative '../src/leankit/leankit.rb'

class CycleTimeScheduler
	BOARD_ID = 32404545

	def initialize
		@points = []
		@last_x = 0
	end

	def start
		SCHEDULER.every '120m', :first_in => 0 do
  			LeanKit::KanbanBoard.new(BOARD_ID, self).calculate_cycle_time
  		end  		
	end

	def show_cycle_time(cycle_time)
		@points.shift if @points.length == 84
  		@last_x += 1
  		rounded_cycle_time = cycle_time.round(2)
  		@points << { x: @last_x, y: rounded_cycle_time }
  		send_event('cycletime', points: @points)
	end
end

cycle_time_scheduler = CycleTimeScheduler.new()
cycle_time_scheduler.start