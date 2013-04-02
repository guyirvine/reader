require 'net/http'
require 'uri'

class MessageHandler_Download
    
	attr_accessor :Bus, :FluidDb, :DownloadDir
    
	def Handle( msg )
        uri = URI.parse( msg.url );
        path = @DownloadDir.path + "/" + File.basename( uri.path )
        
        Net::HTTP.start( uri.host ) do |http|
            
            http.open_timeout = 2
            http.read_timeout = 2
            #            req = Net::HTTP::Head.new( uri.path )
            #http.request(req).each { |k, v| puts "#{k}: #{v}" }

            resp = http.get( uri.path  )
            open( path, "wb") do |file|
                file.write(resp.body)
            end

        end
    end
    
    def fetch(uri_str, limit = 10)
        # You should choose better exception.
        raise ArgumentError, 'HTTP redirect too deep' if limit == 0

        url = URI.parse(uri_str)
        req = Net::HTTP::Get.new(url.path, { 'User-Agent' => ua })
        response = Net::HTTP.start(url.host, url.port) { |http| http.request(req) }
        case response
            when Net::HTTPSuccess     then response
            when Net::HTTPRedirection then fetch(response['location'], limit - 1)
            else
            response.error!
        end
    end

end

