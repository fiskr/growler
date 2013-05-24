/* Authors:
 * 	created by:
 * 	Justin Bauguess 	on 01/29/13
 *			
 *	edited by:
 *	Brandon Foster		from 02/05/13
 *			
 * Purpose:
 *	This script will drop and create every table designed.
 *	
 *	
 */
drop database if exists growler_db;
create database growler_db;
use growler_db;
/*
 * Creates the table for storing theme information
 */

/*dropping tables before we create them*/
DROP TABLE IF EXISTS theme; 

CREATE TABLE theme (
	 id			int		PRIMARY KEY auto_increment
	,name			varchar(30)
	,description		varchar(250)
	,creator		int		REFERENCES user(id)
	,year			year(4)
	,visible		boolean
	,reason			varchar(250) /*for user-suggested themes*/
	);

/*
 * Creates the table for storing user information
 */	
DROP TABLE IF EXISTS user; 
CREATE TABLE user (
	id			int		primary key auto_increment
	,name			varchar(26)	UNIQUE	
	,password		varchar(60)
	,corporate_id		varchar(6)
	,email			varchar(26)
	);

/*
 * Bridge table for the users and themes, designed to help keep track of ranks
 * Notice that theme_rank is storing ranks between 1 and 10, 1 being "best".
 */	
DROP TABLE IF EXISTS theme_ranking;
CREATE TABLE theme_ranking (
	user_id				int		REFERENCES user(id)	
	,theme_id			int		REFERENCES theme(id)	
	,theme_rank			int		CHECK (theme_rank > 0 AND theme_rank < 11)
	);
/*
 * Temporary Bridge table for ranking themes
 * Supports US10332, which specifies users are not tracked
 * Will be replaced when we start US10331: Exploration: Allow theme suggestion
 */
DROP TABLE IF EXISTS isolated_theme_ranking;
CREATE TABLE isolated_theme_ranking (
	ranking_id			int		PRIMARY KEY auto_increment
	,theme_id			int		REFERENCES theme(id)
	,ranking			int
	);
	
/*
 * Creates the table for storing speaker information
 * Notice: suggested_by attribute is foreign key referencing
 * id attribute in user table
 */
DROP TABLE IF EXISTS speaker; 
CREATE TABLE speaker (
	 id			int			PRIMARY KEY auto_increment
	,first_name		varchar(30)
	,last_name		varchar(30)
	,suggested_by		int			REFERENCES user(id)
	,visible		boolean
	);

/*
 * Creates the table for storing speaker ranks
 * temporary table to be replaced by session_ranking upon developing 
 * US10362, at which point session_ranking will bridge between
 * speaker_team (which itself bridges session_ranking and speaker tables)
 * and session tables.
 */
DROP TABLE IF EXISTS speaker_ranking;
CREATE TABLE speaker_ranking (
	user_id		int			REFERENCES user(id)
	,speaker_id		int			REFERENCES speaker(id)
	,ranking		int
	);

/*
 * Creates table for session information
 * A session is essentially a presentation given by a speaker_team (which may
 * be one or more speakers), attended by users.
 * A session has a start time, a start date, a duration, a location, 
 * and a track (which is either Technical or Business Friendly).
 * If multiple tracks need to be managed, we might centralize it with its
 * own table as we did with location. If there are only ever two tracks, 
 * and admin never need to add others, we will keep it as an attribute.
 * Survey key is a short, unique number allowing survey-takers to register their session
 * isAttendable is a boolean that is true only from start time to fifteen minutes past the session
 */

DROP TABLE IF EXISTS session;
CREATE TABLE session (
	id			int		PRIMARY KEY auto_increment
	,name			varchar(70)
	,description		text
	,track			varchar(20)
	,session_date		date
	,start_time		time
	,duration		int
	,location		int		REFERENCES location(id)
	);
	
/*
 * Creates the table for attending a session
 * Final field is for keeping the integrity of survey-taking
 * 	(each user can only take one survey)
 * We don't want to know which users filled out which surveys,
 * 	but we have to enforce them taking just one survey.
 * Hence, when a person submits a survey, there is a condition 
 * 	where, if isRegistered is false for that given user_id and session_id,
 *	the attribute is made true and records are submitted to session_ranking
 *	if isRegistered is true, however, there page redirects to explain
 *	that they've already submitted a survey for that session, and no	 
 *	records are inserted into session_ranking.
 */	
