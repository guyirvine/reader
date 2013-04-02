require "uuidtools"

class Login

	@FluidDb

	def initialize( redis )
		@FluidDb = redis
	end

	def CheckWithUsernamePassword( username, password, rememberme )
		uid = DataFunctions.checkPassword( @FluidDb, username, password )
		if uid.nil? then
			return nil;
		end

		rkey = DataFunctions.createRememberme( @FluidDb, uid ) if rememberme == "true"

		skey = DataFunctions.createSession( @FluidDb, uid )
		return skey, rkey
	end

	def CheckWithRememberme( rememberme )
		uid = DataFunctions.checkRememberme( @FluidDb, rememberme )
		if uid.nil? then
			return nil;
		end

		skey = DataFunctions.createSession( @FluidDb, uid )
		return skey
	end

	def getUidForCurrentSession( skey )
		return @FluidDb.get "auth:#{skey}"
	end

	def checkCurrentSessionHasAccessToHid( skey, hid )
		
		uid = self.getUidForCurrentSession( skey )
		if @FluidDb.sismember "uid:#{uid}:uid2hids", hid then
			response.status = 403
			return false
		end

		return true
	end

end

