require 'test/unit'
require_relative '../../../src/cycletime/CycleTimeRepository'

class TestCycleTimeRepository < Test::Unit::TestCase

	def test_that_when_created_Then_gets_values_from_redis
		redis_wrapper = MockRedisWraper.new
		CycleTime::CycleTimeRepository.new(:redis_wrapper => redis_wrapper)
		assert_equal(true, redis_wrapper.get_called)
	end
end

class MockRedisWraper
	attr_reader :get_called, :set_called
	def initialize
		@get_called = false
		@set_called = true
	end
	def get(options)
		@get_called = true
	end
	def set(options)
		@set_called = true
	end
end