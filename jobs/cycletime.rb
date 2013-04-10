require_relative '../src/leankit/leankit.rb'
require_relative '../src/cycletime/CycleTimeRepository'

class CycleTimeScheduler
	BOARD_ID = 32404545

	def initialize
		@cycle_time_repository = CycleTime::CycleTimeRepository.new
	end

	def start
		SCHEDULER.every '10s', :first_in => 0 do
  			LeanKit::KanbanBoard.new(BOARD_ID, self).calculate_cycle_time
  		end  		
	end

	def show_cycle_time(cycle_time)
  		rounded_cycle_time = cycle_time.round(2)
  		@cycle_time_repository.add(rounded_cycle_time)
  		points = @cycle_time_repository.get
  		tweets =  [{ name: 'test', body: 'test', avatar: 'ss' }]
  		send_event('twitter_mentions', comments: tweets)
  		#send_event('cycletime', points: [{:x=>0, :y=>4.43}, {:x=>1, :y=>4.43}, {:x=>2, :y=>4.43}])
	end
end

cycle_time_scheduler = CycleTimeScheduler.new()
cycle_time_scheduler.start