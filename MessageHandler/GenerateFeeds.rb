
class MessageHandler_GenerateFeeds
    
	attr_accessor :Bus, :FluidDb
    
    @Bus
    @FluidDb
    
	def Handle( msg )
        @FluidDb.queryForResultset( "SELECT id FROM user_tbl", [] ).each do |row|
            @Bus.Send( GenerateFeed.new( row["id"].to_i ) )
        end
    end

end
