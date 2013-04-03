require 'test/unit'
require_relative '../../../src/environment/IsProductionSpecification'

class TestIsProductionSpecification < Test::Unit::TestCase	
	def test_when_rack_env_is_production_then_is_production_specification_satisfied
		ENV["RACK_ENV"] = "production"
		assert_equal(true, Environment::IsProductionSpecification.new.satisified?)
	end	

	def test_when_rack_env_is_not_specified_Then_is_not_production_satisfied
		ENV["RACK_ENV"] = nil
		assert_equal(false, Environment::IsProductionSpecification.new.satisified?)
	end	
end