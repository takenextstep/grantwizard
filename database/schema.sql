DROP TABLE IF EXISTS Scheme CASCADE;

CREATE TABLE Scheme (
	id int NOT NULL primary key,
	name text,
	description text
);

CREATE INDEX ON Scheme(id);

DROP TABLE IF EXISTS AmountType CASCADE;

CREATE TABLE AmountType (
	id int NOT NULL primary key,
	name text
);

CREATE INDEX ON AmountType(id);

DROP TABLE IF EXISTS SubScheme CASCADE;

CREATE TABLE SubScheme (
	id int NOT NULL primary key,
	name text,
	description text,
	website text,
	amount int,
	amount_type int references AmountType(id),
	duration int,
	parent_scheme_id int references Scheme(id)
);

CREATE INDEX ON SubScheme(id);

DROP TABLE IF EXISTS QuestionType CASCADE;

CREATE TABLE QuestionType (
	id int NOT NULL primary key,
	name text
);

CREATE INDEX ON QuestionType(id);

DROP TABLE IF EXISTS Validation CASCADE;

CREATE TABLE Validation (
	id int NOT NULL primary key,
	name text
);

CREATE INDEX ON Validation(id);


DROP TABLE IF EXISTS Rule CASCADE;

CREATE TABLE Rule (
	id int NOT NULL primary key,
	name text
);

CREATE INDEX ON Rule(id);

DROP TABLE IF EXISTS EligibilityQuestion CASCADE;

CREATE TABLE EligibilityQuestion (
	id int NOT NULL primary key,
	name text,
	question text,
	question_type_id int references QuestionType(id)
);

CREATE INDEX ON EligibilityQuestion(id);

DROP TABLE IF EXISTS EligibilitySet CASCADE;

CREATE TABLE EligibilitySet (
	id int NOT NULL primary key,
	scheme_id int references Scheme(id),
	subscheme_id int references SubScheme(id)
);

CREATE INDEX ON EligibilitySet(id);

DROP TABLE IF EXISTS EligibilityRequirement CASCADE;

CREATE TABLE EligibilityRequirement (
	id int NOT NULL primary key,
	eligibility_set_id int references EligibilitySet(id),
	eligibility_question_id int references EligibilityQuestion(id),
	value text,
	rule_id int references Rule(id),
	validation_id int references Validation(id)
);

CREATE INDEX ON EligibilityRequirement(id);


INSERT INTO QuestionType(id, name) VALUES (1, 'plain text');
INSERT INTO QuestionType(id, name) VALUES (2, 'multiple choice');

INSERT INTO AmountType(id, name) VALUES (301, 'one-off');
INSERT INTO AmountType(id, name) VALUES (302, 'monthly');
INSERT INTO AmountType(id, name) VALUES (303, 'yearly');