DROP TABLE IF EXISTS attendance;
CREATE TABLE attendance (
	user_id		int	REFERENCES user(id)
	,session_id	int	REFERENCES session(id)
	,isRegistered	boolean	DEFAULT '0'
	,CONSTRAINT pk_attendance PRIMARY KEY(user_id, session_id)
	);
	
/*
 * Creates the table for storing the survey questions,
 * which will be tied to session rankings. (Essentially, each rank value has
 * an associated question).
 */
	
DROP TABLE IF EXISTS question;
CREATE TABLE question (
	id			INT			PRIMARY KEY
	,text			VARCHAR(250)
	,year			YEAR(4) 
	);
	
/*
 * Creates a table for location information
 * A location is a room (or remote location) where a session is held
 * This is a separate table so that the locations are centralized and
 * sessions cannot all refer to the same place three different ways
 * and thus cause confusion- locations, instead, can be selected from
 * a centralized list produced from this table.
 */	

DROP TABLE IF EXISTS location;
CREATE TABLE location (
	id				int			PRIMARY KEY
	,description	varchar(50)
	);
	


	
/*
 * Creates the table for ranking sessions
 * There is no primary key: 
 * there is a high probability of multiple ratings given by different surveys
 * The created_on attribute is a timestamp of when the survey was submitted,
 * which is not a primary key because two records could conceivably be
 * submitted at the same time.
 */

DROP TABLE IF EXISTS session_ranking;
CREATE TABLE session_ranking (
	session_id		int	REFERENCES session(id)
	,question_id		int	REFERENCES question(id)
	,ranking		int	CHECK (ranking > 0 AND ranking < 6)
	);



/*
 * Creates the table for keeping track of speaker teams
 * Speaker teams are a way of allowing multiple speakers for a given session,
 * where a many to many relationship would exist, this bridge table associates
 * sessions and speakers.
 */

DROP TABLE IF EXISTS speaker_team;
CREATE TABLE speaker_team (
	session_id		int			REFERENCES session(id)
	,speaker_id		int			REFERENCES speaker(id)
	);


/*
 * Inserts the default user.  This user is typically associated with last year's data.
 */
insert into user values (2023, "DEFAULT", sha1('password'), NULL, NULL);
insert into user values (8083, "ADMIN", sha1('password'), NULL, NULL);


/*Theme inserts*/
INSERT INTO theme VALUES (1, "Cloud Computing", "All things Cloud, from IaaS, PaaS, DaaS, SaaS, to hosting providers, brokers, and cloud-enabling appliances", 2023, "2013", true, NULL);
INSERT INTO theme VALUES (2, "Development Frameworks", "Any type of development framework, regardless of language", 2023, "2013", true, NULL);
INSERT INTO theme VALUES (3, "Software Process/Lifecycle", "Waterfall, Agile, Scrum, Kanban, process improvements, new techniques", 2023, "2013", true, NULL);
INSERT INTO theme VALUES (4, "Mobility", "Topics related to mobile computing in the enterprise, including mobile apps, phones, tablets, and other devices", 2023, "2013", true, NULL);
INSERT INTO theme VALUES (5, "Social and Collaboration", "Tools and Techniques that make the enterprise more social and allow people to better communicate and collaborate when they are not in the same room, floor, building, city, state, or country", 2023, "2013", true, NULL);
INSERT INTO theme VALUES (6, "Show and Tell", "Show and Tell (Description)", 2023, "2013", true, NULL);

