CREATE SEQUENCE user_seq;
CREATE SEQUENCE subscription_seq;
CREATE SEQUENCE feed_seq;
CREATE SEQUENCE entry_seq;
CREATE SEQUENCE session_seq;

CREATE TABLE user_tbl (
id BIGINT NOT NULL,
username VARCHAR(50) NOT NULL,
password VARCHAR(50) NOT NULL,
CONSTRAINT user_pk PRIMARY KEY ( id ),
CONSTRAINT user_username_unq UNIQUE ( username ) );

CREATE TABLE feed_tbl (
id BIGINT NOT NULL,
source_id VARCHAR(2048) NOT NULL,
name VARCHAR(2048) NOT NULL,
url VARCHAR(2048) NOT NULL,
CONSTRAINT feed_pk PRIMARY KEY ( id ) );

CREATE TABLE entry_tbl (
id BIGINT NOT NULL,
feed_id BIGINT NOT NULL,
source_id VARCHAR(2048) NOT NULL,
title VARCHAR(2048) NOT NULL,
url VARCHAR(2048) NOT NULL,
updated TIMESTAMP NOT NULL,
body text NOT NULL,
read INT NOT NULL,
CONSTRAINT entry_pk PRIMARY KEY ( id ),
CONSTRAINT entry_feed_fk FOREIGN KEY ( feed_id ) REFERENCES feed_tbl ( id ) );

CREATE TABLE subscription_tbl (
id BIGINT NOT NULL,
user_id BIGINT NOT NULL,
feed_id BIGINT NOT NULL,
CONSTRAINT subscription_pk PRIMARY KEY ( id ),
CONSTRAINT subscription_unq UNIQUE ( user_id, feed_id ),
CONSTRAINT subscription_user_fk FOREIGN KEY ( user_id ) REFERENCES user_tbl ( id ),
CONSTRAINT subscription_feed_fk FOREIGN KEY ( feed_id ) REFERENCES feed_tbl ( id ) );

CREATE TABLE session_tbl (
id BIGINT NOT NULL,
user_id BIGINT NOT NULL,
key VARCHAR(50) NOT NULL,
CONSTRAINT session_pk PRIMARY KEY ( id ),
CONSTRAINT session_user_fk FOREIGN KEY (user_id) REFERENCES user_tbl( id ),
CONSTRAINT session_key_unq UNIQUE (key) );


CREATE VIEW feed_vw AS
    SELECT f.id, f.name, s.user_id 
    FROM feed_tbl f, subscription_tbl s 
    WHERE f.id = s.feed_id 
    ORDER BY f.name;

CREATE VIEW entry_vw AS
    SELECT e.id, e.feed_id, e.title, e.updated, e.body, e.read, s.user_id
    FROM entry_tbl e, feed_tbl f, subscription_tbl s
    WHERE e.feed_id = f.id
    AND f.id = s.feed_id
    ORDER BY updated DESC, title;

