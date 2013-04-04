require_relative "../redis/RedisWrapper"
require 'json'
module CycleTime
	class CycleTimeRepository
		REDIS_KEY = "cycle_times"
		def initialize(options = {:redis_wrapper => RedisWrapper.new})
			 @redis_wrapper = options[:redis_wrapper]
			 redis_string = @redis_wrapper.get(:key => REDIS_KEY)
			 @json_cycle_times = redis_string ? redis_string.split(" , ") : []
		end

		def get
			return  @json_cycle_times.map do |json_cycle_time|
				cycle_time_from(json_cycle_time)
			end
		end

		def add(cycle_time)
			maintain_length_of_84!			
			x_value = generate_next_x_value()
			graph_coordinate = {:x => x_value, :y => cycle_time}
			@json_cycle_times.push(graph_coordinate.to_json)
			@redis_wrapper.set(:key => REDIS_KEY, :value => generate_redis_string)
		end

		private
		def maintain_length_of_84!
			@json_cycle_times.shift if @json_cycle_times.length >= 84			
		end

		def generate_next_x_value
			last_cycle_time = cycle_time_from(@json_cycle_times.last)
			last_cycle_time[:x]+1
		end

		def generate_redis_string
			return "#{@json_cycle_times.join(" , ")}"
		end

		def cycle_time_from(json_string)
			JSON.parse(json_string, :symbolize_names => true)
		end
	end
end