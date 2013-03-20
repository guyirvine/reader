INSERT INTO feed_tbl( id, source_id, name, url ) VALUES ( NEXTVAL( 'feed_seq' ), 1, 'Linus', 'http' );
INSERT INTO entry_tbl( id, feed_id, source_id, title, url, updated, body, read ) VALUES ( NEXTVAL( 'entry_seq' ), CURRVAL( 'feed_seq' ), 1, 'Entry A', 'http', '1 Jun 2013', 'This is some entry A', -1 );
INSERT INTO entry_tbl( id, feed_id, source_id, title, url, updated, body, read ) VALUES ( NEXTVAL( 'entry_seq' ), CURRVAL( 'feed_seq' ), 2, 'Entry B', 'http', '1 Jun 2013', 'This is some entry B', -1 );
INSERT INTO entry_tbl( id, feed_id, source_id, title, url, updated, body, read ) VALUES ( NEXTVAL( 'entry_seq' ), CURRVAL( 'feed_seq' ), 3, 'Entry D', 'http', '1 Jun 2013', 'This is some entry D', 0 );

INSERT INTO feed_tbl( id, source_id, name, url ) VALUES ( NEXTVAL( 'feed_seq' ), 2, 'Martin Fowler', 'http' );
INSERT INTO entry_tbl( id, feed_id, source_id, title, url, updated, body, read ) VALUES ( NEXTVAL( 'entry_seq' ), CURRVAL( 'feed_seq' ), 4, 'Entry C', 'http', '1 Jun 2013', 'This is some entry C', -1 );

--{ "feeds": [ {"id": 1, "name": "Linus"}, { "id": 2, "name": "Martin Fowler"}],
--    "list": [
--    { "feedId": 1, "title": "Entry A", "date": "1 Jun 2012", "body": "This is some entry A", "read": -1 },
--    { "feedId": 1, "title": "Entry B", "date": "1 Jun 2012", "body": "This is some entry B", "read": -1 },
--    { "feedId": 2, "title": "Entry C", "date": "1 Jun 2012", "body": "This is some entry C", "read": -1 },
--    { "feedId": 1, "title": "Entry D", "date": "1 Jun 2012", "body": "This is some entry D", "read": 0 }
--    ]
--}
