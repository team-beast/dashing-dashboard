require 'test/unit'
require 'json'
require_relative '../../../src/cycletime/CycleTimeRepository'

class TestCycleTimeRepository < Test::Unit::TestCase

	def test_that_when_add_called_Then_redis_set_called_on_correct_key
		redis_wrapper = MockRedisWraper.new
		cycle_time_repository = CycleTime::CycleTimeRepository.new(:redis_wrapper => redis_wrapper)
		cycle_time_repository.add({:x => 1, :y => 2})
		options = redis_wrapper.set_called_with
		assert_equal("cycle_times",options[:key] )
	end

	def test_that_when_redis_has_contents_and_item_added_Then_redis_set_with_correct_json_string
		item = {:x => 1, :y => 2}
		item2 = {:x => 2, :y => 2}
		redis_contents = {:x => 1, :y => 2}.to_json
		expected_result = "#{redis_contents} , #{item.to_json} , #{item2.to_json}" 
		redis_wrapper = MockRedisWraper.new(redis_contents)
		cycle_time_repository = CycleTime::CycleTimeRepository.new(:redis_wrapper => redis_wrapper)
		cycle_time_repository.add(item)
		cycle_time_repository.add(item2)
		assert_equal(expected_result , redis_wrapper.redis_contents )
	end

	def test_that_when_redis_has_contents_and_item_added_Then_get_returns_correct_value
		item = {:x => 1, :y => 2}
		item2 = {:x => 2, :y => 2}
		redis_contents = item.to_json
		expected_result = [item,item,item2]
		redis_wrapper = MockRedisWraper.new(redis_contents)
		cycle_time_repository = CycleTime::CycleTimeRepository.new(:redis_wrapper => redis_wrapper)
		cycle_time_repository.add(item)
		cycle_time_repository.add(item2)
		result = cycle_time_repository.get
		assert_equal(expected_result, result )
	end


end

class MockRedisWraper
	attr_reader :get_called_correctly, :set_called_with, :redis_contents
	def initialize(redis_contents = "")
		@redis_contents = redis_contents
		@get_called = false
		@set_called = true
	end
	def get(options)
		if(options[:key] == "cycle_times")
			@get_called_correctly = true
			return @redis_contents
		end
	end
	def set(options)
		@redis_contents = options[:value]
		@set_called_with = options
	end
end