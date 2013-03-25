require 'test/unit'
require_relative '../../../src/news/BbcNews'

class TestNewsRetreval < Test::Unit::TestCase
	def test_retrieves_news_from_bbc
		bbc_news = BbcNews.new()
		results = bbc_news.latest_headlines()
		assert_equal(results.count > 0, true)
	end
end