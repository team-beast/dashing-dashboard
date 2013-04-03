require 'redis'
redis = Redis.new(:host =>"spinyfin.redistogo.com", :port => 9166, :password =>"37045748b4fa9b608e7851f215d06d42")
SCHEDULER.every '2s' do
puts redis.get("cycle_times")
end