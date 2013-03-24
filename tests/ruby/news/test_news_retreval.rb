require 'test/unit'
require_relative '../../../src/news/BbcNews'

class TestNewsRetreval < Test::Unit::TestCase
	def test_retrieves_news_from_bbc
		mock_news_headline_display = MockNewsHeadlineDisplay.new
		bbc_news = BbcNews.new(mock_news_headline_display)
		bbc_news.latest_headlines()
		assert_equal(mock_news_headline_display.shown_news.count > 0, true)
	end
end

class MockNewsHeadlineDisplay
	attr_reader :shown_news	

	def show(news_headlines)
		@shown_news = news_headlines
	end
end