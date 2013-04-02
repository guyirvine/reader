class GenerateFeed
    attr_reader :id
    def initialize( id )
        @id = id
    end
end

class GenerateFeeds
end

class FeedUpdatedEvent
    attr_reader :id
    def initialize( id )
        @id = id
    end
end

class Downloads
end

class Download
    attr_reader :url
    def initialize( url )
        @url = url
    end
end