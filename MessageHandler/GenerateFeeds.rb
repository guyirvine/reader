
class MessageHandler_GenerateFeeds
    
	attr_accessor :Bus
    
    @Bus
    
	def Handle( msg )
        @Bus.Send( GenerateFeed.new( 1 ) )
    end

end
