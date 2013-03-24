require 'test/unit'
require './MessageHandler/AddAtomFeed.rb'


class AddAtomFeedSethTest < Test::Unit::TestCase
    
    
    @payload
    @handler
    
    def setup
        @payload = IO.read( "./data/sethsmainblog" );
        @handler = MessageHandler_AddAtomFeed.new
    end
    
	def test_LoadTitle
        xml = @handler.LoadXml( @payload )

        title = @handler.getTitle( xml )
        
        assert_equal "Seth's Blog", title
	end
    
	def test_LoadId
        xml = @handler.LoadXml( @payload )
        
        id = @handler.getId( xml )
        
        assert_equal "tag:typepad.com,2003:weblog-3511", id
	end
    
    def test_getFeedPropertiesFromAtomAsHash
        xml = @handler.LoadXml( @payload )
        
        props = @handler.getFeedPropertiesFromAtomAsHash( xml )

        assert_equal Hash["id", "tag:typepad.com,2003:weblog-3511", "title", "Seth's Blog", "url", "http://sethgodin.typepad.com/seths_blog/" ], props
    end

	def test_getEntries
        xml = @handler.LoadXml( @payload )
        
        list = @handler.getEntries( xml )
	end
    
	def test_getEntry
        xml = @handler.LoadXml( @payload )
        
        list = @handler.getEntries( xml )
        
        entry = list[0]

        assert_equal 2122, entry["body"].length
        
	end

end
