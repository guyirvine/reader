class MessageHandler_Downloads
    
	attr_accessor :Bus, :FluidDb
    
	def Handle( msg )
        @FluidDb.queryForResultset( "SELECT url FROM feed_tbl", [] ).each do |row|
            @Bus.Send( Download.new( row["url"] ) )
        end
    end
    
end
