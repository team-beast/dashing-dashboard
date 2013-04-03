require_relative "../redis/RedisWrapper"
module CycleTime
	class CycleTimeRepository
		def initialize(options = {:redis_wrapper => RedisWrapper.new})

			 redis_wrapper = options[:redis_wrapper]
			 redis_wrapper.get(:key => "")
		end
	end
end