require 'test/unit'
require 'FluidDb/Mock'
require './Contract.rb'
require './MessageHandler/GenerateFeed.rb'

class TestMessageHandler_GenerateFeed<MessageHandler_GenerateFeed

    attr_reader :filename, :content

    @filename
    @content
    
    def writeFile( filename, content )
        @filename = filename
        @content = content;
    end
end

class GenerateFeedTest < Test::Unit::TestCase

    @payload
    @handler

    def setup
        @fluidDb = FluidDb::Mock.new
        @handler = TestMessageHandler_GenerateFeed.new
        @handler.FluidDb = @fluidDb
        @handler.OutputDir = Dir.new( "./" )
 
        @fluidDb.addSql( "SELECT id, name FROM feed_tbl ORDER BY name", Array[ Hash["id", 1, "name", "Linus"], Hash["id", 2, "name", "Martin Fowler"] ] )
        @fluidDb.addSql( "SELECT id, feed_id, title, updated AS date, body, read FROM entry_tbl ORDER BY updated DESC, title",
                        Array[
                        Hash["id", 1, "title", "Entry A", "date", "1 Jun 2012", "body", "This is some entry A", "read", -1]
                        ] )
        @msg = GenerateFeed.new( 1 );
    end

    def testLoadFeeds
        feedList = @handler.loadFeeds( @msg )
        assert_equal Hash["id", 1, "name", "Linus"], feedList[0]
    end
    
    def testLoadEntrys
        entryList = @handler.loadEntrys( @msg )
    end
    
    def testHandle
        @handler.Handle( GenerateFeed.new( 1 ) );
        assert_equal ".//feeds-1.js", @handler.filename
        
        hash = JSON.parse( @handler.content )
        assert_equal 2, hash["feeds"].length
        assert_equal 1, hash["list"].length
    end

end
