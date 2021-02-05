USE projectone;

CREATE DATABASE projectone;

CREATE EXTERNAL TABLE clickstream 
(article STRING,
next_article STRING,
external_link STRING,
clicks INT
)ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t '
TBLPROPERTIES("skip.header.line.count"="1");

DROP TABLE dec_pageviews;

LOAD DATA LOCAL INPATH '/Users/home/clickstream-enwiki-2020-12.tsv' INTO TABLE clickstream;

SELECT article, SUM(clicks)FROM clickstream
WHERE external_link = 'link' AND article ='Joe_Walsh'
GROUP BY article
ORDER BY SUM(clicks) DESC;

//Album 4742 / 24,492 = 0.1936
//Don_Felder 3022 / 20,636 = 0.1464
//Eagles_(band) 2808 / 382,898 = 0.0073
//Don_Henley 2740 / 64,278 = 0.0426
//Glenn_Frey 1938 / 59,462 = 0.0325
//Joe_Walsh 1314 / 78,008 = 0.0168

SELECT article, external_link, SUM(clicks) FROM clickstream
WHERE external_link = 'link'
GROUP BY article, external_link 
ORDER BY SUM(clicks) DESC;

CREATE EXTERNAL TABLE dec_pageviews
(lang STRING,
article STRING,
numViews INT,
clicks INT
)ROW FORMAT DELIMITED
FIELDS TERMINATED BY ' '
TBLPROPERTIES("skip.header.line.count"="1");

LOAD DATA LOCAL INPATH '/Users/home/pageviews-20210120-000000' INTO TABLE pageviews;
LOAD DATA LOCAL INPATH '/Users/home/pageviews-20210120-090000' INTO TABLE pageviews;
LOAD DATA LOCAL INPATH '/Users/home/pageviews-20210120-100000' INTO TABLE pageviews;
LOAD DATA LOCAL INPATH '/Users/home/pageviews-20210120-110000' INTO TABLE pageviews;
LOAD DATA LOCAL INPATH '/Users/home/pageviews-20210120-120000' INTO TABLE pageviews;
LOAD DATA LOCAL INPATH '/Users/home/pageviews-20210120-130000' INTO TABLE pageviews;
LOAD DATA LOCAL INPATH '/Users/home/pageviews-20210120-140000' INTO TABLE pageviews;
LOAD DATA LOCAL INPATH '/Users/home/pageviews-20210120-150000' INTO TABLE pageviews;
LOAD DATA LOCAL INPATH '/Users/home/pageviews-20210120-160000' INTO TABLE pageviews;
LOAD DATA LOCAL INPATH '/Users/home/pageviews-20210120-170000' INTO TABLE pageviews;
LOAD DATA LOCAL INPATH '/Users/home/pageviews-20210120-180000' INTO TABLE pageviews;
LOAD DATA LOCAL INPATH '/Users/home/pageviews-20210120-190000' INTO TABLE pageviews;



SELECT lang, article, SUM(numviews)FROM pageviews
WHERE lang LIKE 'en%' AND article = 'Elliot_Page'
GROUP BY article, lang;

CREATE TABLE dec_pageviews
(lang STRING,
article STRING,
numViews INT,
clicks INT
)ROW FORMAT DELIMITED
FIELDS TERMINATED BY ' '
TBLPROPERTIES("skip.header.line.count"="1");

CREATE TABLE dec_pageviews_partitioned
(lang STRING,
article STRING,
clicks INT
) PARTITIONED BY (numViews INT)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ' ';

INSERT INTO TABLE dec_pageviews_partitioned PARTITION(numViews)
SELECT lang, article, numviews, clicks FROM dec_pageviews WHERE numviews >= 1000000;

