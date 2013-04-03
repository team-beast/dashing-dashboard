require 'test/unit'
require_relative '../../../src/redis/RedisWrapper'

class TestRedisWrapper< Test::Unit::TestCase
	def test_that_when_created_Then_host_is_set_correctly
		key = "test"
		value = "poopin"
		redis_wrapper = RedisWrapper.new
		redis_wrapper.set(:key => key, :value => value)
		received_value = redis_wrapper.get(:key => key)
		assert_equal(value,received_value)
	end
end


