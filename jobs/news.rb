require_relative '../src/news/BbcNews'

@BBC_News = BbcNews.new()

SCHEDULER.every '15m', :first_in => 0 do |job|
	headlines = @BBC_News.latest_headlines
 	send_event('news', { :headlines => headlines})
end