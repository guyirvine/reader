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
        return @FluidDb.queryForResultset( "SELECT id, name FROM feed_tbl ORDER BY name", [] );
    end

	def loadEntrys( msg )
        return @FluidDb.queryForResultset( "SELECT id, feed_id, title, updated AS date, body, read FROM entry_tbl ORDER BY updated DESC, title", [] );
    end
    
    def getFilename( msg )
        return @OutputDir.path + "/feeds-" + msg.id.to_s + ".js"
    end
    
    def writeFile( filename, content )
        IO.write( filename, content );
    end
end
