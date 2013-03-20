require 'test/unit'
require './MessageHandler/AddAtomFeed.rb'


class AddAtomFeedTest < Test::Unit::TestCase
    
    
    @payload
    @handler
    
    def setup
        @payload = IO.read( "./data/linus.atom" );
        @handler = MessageHandler_AddAtomFeed.new
    end
    
	def test_LoadXml
        xml = @handler.LoadXml( @payload )

		assert_equal "Hash", xml.class.name
        assert_equal "Linus' blog", xml["title"][0]["content"]
	end

	def test_LoadTitle
        xml = @handler.LoadXml( @payload )

        title = @handler.getTitle( xml )
        
        assert_equal "Linus' blog", title
	end
    
	def test_LoadId
        xml = @handler.LoadXml( @payload )
        
        id = @handler.getId( xml )
        
        assert_equal "tag:blogger.com,1999:blog-4999557720148026925", id
	end
    
    def test_getFeedPropertiesFromAtomAsHash
        xml = @handler.LoadXml( @payload )
        
        props = @handler.getFeedPropertiesFromAtomAsHash( xml )
        
        assert_equal Hash["id", "tag:blogger.com,1999:blog-4999557720148026925", "title", "Linus' blog", "url", "http://torvalds-family.blogspot.com/" ], props
    end

	def test_getEntries
        xml = @handler.LoadXml( @payload )
        
        list = @handler.getEntries( xml )
	end
    
	def test_getEntry
        xml = @handler.LoadXml( @payload )
        
        list = @handler.getEntries( xml )
        entry = list[0]
        
        
	end

end
