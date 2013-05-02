require_relative "../redis/RedisWrapper"
require 'json'
module CycleTime

	class CurrentGraphDataSet
		def initialize(redis_wrapper)
			@graph_points_serializer = GraphPointsSerializer.new(redis_wrapper)
			@graph_times = @graph_points_serializer.deserialize
		end

		def add(graph_time)
			maintain_length_of_84!
			@graph_times.push(graph_time)
			@graph_points_serializer.serialize(@graph_times)
		end

		def get
			@graph_times
		end

		private
		def maintain_length_of_84!()
			@graph_times.shift if @graph_times.length >= 84			
		end
	end

	class CycleTimeGraphPoints
		def initialize(options = {:redis_wrapper => RedisWrapper.new})
			@current_graph_data_set = CurrentGraphDataSet.new(options[:redis_wrapper])
		end

		def get
			@current_graph_data_set.get
		end

		def add(cycle_time)
			x_value = generate_next_x_value(@current_graph_data_set.get)
			graph_coordinate = {:x => x_value, :y => cycle_time}
			@current_graph_data_set.add(graph_coordinate)

		end

		private
		def generate_next_x_value(json_graph_times)		
			return 0 if json_graph_times.length == 0	
			last_cycle_time = json_graph_times.last
			last_cycle_time[:x]+1
		end
	end


	class GraphPointsSerializer
		REDIS_KEY = "cycle_times"
		def initialize(redis_wrapper)
			@redis_wrapper = redis_wrapper
		end

		def serialize(points)
			json_points = points.map do |point|
				point.to_json
			end
			redis_string = json_points.join(" , ")
			@redis_wrapper.set(:key => REDIS_KEY, :value => redis_string)
		end

		def deserialize
			json_array = @redis_wrapper.get(:key => REDIS_KEY).split(" , ")
			points = json_array.map do |json|
				JSON.parse(json, :symbolize_names => true)
			end
		end
	end
end