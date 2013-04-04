require_relative '../src/leankit/leankit.rb'
require_relative '../src/cycletime/CycleTimeRepository'

class CycleTimeScheduler
	BOARD_ID = 32404545

	def initialize
		@cycle_time_repository = CycleTime::CycleTimeRepository.new
		@last_x = 0
	end

	def start
		SCHEDULER.every '120m', :first_in => 0 do
  			LeanKit::KanbanBoard.new(BOARD_ID, self).calculate_cycle_time
  		end  		
	end

	def show_cycle_time(cycle_time)
  		@last_x += 1
  		rounded_cycle_time = cycle_time.round(2)
  		@cycle_time_repository.add({ x: @last_x, y: rounded_cycle_time })
  		@points =  [{:x =>1, :y=>5},
  		{:x =>2, :y=>5},{:x =>3, :y=>5},
  		{:x =>4, :y=>5},{:x =>5, :y=>5},{:x =>6, :y=>5},
  		{:x =>7, :y=>5},{:x =>8, :y=>5},{:x =>9, :y=>5},
  		{:x =>10, :y=>5},{:x =>11, :y=>5}]#@cycle_time_repository.get
  		send_event('cycletime', points: @points)
	end
end

cycle_time_scheduler = CycleTimeScheduler.new()
cycle_time_scheduler.show_cycle_time(4)