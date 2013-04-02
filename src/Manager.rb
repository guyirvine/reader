require "redis"
require "rservicebus"
require "FluidDb/Pgsql"
require "json"
require "uri"

require "lib/data_functions"
require "Login"

class Manager
    
	@Redis
	@Login
    
    def initialize
        ENV["FluidDb"] ||= "fluidpgsql://127.0.0.1/reader"
        uri = URI.parse(ENV["FluidDb"])
        
        @FluidDb = ::FluidDb::Pgsql.new( uri )
        @Login = Login.new( @FluidDb )
    end
    
    def run( env )
        request = Rack::Request.new(env)
        response = Rack::Response.new()
        
        request_name = request.path_info.sub( "/app/", "" ).downcase
        
        puts "request_name: #{request_name}"
        
        case request_name
            when "logout"
            skey = request.cookies["readersession"]
            
            DataFunctions.closeSession( @Redis, skey )
            response.set_cookie("readersession", nil)
            response.set_cookie("llid", nil)
            
            when "login"
			skey, rkey = @Login.CheckWithUsernamePassword( request.params["username"], request.params["password"], request.params["rememberme"] )
			if skey.nil? then
				response.status = 403
                else
				response.set_cookie("llid", {:value => rkey.to_s, :path => "/", :expires => ( Date.today >> 3 ).to_time}) if !rkey.nil?
                
				response.status = 200
				response.set_cookie("readersession", skey.to_s)
				response.body = [Hash["s", skey.to_s, "l", rkey.to_s].to_json]
			end
            when "rememberme"
			skey = @Login.CheckWithRememberme( request.params["rememberme"] )
			if skey.nil? then
				response.status = 403
                else
				response.set_cookie("llid", {:value => rkey.to_s, :path => "/", :expires => ( Date.today >> 3 ).to_time}) if !rkey.nil?
                
				response.status = 200
				response.set_cookie("readersession", skey.to_s)
				response.body = [skey.to_s]
			end
            
            
            when "set-passwd"
            skey = request.cookies["readersession"];
            if skey.nil? then
				response.status = 403
                else

                uid = @Login.getUidForCurrentSession( skey )
                if uid.nil? then
                    response.status = 403
                    else
                    DataFunctions.setPassword @Redis, uid, request.params["passwd"]
                end

				response.status = 200
            end
            
            else
			response.status = 404
        end
        
        response.finish
    end
    
end
