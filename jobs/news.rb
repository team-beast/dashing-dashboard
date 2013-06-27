require_relative '../src/news/BbcNews'

@BBC_News = BbcNews.new()

SCHEDULER.every '15m', :first_in => 0 do |job|
	headlines = @BBC_News.latest_headlines
	headlines[4] = {:title => 'Travel company enters Administration', 
		:description => 'The financial world is in shock as travel group TUI group enters administration'}
 	send_event('news', { :headlines => headlines})
end