/*
 * Inserts the speakers from 2012
*/
insert into speaker (id, first_name, last_name, suggested_by, visible) values (49, "Ian", "Ratner", 2023, TRUE);
insert into speaker (id, first_name, last_name, suggested_by, visible) values (1, "Ram", "Karra", 2023, TRUE);
insert into speaker (id, first_name, last_name, suggested_by, visible) values (2,"Deborah","Cliburn",2023, TRUE);
insert into speaker (id, first_name, last_name, suggested_by, visible) values (3,"Prashanth","Chakrapani",2023, TRUE);
insert into speaker (id, first_name, last_name, suggested_by, visible) values (4,"Scott","Cruze",2023, TRUE);
insert into speaker (id, first_name, last_name, suggested_by, visible) values (5,"Mark","Kelly",2023, TRUE);
insert into speaker (id, first_name, last_name, suggested_by, visible) values (6,"Jim","Senter",2023, TRUE);
insert into speaker (id, first_name, last_name, suggested_by, visible) values (7,"Phil","Spann",2023, TRUE);
insert into speaker (id, first_name, last_name, suggested_by, visible) values (8,"Jeffrey","Allen",2023, TRUE);
insert into speaker (id, first_name, last_name, suggested_by, visible) values (9,"Bhaumik","Shah",2023, TRUE);
insert into speaker (id, first_name, last_name, suggested_by, visible) values (10,"Panagiotis","Tzerefos",2023, TRUE);
insert into speaker (id, first_name, last_name, suggested_by, visible) values (11,"Ben","Pack",2023, TRUE);
insert into speaker (id, first_name, last_name, suggested_by, visible) values (12,"David","Tucker",2023, TRUE);
insert into speaker (id, first_name, last_name, suggested_by, visible) values (13,"Matt","Peter",2023, TRUE);
insert into speaker (id, first_name, last_name, suggested_by, visible) values (14,"Pedro","Lopez",2023, TRUE);
insert into speaker (id, first_name, last_name, suggested_by, visible) values (15,"John","Hills",2023, TRUE);
insert into speaker (id, first_name, last_name, suggested_by, visible) values (16,"Bryan","Fails",2023, TRUE);
insert into speaker (id, first_name, last_name, suggested_by, visible) values (17,"Glen","Wright",2023, TRUE);
insert into speaker (id, first_name, last_name, suggested_by, visible) values (18,"Kevin","Barry",2023, TRUE);
insert into speaker (id, first_name, last_name, suggested_by, visible) values (19,"Jeffery","Kissinger",2023, TRUE);
insert into speaker (id, first_name, last_name, suggested_by, visible) values (20,"Beth","Jackson",2023, TRUE);
insert into speaker (id, first_name, last_name, suggested_by, visible) values (21,"Brian","Hinsley",2023, TRUE);
insert into speaker (id, first_name, last_name, suggested_by, visible) values (22,"Drew","Fredrick",2023, TRUE);
insert into speaker (id, first_name, last_name, suggested_by, visible) values (23,"Glen","Ireland",2023, TRUE);
insert into speaker (id, first_name, last_name, suggested_by, visible) values (24,"Robert","Clarence",2023, TRUE);
insert into speaker (id, first_name, last_name, suggested_by, visible) values (25,"Sarah","Cottay",2023, TRUE);
insert into speaker (id, first_name, last_name, suggested_by, visible) values (26,"Channing","Dawson",2023, TRUE);
insert into speaker (id, first_name, last_name, suggested_by, visible) values (27,"Mike","Campbell",2023, TRUE);
insert into speaker (id, first_name, last_name, suggested_by, visible) values (28,"Joshua","Eldridge",2023, TRUE);
insert into speaker (id, first_name, last_name, suggested_by, visible) values (29,"Bruce","Parker",2023, TRUE);
insert into speaker (id, first_name, last_name, suggested_by, visible) values (30,"Robin","Wilde",2023, TRUE);
insert into speaker (id, first_name, last_name, suggested_by, visible) values (31,"Lydia","Cordell",2023, TRUE);
insert into speaker (id, first_name, last_name, suggested_by, visible) values (32,"Team","Nirvana",2023, TRUE);
insert into speaker (id, first_name, last_name, suggested_by, visible) values (33,"Amy","Thomason",2023, TRUE);
insert into speaker (id, first_name, last_name, suggested_by, visible) values (34,"Charles","Lewis",2023, TRUE);
insert into speaker (id, first_name, last_name, suggested_by, visible) values (35,"Jonathan","Williams",2023, TRUE);
insert into speaker (id, first_name, last_name, suggested_by, visible) values (36,"Scott","Gentry",2023, TRUE);
insert into speaker (id, first_name, last_name, suggested_by, visible) values (37,"Jason","Norton",2023, TRUE);
insert into speaker (id, first_name, last_name, suggested_by, visible) values (38,"Michael","Wehrle",2023, TRUE);
insert into speaker (id, first_name, last_name, suggested_by, visible) values (39,"Shane","Closser",2023, TRUE);
insert into speaker (id, first_name, last_name, suggested_by, visible) values (40,"Selene","Tolbert",2023, TRUE);
insert into speaker (id, first_name, last_name, suggested_by, visible) values (41,"Michael","Berger",2023, TRUE);
insert into speaker (id, first_name, last_name, suggested_by, visible) values (42,"Kamlesh","Sharma",2023, TRUE);
insert into speaker (id, first_name, last_name, suggested_by, visible) values (43,"Kabita","Nayak",2023, TRUE);
insert into speaker (id, first_name, last_name, suggested_by, visible) values (44,"Herb","Himes",2023, TRUE);
insert into speaker (id, first_name, last_name, suggested_by, visible) values (45,"Stefanie","Edinger",2023, TRUE);
insert into speaker (id, first_name, last_name, suggested_by, visible) values (46, "Phil", "Cornell", 2023, TRUE);
insert into speaker (id, first_name, last_name, suggested_by, visible) values (47,"Allen", "Shacklock", 2023, TRUE);

