
class MessageHandler_FeedUpdatedEvent

	attr_accessor :Bus, :FluidDb
    
    @Bus
    @FluidDb
    
	def Handle( msg )
        @FluidDb.queryForResultset( "SELECT user_id FROM subscription_tbl WHERE feed_id = ?", [msg.id] ).each do |row|
            @Bus.Send( GenerateFeed.new( row["id"].to_i ) )
        end
    end

end
