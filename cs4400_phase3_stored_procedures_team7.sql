-- CS4400: Introduction to Database Systems (Summer 2022)
-- Phase III: Stored Procedures & Views [v0] Monday, July 7, 2022 @ 9:30 am EDT

-- Team 7
-- Thi Tran (ttran372)
-- Chuandong Liu (cliu702)
-- Taleb Hirani (thirani7)
-- Simon Abrelat (sabrelat3)

-- Directions:
-- Please follow all instructions for Phase III as listed on Canvas.
-- Fill in the team number and names and GT usernames for all members above.
-- Create Table statements must be manually written, not taken from an SQL Dump file.
-- This file must run without error for credit.

drop database if exists footballWonderland;
create database footballWonderland;
use footballWonderland;

SET SQL_SAFE_UPDATES = 0;

-- -----------------------------------------------
-- table structures(DO NOT CHANGE!)
-- -----------------------------------------------

DROP TABLE IF EXISTS competition;
CREATE TABLE competition(
  ID char(9) NOT NULL, 
  event char(255) NOT NULL,
  type char(255) NOT NULL,
  year decimal(4, 0) NOT NULL, 
  PRIMARY KEY (ID)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS company;
CREATE TABLE company(
  comp_ID CHAR(9) NOT NULL, 
  comp_name char(255) NOT NULL,
  address char(255) NOT NULL,
  endorse_player char(255),
  PRIMARY KEY (comp_ID)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS team;
CREATE TABLE team(
  ID char(9) NOT NULL, 
  name char(255) NOT NULL,
  country char(255) NOT NULL,
  captain char(255) NOT NULL,
  PRIMARY KEY (ID)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS club_team;
CREATE TABLE club_team(
  ID char(9) NOT NULL, 
  country_rank decimal(2, 0) NOT NULL,
  PRIMARY KEY (ID)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS national_team;
CREATE TABLE national_team(
  ID char(9) NOT NULL, 
  world_rank decimal(2, 0) NOT NULL,
  PRIMARY KEY (ID)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS worker;
CREATE TABLE worker(
  ID CHAR(9) NOT NULL, 
  f_name CHAR(100) NOT NULL,
  l_name CHAR(100) NOT NULL,
  country CHAR(100) NOT NULL,
  entered_year year NOT NULL,
  estimated_salary decimal(3, 0) NOT NULL,
  club char(255) NOT NULL,
  is_coach boolean,
  is_player boolean,
  PRIMARY KEY (ID)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS coach;
CREATE TABLE coach(
  ID CHAR(9) NOT NULL, 
  num_years decimal(3, 0) NOT NULL,
  license char(255) NOT NULL,
  PRIMARY KEY (ID)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS player;
CREATE TABLE player(
  ID CHAR(9) NOT NULL, 
  jersey_number decimal(2, 0) NOT NULL,
  position char(255) NOT NULL,
  birthday char(255) NOT NULL,
  num_goals decimal(2, 0) NOT NULL,
  num_assist decimal(2, 0) NOT NULL,
  represent_Nation varchar(255),
  lead_club boolean,
  lead_country boolean,
  PRIMARY KEY (ID)
) ENGINE=InnoDB;


DROP TABLE IF EXISTS orders;
CREATE TABLE orders(
  orderID decimal(4, 0) NOT NULL, 
  num_item_1 decimal(2, 0) NOT NULL,
  price_item_1 decimal(3, 0) NOT NULL,
  name_item_1 Char(100) NOT NULL,
  num_item_2 decimal(2, 0),
  price_item_2 decimal(3, 0),
  name_item_2 Char(100),
  club char(9) NOT NULL,
  selector CHAR(9) NOT NULL,
  PRIMARY KEY (orderID)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS participate;
CREATE TABLE participate(
  teamID char(9) NOT NULL, 
  competition char(9) NOT NULL,
  PRIMARY KEY (teamID,competition)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS sponsor_comp;
CREATE TABLE sponsor_comp(
  company_ID CHAR(9) NOT NULL, 
  competition char(9) NOT NULL,
  PRIMARY KEY (company_ID,competition)
) ENGINE=InnoDB;

-- -----------------------------------------------
-- referential structures(DO NOT CHANGE!)
-- -----------------------------------------------

alter table club_team add constraint fk_1 foreign key (ID) references team (ID)
	on update cascade on delete cascade;

alter table national_team add constraint fk_2 foreign key (ID) references team (ID)
	on update cascade on delete cascade;

alter table coach add constraint coach_fk_3 foreign key (ID) references worker (ID)
	on update cascade on delete cascade;

alter table player add constraint player_fk_4 foreign key (ID) references worker (ID)
	on update cascade on delete cascade;
    
alter table orders add foreign key (club) references club_team(ID)
	on update cascade on delete cascade;
    
alter table participate add constraint fk_6 foreign key (teamID) references team(ID)
	on update cascade on delete cascade;

alter table participate add constraint fk_7 foreign key (competition) references competition(ID)
	on update cascade on delete cascade;

alter table sponsor_comp add constraint fk_8 foreign key (company_ID) references company(comp_ID)
	on update cascade on delete cascade;

alter table sponsor_comp add constraint fk_9 foreign key (competition) references competition(ID)
	on update cascade on delete cascade;


-- -----------------------------------------------
-- table data(DO NOT CHANGE!)
-- -----------------------------------------------
INSERT INTO team VALUES ('RMD', "Real Madrid CF", 'Spain', 'Karim Benzema');
INSERT INTO team VALUES ('MCF', "Manchester City F.C.", 'United Kingdom', 'Fernando Luiz Roza');
INSERT INTO team VALUES ('BEL', 'Belgium national football team',	'Belgium', 'Eden Hazard');
INSERT INTO team VALUES ('CRO', 'Croatia National Football Team',  'Croatia',	'Luka Modric');

INSERT INTO club_team VALUES ('RMD', 1);
INSERT INTO club_team VALUES ('MCF', 1);

INSERT INTO national_team VALUES ('BEL', 2);
INSERT INTO national_team VALUES ('CRO', 15);

INSERT INTO competition VALUES ('wc_18', 'World Cup', 'National game', 2018);
INSERT INTO competition VALUES ('ec_21', 'UEFA European Championship ', 'Club game', 2021);

INSERT INTO worker VALUES ('LM360', 'Luka', 'Modric', 'Croatia', 2012, 325, 'RMD', False, True);
INSERT INTO worker VALUES ('TC361', 'Thibaut', 'Courtois', 'Belgium', 2018, 300, 'RMD', False, True);
INSERT INTO worker VALUES ('KB367', 'Karim', 'Benzema', 'France', 2009, 276, 'RMD', False, True);
INSERT INTO worker VALUES ('EH370', 'Eden', 'Hazard', 'Belgium', 2019, 430, 'RMD', False, True);
INSERT INTO worker VALUES ('CA130', 'Carlo', 'Ancelotti', 'Italy', 2021, 355, 'RMD', True, False);
INSERT INTO worker VALUES ('KD415', 'Kevin', 'De Bruyne', 'Belgium', 2015, 390, 'MCF', False, True);
INSERT INTO worker VALUES ('AP407', 'Ante', 'Palaversa', 'Croatia', 2019, 18, 'MCF', False, True);
INSERT INTO worker VALUES ('PG140', 'Pep', 'Guardiola', 'Spain', 2016, 385, 'MCF', True, False);

INSERT INTO company VALUES ('NK02', 'Nike', 'One Bowerman Dr, Beaverton, OR 97005, United States', 'TC361');
INSERT INTO company VALUES ('CC03', 'Coca-Cola', '1 Coca Cola Plz NW, Atlanta, GA 30313, United States', 'EH370');

INSERT INTO coach VALUES ('PG140', 6, '303-549-882');
INSERT INTO coach VALUES ('CA130', 1, '303-600-411');

INSERT INTO player VALUES ('LM360', 10, 'Midfielder', '09/09/1985', 2, 12, 'Croatia', False, True);
INSERT INTO player VALUES ('TC361', 1, 'Goal-keeper', '05/11/1992', 0, 0, 'Belgium', False, False);
INSERT INTO player VALUES ('KB367', 9, 'Forward', '05/11/1992', 27, 12, 'France', True, False);
INSERT INTO player VALUES ('KD415', 17, 'Midfielder', '06/28/1991', 15, 8, 'Belgium', False, False);
INSERT INTO player VALUES ('EH370', 7, 'Forward', '01/07/1991', 2, 1, 'Belgium', False, True);
INSERT INTO player VALUES ('AP407', 8, 'Midfielder', '04/06/2000', 2, 4, Null, False, False);

INSERT INTO sponsor_comp VALUES ('NK02', 'wc_18');
INSERT INTO sponsor_comp VALUES ('NK02', 'ec_21');
INSERT INTO sponsor_comp VALUES ('CC03', 'wc_18');

INSERT INTO participate VALUES ('RMD', 'ec_21');
INSERT INTO participate VALUES ('MCF', 'ec_21');
INSERT INTO participate VALUES ('BEL', 'wc_18');
INSERT INTO participate VALUES ('CRO', 'wc_18');

INSERT INTO orders VALUES (2316, 30, 100, 'Football', 25, 230, 'Shoes', 'RMD', 'CA130');
INSERT INTO orders VALUES (4400, 2, 300, 'Training poles', Null, Null, Null, 'RMD', 'CA130');


-- -----------------------------------------------
-- stored procedures and views
-- -----------------------------------------------






add_player
delimiter // 
create procedure add_player (in ip_ID char(9),
	in ip_first_name char(100), in ip_last_name char(100),
	in ip_country char(255), in ip_ent_year year,
	in ip_salary decimal(3, 0), in ip_club char(255), in ip_jersey_number decimal(2, 0),
    in ip_position char(255), in ip_birthday char(255), in ip_represent_Nation varchar(255),
    in ip_lead_club boolean, in ip_lead_country boolean)
sp_main: begin
	if (ip_ID in (select ID from worker) or 
        ip_jersey_number in 
			(select jersey_number from 
				worker left join player on worker.ID = player.ID
			where club =  ip_club))
	then leave sp_main; 
    end if;
    
	insert into worker values (ip_ID, ip_first_name, ip_last_name, ip_country, ip_ent_year,
    ip_salary, ip_club, FALSE, TRUE);
    insert into player values (ip_ID, ip_jersey_number, ip_position, ip_birthday, 0 , 0,
    ip_represent_Nation, ip_lead_club, ip_lead_country);
end //
delimiter ;

call add_player("POP", "Testing", "Here", "Memeland", 2022, 10, "RMD", 99, "Forward", '07/26/2022', "Spain", False, False);

remove_player
delimiter // 
create procedure remove_player (in ip_ID char(9))
sp_main: begin
	delete from worker where ID = ip_ID;
end //
delimiter ;

call remove_player("POP");

add_team
delimiter // 
create procedure add_team (in ip_ID char(9),
	in ip_name char(255),
	in ip_country char(255), in ip_captain char(255),
	in ip_world_rank decimal(2, 0), in ip_country_rank decimal(2.0))
sp_main: begin
	if (ip_ID in (select ID from team)) 
    then leave sp_main;
    end if;
    
    insert into team values (ip_ID, ip_name, ip_country, ip_captain);
    
	if ip_world_rank is null
	then insert into club_team values (ip_ID, ip_country_rank); 
    end if;
    
	if ip_country_rank is null
	then insert into national_team values (ip_ID, ip_world_rank);
    end if;
end //
delimiter ;

-- call add_team("POP", "GT Idiots 1", "USA", "John Doe", NULL, 1);
-- call add_team("BOB", "GT Idiots 2", "USA", "John Doe", 1, NULL);

club captain
delimiter // 
create procedure change_club_captain (in ip_club_ID char(9),
	in ip_captain char(255), in ip_captain_ID char(9))
sp_main: begin
	if (ip_club_ID not in (select ID from team)
		or (ip_captain_ID is NULL)
        or (ip_captain_ID not in (select p.id from player as p join worker as w on p.id = w.id where w.club = ip_club_ID))
        or (ip_captain not in (SELECT concat(f_name, " ", l_name) as player_name 
			FROM player as p join worker as w on p.id = w.id where p.id = ip_captain_ID))
        or (ip_captain_ID not in (select p.ID from player as p join worker as w on p.id = w.id
			where concat(f_name," ",l_name) = ip_captain))
        or (ip_captain in (select team.captain from club_team left join team on club_team.ID = team.ID)))
    then leave sp_main;
    end if;
    ##does this mean the club and national team cannot have the same captain?
    update team set captain = ip_captain where ID = ip_club_ID;
end //
delimiter ;

-- call change_club_captain("RMD", "John Doe", "POOP");

participate competitions
delimiter // 
create procedure participate_competitions (in ip_team_ID char(9),
	in ip_competition char(9))
sp_main: begin
	if (ip_team_ID not in (select ID from team)) then leave sp_main; end if;
    if (ip_competition not in (select ID from competition)) then leave sp_main; end if;
    if (ip_team_ID in (select teamID from participate where competition = ip_competition)) then leave sp_main; end if;
    if (ip_team_ID in (select ID from club_team) and ((select type from competition where ID = ip_competition) = 'National game')) 
    then leave sp_main; end if;
    if (ip_team_ID in (select ID from national_team) and ((select type from competition where ID = ip_competition) = 'Club game')) 
    then leave sp_main; end if;
	insert into participate values (ip_team_ID, ip_competition);
end //
delimiter ;

call participate_competitions("POP", "ec_21");
call participate_competitions("BOB", "wc_18");

sponsor competitions
delimiter // 
create procedure sponsor_competition (in ip_company_ID char(9),
	in ip_competition_ID char(9))
sp_main: begin
	if (ip_company_ID not in (select comp_ID from company)) then leave sp_main; end if;
    if (ip_competition_ID not in (select ID from competition)) then leave sp_main; end if;
    if (ip_company_ID in (select company_ID from sponsor_comp where competition = ip_competition_ID)) then leave sp_main; end if;
	insert into sponsor_comp values (ip_company_ID, ip_competition_ID);
end //
delimiter ;

delete_order
delimiter // 
create procedure delete_order (in ip_club_ID char(9), in ip_orderID decimal(4,0))
sp_main: begin
    delete from orders where orderID = ip_orderID and club = ip_club_ID;
end //
delimiter ;

call delete_order('RMD', 9999);

--  if (ip_club_ID not in (select ID from club_team)) then leave sp_main; end if;
--  if (ip_orderID not in (select orderID from orders)) then leave sp_main; end if;
--

-- display players who play for the national teams with world rank of top 10 in the platform
create or replace view national_players (player_ID, fname, lname) as
select player.ID, worker.f_name, worker.l_name from player 
left join worker on player.ID = worker.ID 
left join team on team.country = player.represent_Nation
left join national_team on national_team.ID = team.ID
where world_rank <= 10;

-- display players who scored more than 10 goals in all games of the season in the platform
create or replace view best_players (player_ID, fname, lname) as
select player.ID, worker.f_name, worker.l_name from player 
left join worker on player.ID = worker.ID
where num_goals > 10;

-- display the member’s information for all clubs that have a 1st rank in their country
create or replace view top_clubs (player_ID, fname, lname) as
select player.ID, worker.f_name, worker.l_name from player 
left join worker on player.ID = worker.ID 
left join club_team on club_team.ID = worker.club
where country_rank = 1;

-- display the club teams with coaches that served more than five years
create or replace view experienced_coaches (team_ID, team_name) as
select team.ID, team.name from coach
left join worker on worker.ID = coach.ID
left join team on team.ID = worker.club
where coach.num_years > 5;

-- display the name of companies which sponsors no player in the system
create or replace view company_sponsor (company_ID, company_name) as
select comp_ID, comp_name from company where endorse_player is null;