/*
 * Loads a raw data file of session data from last year
 * into the sessions table so we can analyze last year's data
 * Session has the following fields: ID,Topic,Summary,Track,Date,Time,Duration,Location
 * Without the LOCAL, access may be denied to your statement.
 */
load data LOCAL infile 'C:/Users/162107/Documents/GitHub/growler/db/raw_data/sessions_2012.csv'
into table session
fields terminated by ','
ignore 1 lines;

/* Inserts the questions */
insert into question values (1, "This session met my expectations:", '2012');
insert into question values (2, "The speaker was knowledgable on the topic:", '2012');
insert into question values (3, "The speaker's presentation skills were good:", '2012');
insert into question values (4, "The facility was appropriate for the presentation:", '2012');

/* 
 * inserts locations
 */
 insert into location values (1, "KXTC Training Room");
 insert into location values (2, "KXOFFICE Training Room");


/*
 * Now each record in that table has a record for each survey submitted last year.
 * Next we need to link the speakers from last year to their presentations.
*/
insert into speaker_team values (5 , 49);
insert into speaker_team values (9 , 16);
insert into speaker_team values (9 , 17);
insert into speaker_team values (4 , 1);
insert into speaker_team values (4 , 2);
insert into speaker_team values (4 , 3);
insert into speaker_team values (6 , 16);
insert into speaker_team values (11 , 18);
insert into speaker_team values (7 , 4);
insert into speaker_team values (7 , 5);
insert into speaker_team values (7 , 6);
insert into speaker_team values (7 , 7);
insert into speaker_team values (10 , 19);
insert into speaker_team values (8 , 2);
insert into speaker_team values (30 , 20);
insert into speaker_team values (30 , 21);
insert into speaker_team values (1 , 8);
insert into speaker_team values (29 , 22);
insert into speaker_team values (2 , 9);
insert into speaker_team values (28 , 23);
insert into speaker_team values (28 , 24);
insert into speaker_team values (3 , 10);
insert into speaker_team values (3 , 11);
insert into speaker_team values (31 , 25);
insert into speaker_team values (31 , 26);
insert into speaker_team values (31 , 16);
insert into speaker_team values (31 , 19);
insert into speaker_team values (31 , 22);
insert into speaker_team values (17 , 27);
insert into speaker_team values (22 , 12);
insert into speaker_team values (18 , 28);
insert into speaker_team values (21 , 13);
insert into speaker_team values (20 , 30);
insert into speaker_team values (19 , 29);
insert into speaker_team values (23 , 14);
insert into speaker_team values (24 , 15);
insert into speaker_team values (25 , 32);
insert into speaker_team values (12 , 31);
insert into speaker_team values (13 , 44);
insert into speaker_team values (26 , 38);
insert into speaker_team values (14 , 33);
insert into speaker_team values (14 , 23);
insert into speaker_team values (14 , 34);
insert into speaker_team values (14 , 35);
insert into speaker_team values (14 , 36);
insert into speaker_team values (27 , 39);
insert into speaker_team values (16 , 45);
insert into speaker_team values (15 , 40);
insert into speaker_team values (34 , 7);
insert into speaker_team values (35 , 46);
insert into speaker_team values (35 , 47);
insert into speaker_team values (15 , 41);
insert into speaker_team values (32 , 37);
insert into speaker_team values (33 , 42);
insert into speaker_team values (33 , 43);


/* 
 * This file creates the table based on last year's data
 * which can be modified by the administrator later 
 */
DROP TABLE IF EXISTS ranks_2012;
CREATE TABLE ranks_2012 (
rating	DECIMAL(3, 2)
,speaker_id	int	REFERENCES speaker(id)
,count	int
);

/*
 * Loads a raw data file of session ranking data from last year
 * into the ranks_2012 table
 * ranks_2012: speaker_id, rating, and count
 */
load data LOCAL infile 'C:/Users/162107/Documents/GitHub/growler/db/raw_data/ranks_2012_out.csv'
into table ranks_2012
fields terminated by ',';

alter table session 
add column session_key varchar(4) UNIQUE;