require_relative "../redis/RedisWrapper"
require 'json'
module CycleTime
	class CycleTimeRepository
		REDIS_KEY = "cycle_times"
		def initialize(options = {:redis_wrapper => RedisWrapper.new})
			 @redis_wrapper = options[:redis_wrapper]
			 redis_string = @redis_wrapper.get(:key => REDIS_KEY)
			 @cycle_times = redis_string ? redis_string.split(" , ") : []
		end

		def get
			return  @cycle_times.map do |cycle_time|
				JSON.parse(cycle_time, :symbolize_names => true)
			end
		end

		def add(cycle_time)
			graph_coordinate = {:x => @cycle_times.length, :y => cycle_time}
			@cycle_times.push(graph_coordinate.to_json)
			@redis_wrapper.set(:key => REDIS_KEY, :value => generate_redis_string)
		end


		private

		def generate_redis_string
			return "#{@cycle_times.join(" , ")}"
		end
	end
end