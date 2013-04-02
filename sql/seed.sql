INSERT INTO user_tbl( id, username, password ) VALUES ( NEXTVAL( 'user_seq' ), 'guyirvine', 'password' );


INSERT INTO feed_tbl( id, source_id, name, url ) VALUES ( NEXTVAL( 'feed_seq' ), 'tag:blogger.com,1999:blog-4999557720148026925', 'Linus'' blog', 'http://torvalds-family.blogspot.com/' );
INSERT INTO subscription_tbl( id, user_id, feed_id ) VALUES ( NEXTVAL( 'subscription_seq' ), CURRVAL( 'user_seq' ), CURRVAL( 'feed_seq' ) );

INSERT INTO feed_tbl( id, source_id, name, url ) VALUES ( NEXTVAL( 'feed_seq' ), 'tag:typepad.com,2003:weblog-3511', 'Seth''s Blog', 'http://feeds.feedburner.com/typepad/sethsmainblog' );
INSERT INTO subscription_tbl( id, user_id, feed_id ) VALUES ( NEXTVAL( 'subscription_seq' ), CURRVAL( 'user_seq' ), CURRVAL( 'feed_seq' ) );

INSERT INTO feed_tbl( id, source_id, name, url ) VALUES ( NEXTVAL( 'feed_seq' ), 'http://ayende.com/blog/', 'Ayende @ Rahien', 'http://ayende.com/blog/rss' );
INSERT INTO subscription_tbl( id, user_id, feed_id ) VALUES ( NEXTVAL( 'subscription_seq' ), CURRVAL( 'user_seq' ), CURRVAL( 'feed_seq' ) );

