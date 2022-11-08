-- CS4400: Introduction to Database Systems (Summer 2022)
-- Phase II: Create Table & Insert Statements [v0] Sunday, June 23, 2022 @ 1:04am EDT
-- Team 7
-- Thi Tran (Ttran372)
-- Taleb Hirani (Thirani7)
-- Simon Abrelat (Sabrelat3)
-- Chuandong Liu (Cliu702)
-- Directions:
-- Please follow all instructions for Phase II as listed on Canvas.
-- Fill in the team number and names and GT usernames for all members above.
-- Create Table statements must be manually written, not taken from an SQL Dump file.
-- This file must run without error for credit.
-- ------------------------------------------------------
-- CREATE TABLE STATEMENTS AND INSERT STATEMENTS BELOW
-- ------------------------------------------------------


DROP DATABASE IF EXISTS football;
CREATE DATABASE IF NOT EXISTS football;
USE football;

-- Table structure for table employee
-- Team = (id, name, country, captain, captain_id[fk13])
-- fk13: captain_id => player.id, captain_id is not null
DROP TABLE IF EXISTS team;
CREATE TABLE team (
    id char(9) NOT NULL,
    team_name varchar(100) NOT NULL,
    country char(30) NOT NULL,
    captain varchar(100) NOT NULL,
    PRIMARY KEY (id)
);
INSERT INTO team values ('RMD','Real Madrid CF','Spain','Karim Benzema'),
						('MCF','Manchester City F.C.','United Kingdom','Fernando Luiz Roza'),
						('BEL','Belgium national football team','Belgium','Eden Hazard'),
						('CRO','Croatia National Football Team ','Croatia','Luka Modric');

DROP TABLE IF EXISTS club;
CREATE TABLE club (
    club_id char(9) NOT NULL,
    country_rank integer NOT NULL,
    coach varchar(100) NOT NULL,
    PRIMARY KEY (club_id),
    CONSTRAINT fk3 FOREIGN KEY (club_id) REFERENCES team (id)
);
INSERT INTO club values ('RMD',1,'Carlo Ancelotti'),
						('MCF',1,'Pep Guardiola');
                        
-- National = (id [fk4], world_rank)
-- fk4: id -> Team.id, id is not null
DROP TABLE IF EXISTS national;
CREATE TABLE national (
    national_id char(9) NOT NULL,
    world_rank integer NOT NULL,
    PRIMARY KEY (national_id),
    CONSTRAINT fk4 FOREIGN KEY (national_id) REFERENCES team (id)
);

INSERT INTO national values ('BEL',2),('CRO',15);

--  Worker = (worker_id, fname, lname, estimated_salary, employer_id[fk11], country, entered_year)
--  fk[11]: employer_id => Club.id, employer_id is not null
DROP TABLE IF EXISTS worker;
CREATE TABLE worker (
    worker_id char(9) NOT NULL,
    fname varchar(100) NOT NULL,
    lname varchar(100) NOT NULL,
    estimated_salary integer NOT NULL,
    employer_id char(9) NOT NULL,
    country char(30) NOT NULL,
    entered_year integer NOT NULL,
    PRIMARY KEY (worker_id),
    CONSTRAINT fk11 FOREIGN KEY (employer_id) REFERENCES club (club_id)
);

INSERT INTO worker values ('LM360','Luka','Modric',325,'RMD','Croatia',2012),
							('TC361','Thibaut','Courtois',300,'RMD','Belgium',2018),
							('KB367','Karim','Benzema',276,'RMD','France',2009),
							('KD415','Kevin','De Bruyne',390,'MCF','Belgium',2015),
							('EH370','EdenHazard','Hazard',430,'RMD','Belgium',2019),
							('AP407','Ante','Palaversa',18,'MCF','Croatia',2019),
							('PG140','Pep','Guardiola',385,'MCF','Spain',2016),
							('CA130','Carlo','Ancelotti',355,'RMD','Italy',2021);


-- Coach = (worker_id [fk1], license_id, num_years)
-- fk1: worker_id -> Worker.worker_id, worker_id is non-null
DROP TABLE IF EXISTS coach;
CREATE TABLE coach (
    worker_id char(9) NOT NULL,
    license_id char(11),
    PRIMARY KEY (worker_id),
    CONSTRAINT fk1 FOREIGN KEY (worker_id) REFERENCES worker (worker_id),
    CHECK (license_id like "___-___-___")
);

INSERT INTO coach values ('PG140','303-549-882'),('CA130','303-600-411');

