require 'xmlsimple'

class MessageHandler_AddRssFeed
    
	attr_accessor :Bus, :FluidDb
    
	def Handle( msg )
        xml = msg.payload["channel"][0]
        
        feed = self.getFeedPropertiesFromRssAsHash( xml )
        feed_id = self.ensureFeedExists( feed );
        
        self.getEntries( xml ).each do |entry|
            self.ensureEntryExists( feed_id, entry )
        end
        @Bus.Send( GenerateFeed.new( 1 ) )
	end
    
    def LoadXml( payload )
        xml = XmlSimple.xml_in( payload )
        return xml["channel"][0]
    end
    
    def getContentFromXmlElement( el )

        e = el[0]
        
        return e if e.is_a? String
        
        return e["content"]

        raise "Unknown element type, #{el.class.name}"
    end
    
    def downloadUrl( url )
        payload = ""
        
        return payload
    end
    
    def getFeedPropertiesFromRssAsHash( xml )
        id = self.getId( xml )
        title = self.getTitle( xml )
        url = self.getURLForFeed( xml )
        
        hash = Hash["id", id, "title", title, "url", url]
        
        return hash
    end

    def getURLForFeed( xml )
        return xml["link"][0]
    end
    
    def getTitle( xml )
        content = self.getContentFromXmlElement( xml["title"] )
        return content
    end
    
    def getId( xml )
        return xml["link"][0]
    end
    
    def ensureFeedExists( feed )
        begin
            id = @FluidDb.queryForValue( "SELECT id FROM feed_tbl WHERE source_id = ?", [feed["id"]])
            rescue FluidDb::NoDataFoundError => e
            @FluidDb.execute( "INSERT INTO feed_tbl( id, source_id, name, url ) VALUES ( NEXTVAL( 'feed_seq' ), ?, ?, ? )", [feed["id"], feed["title"], feed["url"] ] );
            id = @FluidDb.queryForValue( "SELECT CURRVAL('feed_seq')", [] );
        end
        return id
    end
    
    def ensureEntryExists( feed_id, entry )
        begin
            source_id = entry["id"]
            id = @FluidDb.queryForValue( "SELECT id FROM entry_tbl WHERE source_id = ?", [source_id])

            @FluidDb.execute( "UPDATE entry_tbl SET title = ?, updated = ?, body = ?, read = ? WHERE id = ?",
                             [entry["title"], entry["updated"], entry["body"], 0, id ] );
            rescue FluidDb::NoDataFoundError => e
            @FluidDb.execute( "INSERT INTO entry_tbl( id, feed_id, source_id, title, url, updated, body, read ) VALUES ( NEXTVAL( 'entry_seq' ), ?, ?, ?, ?, ?, ?, ? )",
                             [feed_id, source_id, entry["title"], entry["url"], entry["updated"], entry["body"], 0 ] );
        end
    end

    def getURLForEntry( links )
        links.each do |link|
            return link["href"] if link["rel"]=="alternate"
        end
        return nil;
    end
    
    def getEntries( xml )
        list = Array.new
        xml["item"].each do |entry|
            id = self.getContentFromXmlElement(entry["guid"])
            updated = self.getContentFromXmlElement(entry["pubDate"])
            url = self.getContentFromXmlElement( entry["link"] )
            title = self.getContentFromXmlElement( entry["title"] )
            body = self.getContentFromXmlElement( entry["description"] )

            hash = Hash["id", id, "updated", updated, "title", title, "url", url, "body", body]

            list << hash
            
        end
        return list
    end
    
end