LOAD DATA LOCAL INPATH '/Users/home/pageviews-20201201-090000' INTO TABLE dec_pageviews;
LOAD DATA LOCAL INPATH '/Users/home/pageviews-20201201-100000' INTO TABLE dec_pageviews;
LOAD DATA LOCAL INPATH '/Users/home/pageviews-20201201-110000' INTO TABLE dec_pageviews;
LOAD DATA LOCAL INPATH '/Users/home/pageviews-20201201-120000' INTO TABLE dec_pageviews;
LOAD DATA LOCAL INPATH '/Users/home/pageviews-20201201-130000' INTO TABLE dec_pageviews;
LOAD DATA LOCAL INPATH '/Users/home/pageviews-20201201-140000' INTO TABLE dec_pageviews;
LOAD DATA LOCAL INPATH '/Users/home/pageviews-20201201-150000' INTO TABLE dec_pageviews;
LOAD DATA LOCAL INPATH '/Users/home/pageviews-20201201-160000' INTO TABLE dec_pageviews;
LOAD DATA LOCAL INPATH '/Users/home/pageviews-20201201-170000' INTO TABLE dec_pageviews;
LOAD DATA LOCAL INPATH '/Users/home/pageviews-20201201-180000' INTO TABLE dec_pageviews;
LOAD DATA LOCAL INPATH '/Users/home/pageviews-20201201-190000' INTO TABLE dec_pageviews;

//QUESTION 1

SELECT * FROM pageviews 
WHERE lang LIKE 'en%'
ORDER BY numviews DESC;

//QUESTION 2

SELECT dec_pageviews.article, SUM(clickstream.clicks)/SUM(dec_pageviews.numviews * 30)AS results FROM dec_pageviews 
JOIN clickstream ON (dec_pageviews.article = clickstream.article)
WHERE lang LIKE 'en%' AND external_link = 'link'
GROUP BY dec_pageviews.article
ORDER BY results DESC;

//QUESTION 3

SELECT article, next_article, AVG(clicks) as clicks FROM clickstream 
WHERE article ='Hotel_California' AND external_link ='link'
GROUP BY article, clicks, next_article 
ORDER BY clicks DESC
LIMIT 10;

// WRITE the top 10 results
// Hotel_California_(Eagles_album), 2371 -> 0.09745111926342678
// Don_Felder, 1511 -> 0.07587322597249797
// Eagles_(band) 1404 -> 0.7253174819664182
// Don_Henley 1370 ->  0.19228790235730525
// Glenn_Frey 969 -> 0.2739477369895327
// Joe_Walsh 657 -> 0.29389514293895147
// Loree_Rodkin 429 -> 0.121989121989122
// Desperado_(Eagles_song) 327 -> 0.19818486731774687
// The_Magus_(novel) 327 -> 0.2095893403232853
// Coda_(music) 320 -> 0.20610119047619047

SELECT article, AVG(clicks)/320 AS clicks from clickstream 
WHERE article='Coda_(music)' AND external_link = 'link'
GROUP BY article;

//QUESTION 4

CREATE EXTERNAL TABLE pageviews_uk
(lang STRING,
article STRING,
numViews INT,
clicks INT
) 
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ' ';

SELECT dec_pageviews.article, (pageviews_uk.numviews/dec_pageviews.numviews) AS perc_diff FROM dec_pageviews
INNER JOIN pageviews_uk ON (dec_pageviews.article = pageviews_uk.article)
GROUP BY dec_pageviews.article 
ORDER BY perc_diff DESC;

//dec_viewpages data was pulled assuming peak internet hours of 9AM - 7PM

 

//TOP viewed in dec_pageviews

Elliot_Page 410,998 -> UK = 406,273/410,998 = 0.988
Main_Page 3,004,047 -> UK = 1,338,802/3,004,047 = 0.4456
Emma_Portner 134,573 -> UK = 97,636/134,573 = 0.7255
Ellen_Page 155,609 -> UK 140,733/155,609 = 0.9044
Neera_Tanden 90,781 -> UK 48,099/90,781 = 0.5298

SELECT article, SUM(numviews)FROM pageviews_uk
WHERE lang like 'en%' AND article = 'Neera_Tanden'
GROUP BY article;

