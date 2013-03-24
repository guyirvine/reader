require 'test/unit'
require './MessageHandler/AddRssFeed.rb'


class AddRssFeedTest < Test::Unit::TestCase
    
    
    @payload
    @handler
    
    def setup
        @payload = IO.read( "./data/ayende.rss" );
        @handler = MessageHandler_AddRssFeed.new
    end
    
	def test_LoadTitle
        xml = @handler.LoadXml( @payload )

        title = @handler.getTitle( xml )

        assert_equal "Ayende @ Rahien", title
	end
    
	def test_LoadId
        xml = @handler.LoadXml( @payload )
        
        id = @handler.getId( xml )
        
        assert_equal "http://ayende.com/blog/", id
	end
    
    def test_getFeedPropertiesFromAtomAsHash
        xml = @handler.LoadXml( @payload )
        
        props = @handler.getFeedPropertiesFromRssAsHash( xml )
        
        assert_equal Hash["id", "http://ayende.com/blog/", "title", "Ayende @ Rahien", "url", "http://ayende.com/blog/" ], props
    end

	def test_getEntries
        xml = @handler.LoadXml( @payload )
        
        list = @handler.getEntries( xml )
	end
    
	def test_getEntry
        xml = @handler.LoadXml( @payload )
        
        list = @handler.getEntries( xml )
        entry = list[0]
        
        assert_equal String, entry["id"].class
        assert_equal String, entry["title"].class
        assert_equal String, entry["url"].class
        assert_equal String, entry["updated"].class
        assert_equal String, entry["body"].class
        
	end

end
