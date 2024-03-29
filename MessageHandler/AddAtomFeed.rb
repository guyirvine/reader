require 'xmlsimple'

class MessageHandler_AddAtomFeed
    
	attr_accessor :Bus, :FluidDb
    
	def Handle( msg )
        xml = msg.payload
        
        feed = self.getFeedPropertiesFromAtomAsHash( xml )
        feed_id = self.ensureFeedExists( feed );
        
        self.getEntries( xml ).each do |entry|
            self.ensureEntryExists( feed_id, entry )
        end
        
        @Bus.Send( GenerateFeed.new( 1 ) )
	end

    def getContentFromXmlElement( el )

        return el if el.is_a? String

        e = el[0]
        
        return e if e.is_a? String
        
        return e["content"]

        raise "Unknown element type, #{el.class.name}"
    end
    
    def downloadUrl( url )
        payload = ""
        
        return payload
    end
    
    def LoadXml( payload )
        return XmlSimple.xml_in( payload )
    end
    
    def getFeedPropertiesFromAtomAsHash( xml )
        id = self.getId( xml )
        title = self.getTitle( xml )
        url = self.getURLForFeed( xml )
        
        hash = Hash["id", id, "title", title, "url", url]
        
        return hash
    end
    def getURLForFeed( xml )
        xml["link"].each do |link|
            return link["href"] if link["rel"]=="alternate"
        end
        return nil;
    end
    
    def getTitle( xml )
        content = self.getContentFromXmlElement( xml["title"] )
        return content
    end
    
    def getId( xml )
        return xml["id"][0]
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
            id = @FluidDb.queryForValue( "SELECT id FROM entry_tbl WHERE source_id = ?", [entry["id"]])

            @FluidDb.execute( "UPDATE entry_tbl SET title = ?, updated = ?, body = ?, read = ? WHERE id = ?",
                             [entry["title"], entry["updated"], entry["body"], 0, id ] );
            rescue FluidDb::NoDataFoundError => e
            @FluidDb.execute( "INSERT INTO entry_tbl( id, feed_id, source_id, title, url, updated, body, read ) VALUES ( NEXTVAL( 'entry_seq' ), ?, ?, ?, ?, ?, ?, ? )",
                             [feed_id, entry["id"], entry["title"], entry["url"], entry["updated"], entry["body"], 0 ] );
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
        xml["entry"].each do |entry|
            url = self.getURLForEntry( entry["link"] )
            title = self.getContentFromXmlElement( entry["title"] )
            #            body = self.getContentFromXmlElement( entry["content"]["content"] )
            body = self.getContentFromXmlElement( entry["content"]["content"] )
            hash = Hash["id", entry["id"][0], "updated", entry["updated"][0], "title", title, "url", url, "body", body]

            #id
            #published
            #updated
            #category
            #title
            #content
            #link
            #author
            #total
            #            puts entry["link"]
            
            list << hash
            
        end
        return list
    end
    
end

