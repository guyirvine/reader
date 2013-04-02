require 'net/http'
require 'uri'

uri = URI.parse( "http://sethgodin.typepad.com/seths_blog/" );
uri = URI.parse( "http://ayende.com/blog/" );

Net::HTTP.start( uri.host ) do |http|

	http.open_timeout = 2
	http.read_timeout = 2
	req = Net::HTTP::Head.new( uri.path )
	http.request(req).each { |k, v| puts "#{k}: #{v}" }

    resp = http.get( uri.path  )
    open( "tmp/" + File.basename( uri.path ) + ".rss", "wb") do |file|
        file.write(resp.body)
    end
end