//QUESTION 5

CREATE TABLE revision_wiki (
	wiki_db STRING,
	event_entity STRING,
	event_type STRING,
	event_timestamp STRING,
	event_comment STRING,
	event_user_id INT,
	event_user_text_historical STRING,
	event_user_text STRING,
	event_user_blocks_historical STRING,
	event_user_blocks STRING,
	event_user_groups_historical STRING,
	event_user_groups STRING,
	event_user_is_bot_by_historical STRING,
	event_user_is_bot_by STRING,
	event_user_is_created_by_self BOOLEAN,
	event_user_is_created_by_system BOOLEAN,
	event_user_is_created_by_peer BOOLEAN,
	event_user_is_anonymous BOOLEAN, 
	event_user_registration_timestamp STRING,
	event_user_creation_timestamp STRING,
	event_user_first_edit_timestamp STRING,
	event_user_revision_count INT,
	event_user_seconds_since_previous_revision INT,
	page_id INT,
	page_title_historical  STRING,
	page_title  STRING,
	page_namespace_historical INT,
	page_namespace_is_content_historical BOOLEAN,
	page_namespace INT,
	page_namespace_is_content BOOLEAN,
	page_is_redirect BOOLEAN,
	page_is_deleted BOOLEAN,
	page_creation_timestamp STRING,
	page_first_edit_timestamp STRING,
	page_revision_count INT,
	page_seconds_since_previous_revision INT,
	user_id INT,
	user_text_historical string,	
	user_text	string,
	user_blocks_historical string,
	user_blocks	string,	
	user_groups_historical	string,	
	user_groups	string,
	user_is_bot_by_historical string,	
	user_is_bot_by	string,	
	user_is_created_by_self boolean,	
	user_is_created_by_system boolean,
	user_is_created_by_peer boolean,
	user_is_anonymous boolean,
	user_registration_timestamp	string,
	user_creation_timestamp	string,
	user_first_edit_timestamp	string,
	revision_id INT,
	revision_parent_id INT, 
	revision_minor_edit boolean, 
	revision_deleted_parts	string,
	revision_deleted_parts_are_suppressed boolean,
	revision_text_bytes INT, 
	revision_text_bytes_diff INT, 
	revision_text_sha1	string,
	revision_content_model	string, 
	revision_content_format	string, 
	revision_is_deleted_by_page_deletion boolean,	
	revision_deleted_by_page_deletion_timestamp	string, 
	revision_is_identity_reverted boolean,
	revision_first_identity_reverting_revision_id INT,
	revision_seconds_to_identity_revert INT,
	revision_is_identity_revert boolean,
	revision_is_from_before_page_creation boolean,
	revision_tags	string
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t';

LOAD DATA LOCAL INPATH '/Users/home/2020-12.enwiki.2020-12.tsv' INTO TABLE revision_wiki;


SELECT AVG(page_seconds_since_previous_revision)/3600 as vandAvgCorTime FROM revision_wiki
WHERE event_comment LIKE '%vandal%';

// 101.2299 / 9 for the multiplier = 11.24

SELECT AVG(numviews)*11.24 AS avgWitnesses FROM pageviews;

//QUESTION 6


CREATE TABLE jan_27_pageviews
(lang STRING,
article STRING,
numViews INT,
clicks INT
) 
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ' ';

SELECT pageviews.article, (SUM(pageviews.numviews)/SUM(jan_27_pageviews.numviews)) * 100 as increase FROM pageviews 
JOIN jan_27_pageviews ON (pageviews.article = jan_27_pageviews.article)
WHERE pageviews.article = 'GameStop'
GROUP BY pageviews.article ;


SET hive.exec.dynamic.partition=true;
SET hive.exec.dynamic.partition.mode=nonstrict;
SET hive.exec.parallel=true;
SET hive.groupby.skewindata=false;
SET hive.map.aggr.hash.min.reduction=0.5;
