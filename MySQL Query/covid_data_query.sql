-- create database
create database final_covid_data;
use final_covid_data;
-- craete temp table
drop table temp_table;
create table temp_table
(
submission_date varchar(20)
,code varchar(10)
,tot_cases int
,conf_cases float
,prob_cases float
,new_case int
,pnew_case float
,tot_death int
,conf_death float
,prob_death float
,new_death int
,consent_cases varchar(50)
,consent_deaths varchar(50)
,State varchar(50)
)
truncate temp_table;
select * from temp_table;
-- table states
create table states
(
state_id int not null auto_increment
,code varchar(10)
,State varchar(50)
,primary key (state_id)
)
-- create dim consent

create table consent
(
consent_id int not null auto_increment
,consent_cases varchar(50)
,consent_deaths varchar(50)
,primary key(consent_id)
)

-- create fact table


create table fact_table
(
fact_id int not null auto_increment
,submission_date varchar(20)
,tot_cases int
,conf_cases float
,prob_cases float
,new_case int
,pnew_case float
,tot_death int
,conf_death float
,prob_death float
,new_death int
,state_id int
,consent_id int
,primary key (fact_id)
,foreign key (state_id) references states (state_id) on delete set null
,foreign key (consent_id) references consent (consent_id) on delete set null
)
-- data in states
insert ignore into states (code, State)
SELECT DISTINCT code, State from temp_table
;
--data in consent

insert ignore into consent (consent_cases, consent_deaths)
SELECT DISTINCT consent_cases, consent_deaths from temp_table
;
select * from consent;

insert ignore into fact_table (submission_date, tot_cases, conf_cases, prob_cases, new_case, pnew_case, tot_death, conf_death, prob_death, new_death, state_id, consent_id)
SELECT DISTINCT 
t.submission_date
,t.tot_cases
,t.conf_cases
,t.prob_cases
,t.new_case
,t.pnew_case
,t.tot_death
,t.conf_death
,t.prob_death
,t.new_death 
,s.state_id 
,c.consent_id
from temp_table t
join states s on s.code = t.code
join consent c on c.consent_cases = t.consent_cases
;