INSERT INTO EligibilityQuestion(id, name, question, question_type_id) VALUES (4001, 'Residency', 'Have you been a Hong Kong resident for the past 12 months?', 1);
INSERT INTO EligibilityQuestion(id, name, question, question_type_id) VALUES (4002, 'Profession', 'Are you employed in any of the following professions?', 2);
INSERT INTO EligibilityQuestion(id, name, question, question_type_id) VALUES (4003, 'Accredited Tour Guide or Tour Escort', 
	'Are you a freelance accredited tourist guide/tour escort whose main occupation is tourist guide/tour escort who is:
	holding a valid Tourist Guide Pass/Tour Escort Pass issued by TIC on 31 December 2019 AND have
	(a) provided tourist guide/tour escort service for the inbound/outbound tours organised by one or more travel agent(s) for at least 60 days during the period from 1 July 2018 to 31 December 2019; 
	or
	(b) provided tourist guide/tour escort service for the inbound/outbound tours organised by one or more travel agent(s) for at least 20 days per month for at least two months during the period from 1 July 2018 to 31 December 2019?', 1);
INSERT INTO EligibilityQuestion(id, name, question, question_type_id) VALUES (4004, 'Eligible Tour Service Coach Driver', 
	'Are you a tour service coach driver who is currently:
	(a) holding a valid full driving licence for public bus anytime during the period from 1 January 2019 to 8 April 2020; 
	and
	(b) having provided driving service on a non-franchised public bus that provided tour service (A01) and/or international passenger service (A05) (collectively referred to as “tour service” thereafter) for a non-franchised public bus service operator with a then valid Passenger Service Licence anytime during the period above.', 1);
INSERT INTO EligibilityQuestion(id, name, question, question_type_id) VALUES (4005, 'Number of Household Members', 'How many members do you have in your household?', 1);
INSERT INTO EligibilityQuestion(id, name, question, question_type_id) VALUES (4006, 'Children in household', 'Do you have a child/children aged below 15, or aged between 15 and 21 in your household receiving full-time education (but not post-secondary education).?', 1);
INSERT INTO EligibilityQuestion(id, name, question, question_type_id) VALUES (4007, 'Monthly Income', '
What is the total monthly income of your household?
Household income includes:
wages (deducting employees’ mandatory contribution to Mandatory Provident Fund Schemes);
fees received for services rendered;
profits from business;
rental income, etc.; and
the following assistance provided by the Government:
allowances received by household members from the individual-based Work Incentive Transport Subsidy (I-WITS)
allowances received under the Pilot Scheme on Living Allowance for Carers of Elderly Persons from Low-income Families
allowances received under the Pilot Scheme on Living Allowance for Low-income Carers of Persons with Disabilities
', 1);
INSERT INTO EligibilityQuestion(id, name, question, question_type_id) VALUES (4008, 'Total Asset Value', '
What is the estimated total value of your household assets?
Household assets include:
land;
landed properties (excluding self-occupied properties);
vehicles/vessels;
taxi/public light bus licences;
investments;
shares/business undertakings; and
bank deposits/cash, etc.', 1);
INSERT INTO EligibilityQuestion(id, name, question, question_type_id) VALUES (4009, 'Total Working Hours', '
What is the estimated total number of hours your household works a month?
Working hours include:
Hours of paid work performed by the applicant and other working members of the household (employed or self-employed).
Hours derived from paid holidays and absence such as sick leave and maternity leave.', 1);
INSERT INTO EligibilityQuestion(id, name, question, question_type_id) VALUES (4010, 'Number of Household Members', 'How many members do you have in your household*?
*A household generally refers to a unit with persons having close economic ties and living on the same premises.
', 1);
INSERT INTO EligibilityQuestion(id, name, question, question_type_id) VALUES (4011, 'Single-parent household', 'Are you in a single parent household? The single parent has to live with at least one child aged below 15', 1);

INSERT INTO Scheme(id, name, description) VALUES (1001, 'Anti-epidemic Fund', 'COVID-19 special fund to help businesses stay afloat, to keep workers in employment, to relieve financial burdens of individuals and businesses, and to assist the economy to recover once the epidemic is contained.');
INSERT INTO EligibilitySet(id, scheme_id) VALUES (8001, 1001);
INSERT INTO EligibilityRequirement(id, eligibility_set_id, eligibility_question_id, value) VALUES (5001, 8001, 4001, 'yes');

INSERT INTO SubScheme(id, name, description, website, amount, amount_type, duration, parent_scheme_id) VALUES (2001, 'Travel Agents and Practitioners Support Scheme - Travel Agent', 'Travel agent''s staff each receive a subsidy equivalent to $5,000 monthly for six months. Each subsidy will be disbursed in two tranches', 'https://www.tourism.gov.hk/english/anti_epidemic_fund/travel_agents.html', 5000, 302, 6, 1001);
INSERT INTO EligibilitySet(id, subscheme_id) VALUES (8002, 2001);
INSERT INTO EligibilityRequirement(id, eligibility_set_id, eligibility_question_id, value) VALUES (6001, 8002, 4002, 'Travel Agent');

INSERT INTO SubScheme(id, name, description, website, amount, amount_type, duration, parent_scheme_id) VALUES (2002, 'Travel Agents and Practitioners Support Scheme - Tour Guides and Tour Escorts Support Scheme', 'Freelance accredited tourist guides and tour escorts whose main occupations are tourist guides and tour escorts each receive a subsidy equivalent to $5,000 monthly for six months. Each subsidy will be disbursed in two tranches', 'https://www.tourism.gov.hk/english/anti_epidemic_fund/tourist_guide_escort.html', 5000, 302, 6, 1001);
INSERT INTO EligibilitySet(id, subscheme_id) VALUES (8003, 2002);
INSERT INTO EligibilityRequirement(id, eligibility_set_id, eligibility_question_id, value, subscheme_id) VALUES (6002, 8003, 4002, 'Tour Guide and/or Tour Escort');
INSERT INTO EligibilityRequirement(id, eligibility_set_id, eligibility_question_id, value, subscheme_id) VALUES (6003, 8003, 4003, 'yes');

INSERT INTO SubScheme(id, name, description, website, amount, amount_type, duration, parent_scheme_id) VALUES (2003, 'Travel Agents and Practitioners Support Scheme - Tour Guides and Tour Escorts Support Scheme', 'The Tour Service Coach Drivers Support Scheme aims to provide a one-off subsidy of $10,000 to tour service coach drivers each.', 'https://www.tourism.gov.hk/english/anti_epidemic_fund/drivers.html', 10000, 301, 1, 1001);
INSERT INTO EligibilitySet(id, subscheme_id) VALUES (8004, 2003);
INSERT INTO EligibilityRequirement(id, eligibility_set_id, eligibility_question_id, value, subscheme_id) VALUES (6004, 8004, 4002, 'Tour Guide and/or Tour Escort');
INSERT INTO EligibilityRequirement(id, eligibility_set_id, eligibility_question_id, value, subscheme_id) VALUES (6005, 8004, 4004, 'yes');

INSERT INTO Scheme(id, name, description) VALUES (1002, 'Working Family Allowance Scheme', 'Under the WFA Scheme, a household (including one-person household) who meets the working hours requirement, and income and asset limits may apply for Basic (full-rate: $800; ¾ rate: $600; half-rate: $400), Medium (full-rate: $1000; ¾ rate: $750; half-rate: $500) or Higher (Full-rate: $1200, ¾ rate: $900; half-rate: $600) Allowance.  Each eligible child (aged below 15, or aged between 15 and 21 receiving full-time non-post-secondary education) may also apply for a Child Allowance (full-rate: $1000; ¾ rate: $750; half-rate: $500).');
INSERT INTO EligibilitySet(id, scheme_id) VALUES (8005, 1002);
INSERT INTO EligibilityRequirement(id, eligibility_set_id, eligibility_question_id, value) VALUES (5001, 8005, 4001, 'yes');

INSERT INTO SubScheme(id, name, description, website, amount, amount_type, duration, parent_scheme_id) VALUES (2004, 'Single-parent Household Full-rate, 36 to less than 54
work hours', '', 'https://www.wfsfaa.gov.hk/wfao/en/index.htm', 800, 302, 'ongoing', 1002);

INSERT INTO SubScheme(id, name, description, website, amount, amount_type, duration, parent_scheme_id) VALUES (2005, 'Single-parent Household 3/4-rate, 36 to less than 54
work hours', '', 'https://www.wfsfaa.gov.hk/wfao/en/index.htm', 600, 302, 'ongoing', 1002);

INSERT INTO SubScheme(id, name, description, website, amount, amount_type, duration, parent_scheme_id) VALUES (2006, 'Single-parent Household Half-rate, 36 to less than 54
work hours', '', 'https://www.wfsfaa.gov.hk/wfao/en/index.htm', 400, 302, 'ongoing', 1002);

INSERT INTO SubScheme(id, name, description, website, amount, amount_type, duration, parent_scheme_id) VALUES (2007, 'Non-single-parent Household Full-rate, 144 to less than 168 work hours', '', 'https://www.wfsfaa.gov.hk/wfao/en/index.htm', 800, 302, 'ongoing', 1002);

INSERT INTO SubScheme(id, name, description, website, amount, amount_type, duration, parent_scheme_id) VALUES (2008, 'Non-single-parent Household 3/4-rate, 144 to less than 168 work hours', '', 'https://www.wfsfaa.gov.hk/wfao/en/index.htm', 600, 302, 'ongoing', 1002);

INSERT INTO SubScheme(id, name, description, website, amount, amount_type, duration, parent_scheme_id) VALUES (2009, 'Non-single-parent Household Half-rate, 144 to less than 168 work hours', '', 'https://www.wfsfaa.gov.hk/wfao/en/index.htm', 400, 302, 'ongoing', 1002);
