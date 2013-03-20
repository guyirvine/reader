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
        return xml["title"][0]["content"]
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
            hash = Hash["id", entry["id"][0], "updated", entry["updated"][0], "title", entry["title"][0]["content"], "url", url, "body", entry["content"]["content"]]
            
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