-- Player = (worker_id [fk2], position, jersey_number, num_assist, num_goals, bithday, represent_country
-- fk2: worker_id -> Team.id, worker_id is non-nul;
DROP TABLE IF EXISTS player;
CREATE TABLE player (
    worker_id char(9) NOT NULL,
    position varchar(30) NOT NULL,
    jersey_number integer NOT NULL,
    num_assist integer NOT NULL,
    num_goals integer NOT NULL,
    birthday date NOT NULL,
    represent_country bool NOT NULL,
    PRIMARY KEY (worker_id),
    CONSTRAINT fk2 FOREIGN KEY (worker_id) references worker (worker_id)
);

INSERT INTO player values ('LM360', 'Midfielder', 10, 12, 2, '1985-09-09', TRUE),
							('TC361', 'Goal-keeper', 1, 0, 0, '1992-05-11', TRUE),
                            ('KB367', 'Forward', 9, 12, 27, '1987-12-19', TRUE),
                            ('KD415', 'Midfielder', 17, 8, 15, '1991-06-28', TRUE),
                            ('EH370', 'Forward', 7, 1, 2, '1991-01-07', TRUE),
                            ('AP407', 'Midfielder', 8, 4, 2, '2000-04-06', FALSE);
                            
##('KB367', 'Forward', 9, 12, 27, '1987-12-19', 'FR')

-- Competition = (comp_id, type, event, year)
DROP TABLE IF EXISTS competition;
CREATE TABLE competition (
    competition_id char(9) NOT NULL,
    competition_type varchar(100) NOT NULL,
    competition_event varchar(100) NOT NULL,
    competition_year YEAR NOT NULL,
    PRIMARY KEY (competition_id)
);

INSERT INTO competition values ('wc_18', 'National game', 'World Cup', '2018'),
								('ec_21', 'Club game', 'UEFA European Championship ', '2021');

-- Order = (placed_by_id [fk5], selector_id [fk12], order_number, item_name, num_item, price_item)
-- fk5: placed_by_id -> Club.id, placed_by_id is not null
-- fk12: selector_id => Worker.id, selector_id is not null
DROP TABLE IF EXISTS buy_order;
CREATE TABLE buy_order (
    placed_by_id char(9) NOT NULL,
    selector_id char(9) NOT NULL,
    order_number integer NOT NULL,
    item_name varchar(100) NOT NULL,
    item_number integer NOT NULL,
    item_price integer NOT NULL,
    KEY (placed_by_id, selector_id, order_number, item_name),
    CONSTRAINT fk5 FOREIGN KEY (placed_by_id) references club (club_id),
    CONSTRAINT fk12 FOREIGN KEY (selector_id) references worker (worker_id)
);

INSERT INTO buy_order values ('RMD', 'CA130', 2316, 'Football', 30, 100),
								('RMD', 'CA130', 2316, 'Shoes', 25, 230),
                                ('RMD', 'CA130', 4400, 'Training poles', 2, 300);

-- Participate = (comp_id [fk9], team_id[fk10])
-- fk9: comp_id => Competition.comp_id, comp_id is not null
-- fk10: team_id => Team.id
DROP TABLE IF EXISTS participate;
CREATE TABLE participate (
    competition_id char(9) NOT NULL,
    team_id char(9) NOT NULL,
    PRIMARY KEY (competition_id, team_id),
    CONSTRAINT fk9 FOREIGN KEY (competition_id) REFERENCES competition (competition_id),
    CONSTRAINT fk10 FOREIGN KEY (team_id) REFERENCES team (id)
);

INSERT INTO participate values ('wc_18', 'BEL'),
								('wc_18', 'CRO'),
								('ec_21', 'RMD'),
								('ec_21', 'MCF');

-- Company = (co_id, name, address, e_id [fk6])
-- fk6: endorse_player -> Player.worker_id
DROP TABLE IF EXISTS company;
CREATE TABLE company (
    company_id char(9) NOT NULL,
    company_name varchar(100) NOT NULL,
    company_address varchar(255) NOT NULL,
    endose_id char(9),
    PRIMARY KEY (company_id),
    CONSTRAINT fk6 FOREIGN KEY (endose_id) REFERENCES player (worker_id)
);

INSERT INTO company values ('NK02', 'Nike', 'One Bowerman Dr, Beaverton, OR 97005, United States', 'TC361'),
							('CC03', 'Coca-Cola', '1 Coca Cola Plz NW, Atlanta, GA 30313, United States', 'EH370');

-- Sponsor = (comp_id [fk7], co_id[fk8])
-- fk7: comp_id => Competition.comp_id
-- fk8: co_id => Company.co_id
DROP TABLE IF EXISTS sponsor;
CREATE TABLE sponsor (
    company_id char(9) NOT NULL,
    competition_id char(9) NOT NULL,
    PRIMARY KEY (company_id, competition_id),
    CONSTRAINT fk7 FOREIGN KEY (competition_id) REFERENCES competition (competition_id),
    CONSTRAINT fk8 FOREIGN KEY (company_id) REFERENCES company (company_id)
);

INSERT INTO sponsor values ('NK02', 'wc_18'),
							('CC03', 'wc_18'),
							('NK02', 'ec_21');


