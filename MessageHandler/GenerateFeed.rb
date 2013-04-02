require 'json'

class MessageHandler_GenerateFeed
    
	attr_accessor :FluidDb, :OutputDir
    
    @FluidDb
    @OutputDir
    
	def Handle( msg )
        feedList = self.loadFeeds( msg );
        entryList = self.loadEntrys( msg );

        hash = Hash["feeds", feedList, "list", entryList]
        self.writeFile( self.getFilename( msg ), hash.to_json )
    end

	def loadFeeds( msg )
        return @FluidDb.queryForResultset( "SELECT f.id, f.name FROM feed_vw f WHERE f.user_id = ? ORDER BY name", [msg.id] );
    end

	def loadEntrys( msg )
        return @FluidDb.queryForResultset( "SELECT e.id, e.feed_id, e.title, e.updated AS date, e.body, e.read FROM entry_vw e WHERE e.user_id = ? ORDER BY date DESC, e.title", [msg.id] );
    end

    def getFilename( msg )
        return @OutputDir.path + "/feeds-" + msg.id.to_s + ".js"
    end
    
    def writeFile( filename, content )
        IO.write( filename, content );
    end
end
