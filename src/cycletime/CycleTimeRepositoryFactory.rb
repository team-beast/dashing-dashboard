require_relative 'CycleTimeRepository'
module CycleTime
	class CycleTimeRepositoryFactory
		def initialize(is_production_specification)
			@is_production_specification = is_production_specification
		end

		def create
			return InMemoryCycleTimeRepository.new unless @is_production_specification.satisfied?
			return CycleTimeRepository.new
		end
	end

	

	class InMemoryCycleTimeRepository
	end
end