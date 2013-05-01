require 'test/unit'
require_relative '../../../src/cycletime/CycleTimeRepositoryFactory'

class TestCycleTimeRepositoryFactory < Test::Unit::TestCase
	def test_when_not_production_then_in_memory_cycle_time_repository_created
		fake_is_production_specification = FakeIsProductionSpecification.new(false)
		result = CycleTime::CycleTimeGraphPointsFactory.new(fake_is_production_specification).create()
		assert_equal('CycleTime::InMemoryCycleTimeGraphPoints', result.class.name)	
	end

	def test_when_production_environment_Then_cycle_time_repository_created
		fake_is_production_specification = FakeIsProductionSpecification.new(true)
		result = CycleTime::CycleTimeGraphPointsFactory.new(fake_is_production_specification).create()
		assert_equal('CycleTime::CycleTimeGraphPoints', result.class.name)	
	end
end

class FakeIsProductionSpecification
	def initialize(return_value)
		@return_value = return_value
	end

	def satisfied?
		@return_value
	end
end

