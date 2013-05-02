require_relative "../redis/RedisWrapper"
require_relative 'CycleTimeRepository'

module CycleTime
	class CycleTimeGraphPointsFactory
		def initialize(is_production_specification)
			@is_production_specification = is_production_specification
		end

		def create
			return InMemoryCycleTimeGraphPoints.new unless @is_production_specification.satisfied?
			return CycleTimeGraphPoints.new
		end
	end

	

	class InMemoryCycleTimeGraphPoints
	end
end