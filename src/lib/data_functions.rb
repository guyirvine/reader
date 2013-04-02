module DataFunctions

	def DataFunctions.checkPassword( fluiddb, username, password )
		return fluiddb.queryForValue( "SELECT id FROM user_tbl WHERE username = ? AND password = ?", [username, password] )
        rescue FluidDb::NoDataFoundError => e
		return nil
	end


	def DataFunctions.setPassword( fluiddb, uid, password )
        #############################################
        #SET uid:1000:password p1pp0
        #############################################
		fluiddb.set "uid:#{uid}:password", password

	end
    
    
	def DataFunctions.createSession( fluiddb, uid )
#############################################
#SET uid:1000:auth ABC
#SET auth:ABC 1000
#############################################
		skey = UUIDTools::UUID.random_create.to_s
        
		fluiddb.execute( "INSERT INTO session_tbl( id, user_id, key ) VALUES ( NEXTVAL( 'session_seq' ), ?, ? );", [uid, skey] );

		return skey
	end

	def DataFunctions.closeSession( fluiddb, skey )
#############################################
#SET auth:ABC 1000
#############################################
		fluiddb.del "auth:#{skey}"
	end



	def DataFunctions.createRememberme( fluiddb, uid )
#############################################
#SET rememberme:ABC:auth 1
#SADD uid:1:rememberme ABC
#############################################
        return nil;
		rkey = UUIDTools::UUID.random_create.to_s
		fluiddb.set "rememberme:#{rkey}:auth", uid
		fluiddb.expire "rememberme:#{rkey}:auth", ( Date.today >> 3 ).to_time.to_i

		fluiddb.sadd "uid:#{uid}:rememberme", rkey
		
		return rkey
	end

	def DataFunctions.checkRememberme( fluiddb, rkey )
#############################################
#GET rememberme:#{ABC}:auth 1
#############################################
        return nil;
		return fluiddb.get "rememberme:#{rkey}:auth"

	end

end
