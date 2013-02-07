/*
Creates the table for storing theme information
Justin Bauguess 1/29/13
edited:
Brandon Foster 02/05/13
*/

--dropping tables before we create them
DROP TABLE theme; 

CREATE TABLE theme (
	 id			int		PRIMARY KEY
	,name			varchar(30)
	,description		varchar(250)
	,creator		int		REFERENCES user(id)
	,year			year(4),
	,visible		boolean,
	,active			boolean
	);
	
/*
Creates the table for storing user information
Justin Bauguess 1/29/13
*/	
DROP TABLE user; 
CREATE TABLE user (
	id			int		primary key
	);

/*
Bridge table for the users and themes, designed to help keep track of ranks
Justin Bauguess 1/29/13
*/	
DROP TABLE theme_ranking;
CREATE TABLE theme_ranking (
	user_id				int		REFERENCES user(id)	
	,theme_id			int		REFERENCES theme(id)	
	,theme_rank			int		CHECK (theme_rank > 0 AND theme_rank < 11)
	);
/*
Temporary Bridge table for ranking themes
*/
DROP TABLE test_ranks;
CREATE TABLE test_ranks (
	theme_id			int		REFERENCES theme(id)
	,ranking_id			int		PRIMARY KEY
	,ranking			int
	);
	
/*
Creates the table for storing speaker information
Justin Bauguess 1/29/13
*/
DROP TABLE speaker; 
CREATE TABLE speaker (
	 id				int			PRIMARY KEY
	,first_name			varchar(30)
	,last_name			varchar(30)
	,suggested_by			int			REFERENCES user(id)		
	);

/*
Creates the table for storing speaker ranks (temporary table?)
Justin Bauguess 2/7/13
*/
DROP TABLE speaker_ranking;
CREATE TABLE speaker_ranking (
	speaker_id		int			REFERENCES speaker(id)
	,ranking_id		int			PRIMARY KEY
	,ranking		int
	);
	