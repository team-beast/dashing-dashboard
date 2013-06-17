require_relative '../src/news/BbcNews'

@BBC_News = BbcNews.new()

SCHEDULER.every '15m', :first_in => 0 do |job|
	headlines = @BBC_News.latest_headlines
	headlines[2] = {:title => 'Concern at Savile Return', 
		:description => 'There are reports that the spirit of Jimmy Savile has started infecting electrical devices in the UK'}
 	send_event('news', { :headlines => headlines})
end