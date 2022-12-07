-- # -------- CREATE DATABASE ------------
CREATE DATABASE database1;

-- # -------- CREATE USER ------------
GRANT ALL PRIVILEGES ON database1.* TO 'webapp'@'%';
FLUSH PRIVILEGES;

USE database1;

-- # -------- CREATE TABLES ------------

create table PokerTable (
	tableId INT PRIMARY KEY AUTO_INCREMENT NOT NULL ,
	maxSeats INT,
	minimumBet VARCHAR(4) CHECK ( minimumBet >=0 )
);

create table Player (
	playerId INT PRIMARY KEY AUTO_INCREMENT NOT NULL ,
	firstName VARCHAR(50),
	lastName VARCHAR(50),
	ssn VARCHAR(50) UNIQUE ,
	email VARCHAR(50),
	phoneNumber VARCHAR(50),
	netWorth INT,
	numDependents INT CHECK ( numDependents >= 0 ),
	frustrationLevel INT CHECK ( frustrationLevel >=0 AND frustrationLevel <= 10),
	tableId INT,
	FOREIGN KEY (tableId) REFERENCES PokerTable(tableId)
);


create table Admin (
	adminId INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
	firstName VARCHAR(50),
	lastName VARCHAR(50),
	phoneNumber VARCHAR(50),
	email VARCHAR(50),
	deviousness INT CHECK ( deviousness >=0 AND deviousness <= 10),
	role VARCHAR(16) CHECK ( role in ('Regional Manager', 'General Manager', 'Junior Manager') )
);

create table Slots (
	slotId INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
	costToPlay VARCHAR(3) CHECK ( costToPlay >= 0 ),
	rigScore DECIMAL(3,2) CHECK ( rigScore >= 0 AND rigScore <= 1 ),
	winAmount INT CHECK ( winAmount >= 0 ),
	playerId INT,
	FOREIGN KEY (playerId) REFERENCES Player(playerId)
);

create table AdminSlotsBridge (
	adminId INT,
	slotsId INT,
	PRIMARY KEY (adminId, slotsId),
	FOREIGN KEY (adminId) REFERENCES Admin(adminId),
	FOREIGN KEY  (slotsId) REFERENCES Slots(slotId)
);

create table AdminTableBridge (
	tableId INT,
	adminId INT,
	PRIMARY KEY (tableId, adminId),
	FOREIGN KEY (tableId) REFERENCES PokerTable(tableId),
	FOREIGN KEY (adminId) REFERENCES Admin(adminId)
);

create table Dealer (
	dealerId INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
	firstName VARCHAR(50),
	lastName VARCHAR(50),
	friendliness INT CHECK ( friendliness >= 0 AND friendliness <= 10 ),
	corruptness INT CHECK ( corruptness >= 0 AND corruptness <= 10 ),
	scumminess INT CHECK ( scumminess >= 0 AND scumminess <= 10 ),
	tableId INT,
	FOREIGN KEY (tableId) REFERENCES PokerTable(tableId)
);

create table Drink (
	drinkId INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
	name VARCHAR(50),
	alcoholContent DECIMAL(3,2) CHECK ( alcoholContent >= 0 AND alcoholContent <= 1 )
);


create table Address (
	addressId INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
	street VARCHAR(50),
	city VARCHAR(50),
	state VARCHAR(50),
	country VARCHAR(50),
	zip VARCHAR(50),
	playerId INT,
	FOREIGN KEY (playerId) REFERENCES Player(playerId)

);

create table PlayerDrinkBridge (
	drinkId INT,
	playerId INT,
	PRIMARY KEY (drinkId, playerId),
	FOREIGN KEY (drinkId) REFERENCES Drink(drinkId),
	FOREIGN KEY (playerId) REFERENCES Player(playerId)
);

create table Portfolio (
	portfolioId INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
	num_1 INT CHECK ( num_1 >= 0 ),
	num_5 INT CHECK ( num_5 >= 0 ),
	num_10 INT CHECK ( num_10 >= 0 ),
	num_25 INT CHECK ( num_25 >= 0 ),
	num_100 INT CHECK ( num_100 >= 0 ),
	total_chips_value DECIMAL(10,2),
	playerId INT,
	FOREIGN KEY (playerId) REFERENCES Player(playerId)
);



create table SlotsHistory (
	slotsHistoryId INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
	timeOfPlay DATETIME,
	# positive if win, negative if loss
	winLoss INT
);

create table SlotsHistoryBridge (
	slotId INT,
	slotsHistoryId INT,
	PRIMARY KEY (slotId, slotsHistoryId),
	FOREIGN KEY (slotId) REFERENCES Slots(slotId),
	FOREIGN KEY (slotsHistoryId) REFERENCES SlotsHistory(slotsHistoryId)
);



create table TableHistory (
	tableHistoryId INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
	timeOfPlay DATETIME,
	# positive if win, negative if loss
	winLossAmt INT,
	tableId INT,
	FOREIGN KEY (tableId) REFERENCES PokerTable(tableId)
);

create table TableHistoryBridge (
	tableId INT,
	tableHistoryId INT,
	PRIMARY KEY (tableId, tableHistoryId),
	FOREIGN KEY (tableId) REFERENCES PokerTable(tableId),
	FOREIGN KEY (tableHistoryId) REFERENCES TableHistory(tableHistoryId)
);

create table Transactions (
	transactionId INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
	timeOfTransaction DATETIME,
	amount INT,
	type VARCHAR(10),
	playerId INT,
	FOREIGN KEY (playerId) REFERENCES Player(playerId)
);

-- # -------- ADD SAMPLE DATA ------------
insert into PokerTable (maxSeats, minimumBet) values (1, 1000);
insert into PokerTable (maxSeats, minimumBet) values (4, 10);
insert into PokerTable (maxSeats, minimumBet) values (1, 100);
insert into PokerTable (maxSeats, minimumBet) values (4, 10);
insert into PokerTable (maxSeats, minimumBet) values (3, 100);
insert into PokerTable (maxSeats, minimumBet) values (9, 10);
insert into PokerTable (maxSeats, minimumBet) values (4, 10);
insert into PokerTable (maxSeats, minimumBet) values (3, 1000);
insert into PokerTable (maxSeats, minimumBet) values (4, 50);
insert into PokerTable (maxSeats, minimumBet) values (3, 1000);

insert into Player (firstName, lastName, ssn, email, phoneNumber, netWorth, numDependents, frustrationLevel, tableId) values ('Valeria', 'Guido', '153-76-2335', 'vguido0@yale.edu', '866-159-7736', 2099488, 0, 4, '5');
insert into Player (firstName, lastName, ssn, email, phoneNumber, netWorth, numDependents, frustrationLevel, tableId) values ('Georg', 'Weald', '373-10-6522', 'gweald1@cyberchimps.com', '277-606-6451', 3416243, 5, 10, '10');
insert into Player (firstName, lastName, ssn, email, phoneNumber, netWorth, numDependents, frustrationLevel, tableId) values ('Daisie', 'Jerrard', '655-82-8456', 'djerrard2@google.co.uk', '305-948-9857', 4231218, 1, 7, '2');
insert into Player (firstName, lastName, ssn, email, phoneNumber, netWorth, numDependents, frustrationLevel, tableId) values ('Constancia', 'Fullman', '557-53-4336', 'cfullman3@gnu.org', '803-990-3329', 2555817, 2, 8, '4');
insert into Player (firstName, lastName, ssn, email, phoneNumber, netWorth, numDependents, frustrationLevel, tableId) values ('Lukas', 'Felkin', '586-67-0968', 'lfelkin4@goo.gl', '205-847-2310', 1244171, 5, 6, '7');
insert into Player (firstName, lastName, ssn, email, phoneNumber, netWorth, numDependents, frustrationLevel, tableId) values ('Sherlocke', 'Ingledow', '769-99-6689', 'singledow5@wikimedia.org', '635-411-5758', 4370928, 0, 1, '1');
insert into Player (firstName, lastName, ssn, email, phoneNumber, netWorth, numDependents, frustrationLevel, tableId) values ('Fredia', 'Madigan', '340-25-8527', 'fmadigan6@wisc.edu', '401-996-5609', 4291382, 6, 6, '3');
insert into Player (firstName, lastName, ssn, email, phoneNumber, netWorth, numDependents, frustrationLevel, tableId) values ('Felicity', 'Kubis', '359-55-1835', 'fkubis7@cnet.com', '683-615-6930', 1255721, 0, 10, '9');
insert into Player (firstName, lastName, ssn, email, phoneNumber, netWorth, numDependents, frustrationLevel, tableId) values ('Bird', 'Rawlison', '655-64-5436', 'brawlison8@whitehouse.gov', '458-727-7094', 3257475, 3, 5, '6');
insert into Player (firstName, lastName, ssn, email, phoneNumber, netWorth, numDependents, frustrationLevel, tableId) values ('Ferris', 'Vinson', '777-60-3649', 'fvinson9@canalblog.com', '245-487-1185', 1933580, 0, 2, '8');
insert into Player (firstName, lastName, ssn, email, phoneNumber, netWorth, numDependents, frustrationLevel, tableId) values ('Lanae', 'Freire', '116-14-9004', 'lfreirea@multiply.com', '406-299-2892', 488471, 6, 1, '10');
insert into Player (firstName, lastName, ssn, email, phoneNumber, netWorth, numDependents, frustrationLevel, tableId) values ('Giles', 'Ritmeyer', '199-57-5405', 'gritmeyerb@msu.edu', '639-243-6109', 397813, 1, 3, '2');
insert into Player (firstName, lastName, ssn, email, phoneNumber, netWorth, numDependents, frustrationLevel, tableId) values ('Shepperd', 'Le Quesne', '584-88-9790', 'slequesnec@sourceforge.net', '941-988-0657', 4398843, 4, 1, '3');
insert into Player (firstName, lastName, ssn, email, phoneNumber, netWorth, numDependents, frustrationLevel, tableId) values ('Neall', 'Raybould', '216-40-3371', 'nraybouldd@fotki.com', '559-224-5181', 1972742, 4, 8, '5');
insert into Player (firstName, lastName, ssn, email, phoneNumber, netWorth, numDependents, frustrationLevel, tableId) values ('Traver', 'Smowton', '784-38-6998', 'tsmowtone@blogspot.com', '948-482-6377', 4107695, 0, 0, '9');
insert into Player (firstName, lastName, ssn, email, phoneNumber, netWorth, numDependents, frustrationLevel, tableId) values ('Stu', 'Buckleigh', '453-27-7307', 'sbuckleighf@who.int', '416-733-4851', 4259207, 6, 6, '4');
insert into Player (firstName, lastName, ssn, email, phoneNumber, netWorth, numDependents, frustrationLevel, tableId) values ('Geordie', 'Rollins', '643-77-2211', 'grollinsg@paginegialle.it', '749-173-8477', 3861378, 5, 3, '6');
insert into Player (firstName, lastName, ssn, email, phoneNumber, netWorth, numDependents, frustrationLevel, tableId) values ('Dorette', 'Jimeno', '799-52-2494', 'djimenoh@va.gov', '718-739-5149', 4576900, 4, 4, '1');
insert into Player (firstName, lastName, ssn, email, phoneNumber, netWorth, numDependents, frustrationLevel, tableId) values ('Galvan', 'Havill', '474-03-6006', 'ghavilli@newsvine.com', '846-994-6124', 1538135, 1, 8, '8');
insert into Player (firstName, lastName, ssn, email, phoneNumber, netWorth, numDependents, frustrationLevel, tableId) values ('Obadias', 'Cutmare', '601-38-6532', 'ocutmarej@hao123.com', '607-759-7101', 2858180, 6, 4, '7');
insert into Player (firstName, lastName, ssn, email, phoneNumber, netWorth, numDependents, frustrationLevel, tableId) values ('L;urette', 'Pyatt', '359-49-1321', 'lpyattk@photobucket.com', '408-277-5496', 3309321, 4, 4, '2');
insert into Player (firstName, lastName, ssn, email, phoneNumber, netWorth, numDependents, frustrationLevel, tableId) values ('Neron', 'Goodfield', '681-16-5622', 'ngoodfieldl@etsy.com', '977-724-2836', 4298046, 1, 3, '9');
insert into Player (firstName, lastName, ssn, email, phoneNumber, netWorth, numDependents, frustrationLevel, tableId) values ('Cecily', 'Engall', '713-33-0199', 'cengallm@odnoklassniki.ru', '236-157-7623', 279314, 2, 7, '10');
insert into Player (firstName, lastName, ssn, email, phoneNumber, netWorth, numDependents, frustrationLevel, tableId) values ('Lynnea', 'Jailler', '374-88-9093', 'ljaillern@answers.com', '977-630-4880', 456528, 0, 7, '1');
insert into Player (firstName, lastName, ssn, email, phoneNumber, netWorth, numDependents, frustrationLevel, tableId) values ('Alyson', 'Menlow', '791-45-8495', 'amenlowo@guardian.co.uk', '659-927-3273', 4625678, 1, 10, '4');
insert into Player (firstName, lastName, ssn, email, phoneNumber, netWorth, numDependents, frustrationLevel, tableId) values ('Udell', 'Gerge', '185-05-7502', 'ugergep@google.de', '381-564-6658', 471224, 2, 0, '7');
insert into Player (firstName, lastName, ssn, email, phoneNumber, netWorth, numDependents, frustrationLevel, tableId) values ('Romain', 'Penkethman', '212-12-7321', 'rpenkethmanq@vistaprint.com', '372-689-1342', 2917474, 1, 6, '8');
insert into Player (firstName, lastName, ssn, email, phoneNumber, netWorth, numDependents, frustrationLevel, tableId) values ('Shae', 'Luby', '591-67-5957', 'slubyr@wisc.edu', '869-320-3942', 2530514, 0, 8, '3');
insert into Player (firstName, lastName, ssn, email, phoneNumber, netWorth, numDependents, frustrationLevel, tableId) values ('Donnajean', 'Davidovits', '164-08-3830', 'ddavidovitss@hhs.gov', '344-289-0045', 2305991, 3, 5, '6');
insert into Player (firstName, lastName, ssn, email, phoneNumber, netWorth, numDependents, frustrationLevel, tableId) values ('Dynah', 'Blague', '606-58-1587', 'dblaguet@icq.com', '355-163-9596', 495509, 0, 2, '5');
insert into Player (firstName, lastName, ssn, email, phoneNumber, netWorth, numDependents, frustrationLevel, tableId) values ('Oralle', 'Maccraw', '122-25-0080', 'omaccrawu@google.co.uk', '603-864-7295', 328687, 5, 6, '3');
insert into Player (firstName, lastName, ssn, email, phoneNumber, netWorth, numDependents, frustrationLevel, tableId) values ('Claiborn', 'Bodemeaid', '758-21-2430', 'cbodemeaidv@cdbaby.com', '280-899-4611', 312698, 6, 6, '1');
insert into Player (firstName, lastName, ssn, email, phoneNumber, netWorth, numDependents, frustrationLevel, tableId) values ('Gigi', 'Prodrick', '699-33-5899', 'gprodrickw@chron.com', '418-272-5552', 832417, 1, 6, '4');
insert into Player (firstName, lastName, ssn, email, phoneNumber, netWorth, numDependents, frustrationLevel, tableId) values ('Goldia', 'Diprose', '569-17-5790', 'gdiprosex@apache.org', '868-861-0922', 183522, 3, 6, '9');
insert into Player (firstName, lastName, ssn, email, phoneNumber, netWorth, numDependents, frustrationLevel, tableId) values ('Layney', 'Newe', '631-86-5356', 'lnewey@ask.com', '588-799-1362', 2330297, 0, 2, '7');
insert into Player (firstName, lastName, ssn, email, phoneNumber, netWorth, numDependents, frustrationLevel, tableId) values ('Winona', 'Barnfield', '677-57-1778', 'wbarnfieldz@cnn.com', '397-692-0165', 1780900, 6, 6, '6');
insert into Player (firstName, lastName, ssn, email, phoneNumber, netWorth, numDependents, frustrationLevel, tableId) values ('Bobbee', 'Ruppeli', '214-94-0768', 'bruppeli10@chron.com', '693-863-3987', 1739722, 4, 10, '2');
insert into Player (firstName, lastName, ssn, email, phoneNumber, netWorth, numDependents, frustrationLevel, tableId) values ('Alexei', 'Martschke', '854-53-8364', 'amartschke11@icq.com', '221-640-0525', 4748041, 5, 5, '5');
insert into Player (firstName, lastName, ssn, email, phoneNumber, netWorth, numDependents, frustrationLevel, tableId) values ('Chaddy', 'Giberd', '456-34-6444', 'cgiberd12@cpanel.net', '976-491-7522', 2147135, 0, 8, '10');
insert into Player (firstName, lastName, ssn, email, phoneNumber, netWorth, numDependents, frustrationLevel, tableId) values ('Meris', 'Gandrich', '222-32-2884', 'mgandrich13@huffingtonpost.com', '832-998-6299', 4516874, 5, 3, '8');
insert into Player (firstName, lastName, ssn, email, phoneNumber, netWorth, numDependents, frustrationLevel, tableId) values ('Raphael', 'Willment', '330-25-2775', 'rwillment14@hubpages.com', '707-362-1569', 2808322, 3, 10, '5');
insert into Player (firstName, lastName, ssn, email, phoneNumber, netWorth, numDependents, frustrationLevel, tableId) values ('Prudy', 'Sedman', '848-36-5769', 'psedman15@engadget.com', '590-961-8690', 3915410, 2, 0, '1');
insert into Player (firstName, lastName, ssn, email, phoneNumber, netWorth, numDependents, frustrationLevel, tableId) values ('Paxton', 'Meugens', '324-99-8380', 'pmeugens16@tinyurl.com', '315-816-6789', 2221724, 3, 9, '7');
insert into Player (firstName, lastName, ssn, email, phoneNumber, netWorth, numDependents, frustrationLevel, tableId) values ('Valida', 'Sweatman', '609-03-1029', 'vsweatman17@google.com.hk', '104-494-9761', 1427820, 5, 5, '10');
insert into Player (firstName, lastName, ssn, email, phoneNumber, netWorth, numDependents, frustrationLevel, tableId) values ('Kathye', 'Phelipeaux', '146-60-6897', 'kphelipeaux18@telegraph.co.uk', '390-127-7976', 4142727, 0, 2, '9');
insert into Player (firstName, lastName, ssn, email, phoneNumber, netWorth, numDependents, frustrationLevel, tableId) values ('Gibbie', 'Youngs', '694-10-0323', 'gyoungs19@irs.gov', '167-317-4220', 2116473, 4, 6, '3');
insert into Player (firstName, lastName, ssn, email, phoneNumber, netWorth, numDependents, frustrationLevel, tableId) values ('Beaufort', 'Allbones', '675-24-1234', 'ballbones1a@github.com', '311-317-5625', 117137, 0, 6, '6');
insert into Player (firstName, lastName, ssn, email, phoneNumber, netWorth, numDependents, frustrationLevel, tableId) values ('De', 'Blazej', '847-43-4218', 'dblazej1b@gnu.org', '102-229-7993', 1468945, 4, 6, '8');
insert into Player (firstName, lastName, ssn, email, phoneNumber, netWorth, numDependents, frustrationLevel, tableId) values ('Trent', 'Bellworthy', '895-02-3599', 'tbellworthy1c@jigsy.com', '695-646-0299', 382503, 2, 2, '4');
insert into Player (firstName, lastName, ssn, email, phoneNumber, netWorth, numDependents, frustrationLevel, tableId) values ('Robb', 'Cannicott', '484-77-4684', 'rcannicott1d@reference.com', '157-419-9359', 2640813, 5, 1, '2');

insert into Admin (firstName, lastName, phoneNumber, email, deviousness, role) values ('Melania', 'Roundtree', '950-745-5381', 'mroundtree0@webmd.com', 3, 'Regional Manager');
insert into Admin (firstName, lastName, phoneNumber, email, deviousness, role) values ('Nisse', 'Baskett', '195-355-8255', 'nbaskett1@google.de', 3, 'Junior Manager');
insert into Admin (firstName, lastName, phoneNumber, email, deviousness, role) values ('Baily', 'Learoid', '761-272-6626', 'blearoid2@walmart.com', 6, 'Regional Manager');
insert into Admin (firstName, lastName, phoneNumber, email, deviousness, role) values ('Carri', 'Epinoy', '355-309-3803', 'cepinoy3@scribd.com', 7, 'Regional Manager');
insert into Admin (firstName, lastName, phoneNumber, email, deviousness, role) values ('Virginie', 'Sandal', '794-481-4360', 'vsandal4@yale.edu', 9, 'General Manager');
insert into Admin (firstName, lastName, phoneNumber, email, deviousness, role) values ('Tybalt', 'Geary', '139-229-9070', 'tgeary5@4shared.com', 1, 'General Manager');
insert into Admin (firstName, lastName, phoneNumber, email, deviousness, role) values ('Bernarr', 'Stannering', '705-510-1817', 'bstannering6@purevolume.com', 6, 'Regional Manager');
insert into Admin (firstName, lastName, phoneNumber, email, deviousness, role) values ('Luca', 'Sugg', '250-813-4274', 'lsugg7@java.com', 6, 'Junior Manager');
insert into Admin (firstName, lastName, phoneNumber, email, deviousness, role) values ('Georgette', 'Mathys', '875-948-6180', 'gmathys8@bloomberg.com', 9, 'Regional Manager');
insert into Admin (firstName, lastName, phoneNumber, email, deviousness, role) values ('Galen', 'Moyce', '258-233-6368', 'gmoyce9@cafepress.com', 9, 'Regional Manager');
insert into Admin (firstName, lastName, phoneNumber, email, deviousness, role) values ('Gerrard', 'Meiklem', '550-762-4590', 'gmeiklema@opera.com', 0, 'General Manager');
insert into Admin (firstName, lastName, phoneNumber, email, deviousness, role) values ('Cheston', 'Pechacek', '489-993-1868', 'cpechacekb@nba.com', 6, 'Junior Manager');
insert into Admin (firstName, lastName, phoneNumber, email, deviousness, role) values ('Sheryl', 'Pitkin', '464-912-2734', 'spitkinc@huffingtonpost.com', 5, 'Regional Manager');
insert into Admin (firstName, lastName, phoneNumber, email, deviousness, role) values ('Marci', 'Mascall', '435-437-8879', 'mmascalld@wordpress.org', 10, 'Regional Manager');
insert into Admin (firstName, lastName, phoneNumber, email, deviousness, role) values ('Brent', 'Stansby', '859-712-8652', 'bstansbye@feedburner.com', 6, 'Regional Manager');
insert into Admin (firstName, lastName, phoneNumber, email, deviousness, role) values ('Conny', 'Mangham', '882-562-3624', 'cmanghamf@blogger.com', 3, 'Junior Manager');
insert into Admin (firstName, lastName, phoneNumber, email, deviousness, role) values ('Muire', 'Mogridge', '442-264-1073', 'mmogridgeg@nasa.gov', 2, 'Regional Manager');
insert into Admin (firstName, lastName, phoneNumber, email, deviousness, role) values ('Gavin', 'MacNeely', '584-707-9140', 'gmacneelyh@deviantart.com', 6, 'Regional Manager');
insert into Admin (firstName, lastName, phoneNumber, email, deviousness, role) values ('Murray', 'Hartshorne', '430-557-5257', 'mhartshornei@altervista.org', 9, 'General Manager');
insert into Admin (firstName, lastName, phoneNumber, email, deviousness, role) values ('Phebe', 'Trewman', '854-706-9015', 'ptrewmanj@newsvine.com', 4, 'General Manager');
insert into Admin (firstName, lastName, phoneNumber, email, deviousness, role) values ('Craggie', 'Binion', '658-284-2185', 'cbinionk@cyberchimps.com', 3, 'Junior Manager');
insert into Admin (firstName, lastName, phoneNumber, email, deviousness, role) values ('Brittni', 'Vasyukhichev', '162-339-4689', 'bvasyukhichevl@google.com', 7, 'Regional Manager');
insert into Admin (firstName, lastName, phoneNumber, email, deviousness, role) values ('Carroll', 'Castellini', '907-632-4981', 'ccastellinim@vistaprint.com', 5, 'General Manager');
insert into Admin (firstName, lastName, phoneNumber, email, deviousness, role) values ('Humfrey', 'Pail', '745-803-0690', 'hpailn@discovery.com', 5, 'Regional Manager');
insert into Admin (firstName, lastName, phoneNumber, email, deviousness, role) values ('Kore', 'Mc Corley', '864-387-6195', 'kmccorleyo@bloomberg.com', 5, 'Regional Manager');
insert into Admin (firstName, lastName, phoneNumber, email, deviousness, role) values ('Theda', 'Briscam', '313-468-3437', 'tbriscamp@livejournal.com', 3, 'Junior Manager');
insert into Admin (firstName, lastName, phoneNumber, email, deviousness, role) values ('Eustace', 'Flooks', '730-838-2948', 'eflooksq@youtu.be', 4, 'Regional Manager');
insert into Admin (firstName, lastName, phoneNumber, email, deviousness, role) values ('Thaxter', 'Ahrens', '423-135-0457', 'tahrensr@cnet.com', 7, 'General Manager');
insert into Admin (firstName, lastName, phoneNumber, email, deviousness, role) values ('Timoteo', 'Bernhard', '151-507-5455', 'tbernhards@yelp.com', 3, 'Regional Manager');
insert into Admin (firstName, lastName, phoneNumber, email, deviousness, role) values ('Amalita', 'Golsworthy', '283-685-9400', 'agolsworthyt@uol.com.br', 7, 'Junior Manager');
insert into Admin (firstName, lastName, phoneNumber, email, deviousness, role) values ('Lura', 'McIlmorie', '742-561-0929', 'lmcilmorieu@naver.com', 3, 'Regional Manager');
insert into Admin (firstName, lastName, phoneNumber, email, deviousness, role) values ('Tamma', 'Brower', '418-487-1028', 'tbrowerv@census.gov', 10, 'Junior Manager');
insert into Admin (firstName, lastName, phoneNumber, email, deviousness, role) values ('Hermione', 'Ribey', '710-781-0134', 'hribeyw@boston.com', 10, 'Junior Manager');
insert into Admin (firstName, lastName, phoneNumber, email, deviousness, role) values ('Sophia', 'Rapa', '936-381-1683', 'srapax@rambler.ru', 3, 'Junior Manager');
insert into Admin (firstName, lastName, phoneNumber, email, deviousness, role) values ('Reid', 'Toretta', '369-746-4418', 'rtorettay@tmall.com', 1, 'Regional Manager');
insert into Admin (firstName, lastName, phoneNumber, email, deviousness, role) values ('Kaela', 'Kerner', '654-827-2638', 'kkernerz@redcross.org', 3, 'Regional Manager');
insert into Admin (firstName, lastName, phoneNumber, email, deviousness, role) values ('Herold', 'Burbank', '683-411-6749', 'hburbank10@wp.com', 2, 'Junior Manager');
insert into Admin (firstName, lastName, phoneNumber, email, deviousness, role) values ('Sholom', 'Craigie', '659-237-2552', 'scraigie11@bbc.co.uk', 10, 'Junior Manager');
insert into Admin (firstName, lastName, phoneNumber, email, deviousness, role) values ('Johnny', 'Skyme', '384-870-7022', 'jskyme12@arizona.edu', 10, 'Regional Manager');
insert into Admin (firstName, lastName, phoneNumber, email, deviousness, role) values ('Samson', 'Heinrich', '240-894-3524', 'sheinrich13@hexun.com', 4, 'Junior Manager');
insert into Admin (firstName, lastName, phoneNumber, email, deviousness, role) values ('Gideon', 'Kingsbury', '323-125-6720', 'gkingsbury14@blogger.com', 7, 'Junior Manager');
insert into Admin (firstName, lastName, phoneNumber, email, deviousness, role) values ('Tessie', 'Seedman', '425-699-6568', 'tseedman15@rambler.ru', 9, 'General Manager');
insert into Admin (firstName, lastName, phoneNumber, email, deviousness, role) values ('Rollie', 'Splevin', '169-162-3172', 'rsplevin16@cnet.com', 8, 'Regional Manager');
insert into Admin (firstName, lastName, phoneNumber, email, deviousness, role) values ('Petunia', 'Tilson', '589-429-6938', 'ptilson17@yolasite.com', 3, 'Regional Manager');
insert into Admin (firstName, lastName, phoneNumber, email, deviousness, role) values ('Vasili', 'Fincham', '879-440-1249', 'vfincham18@nasa.gov', 5, 'Regional Manager');
insert into Admin (firstName, lastName, phoneNumber, email, deviousness, role) values ('Maddi', 'Sanson', '883-178-7272', 'msanson19@indiegogo.com', 9, 'Regional Manager');
insert into Admin (firstName, lastName, phoneNumber, email, deviousness, role) values ('Gisele', 'Pampling', '257-672-1680', 'gpampling1a@youku.com', 7, 'General Manager');
insert into Admin (firstName, lastName, phoneNumber, email, deviousness, role) values ('Georgeanna', 'Nanuccioi', '564-208-8715', 'gnanuccioi1b@ehow.com', 1, 'General Manager');
insert into Admin (firstName, lastName, phoneNumber, email, deviousness, role) values ('Jany', 'Kinkead', '642-153-2598', 'jkinkead1c@prweb.com', 4, 'Junior Manager');
insert into Admin (firstName, lastName, phoneNumber, email, deviousness, role) values ('Evanne', 'Antoszczyk', '763-498-4863', 'eantoszczyk1d@webs.com', 6, 'Regional Manager');

insert into Slots (costToPlay, rigScore, winAmount, playerId) values (50, 0.3, 584, '6');
insert into Slots (costToPlay, rigScore, winAmount, playerId) values (500, 0.15, 840, '33');
insert into Slots (costToPlay, rigScore, winAmount, playerId) values (15, 0.55, 529, '4');
insert into Slots (costToPlay, rigScore, winAmount, playerId) values (15, 0.12, 543, '48');
insert into Slots (costToPlay, rigScore, winAmount, playerId) values (10, 0.53, 431, '43');
insert into Slots (costToPlay, rigScore, winAmount, playerId) values (10, 0.87, 991, '40');
insert into Slots (costToPlay, rigScore, winAmount, playerId) values (500, 0.12, 487, '47');
insert into Slots (costToPlay, rigScore, winAmount, playerId) values (100, 0.73, 708, '8');
insert into Slots (costToPlay, rigScore, winAmount, playerId) values (50, 0.91, 60, '20');
insert into Slots (costToPlay, rigScore, winAmount, playerId) values (25, 0.39, 198, '17');
insert into Slots (costToPlay, rigScore, winAmount, playerId) values (100, 0.63, 49, '38');
insert into Slots (costToPlay, rigScore, winAmount, playerId) values (500, 0.32, 205, '32');
insert into Slots (costToPlay, rigScore, winAmount, playerId) values (10, 0.88, 343, '45');
insert into Slots (costToPlay, rigScore, winAmount, playerId) values (10, 0.49, 392, '16');
insert into Slots (costToPlay, rigScore, winAmount, playerId) values (500, 0.05, 791, '44');
insert into Slots (costToPlay, rigScore, winAmount, playerId) values (500, 0.86, 467, '14');
insert into Slots (costToPlay, rigScore, winAmount, playerId) values (10, 0.57, 5, '2');
insert into Slots (costToPlay, rigScore, winAmount, playerId) values (50, 0.78, 989, '34');
insert into Slots (costToPlay, rigScore, winAmount, playerId) values (100, 0.32, 766, '50');
insert into Slots (costToPlay, rigScore, winAmount, playerId) values (100, 0.34, 544, '23');
insert into Slots (costToPlay, rigScore, winAmount, playerId) values (10, 0.35, 334, '7');
insert into Slots (costToPlay, rigScore, winAmount, playerId) values (15, 0.67, 641, '25');
insert into Slots (costToPlay, rigScore, winAmount, playerId) values (15, 0.09, 902, '5');
insert into Slots (costToPlay, rigScore, winAmount, playerId) values (500, 0.79, 913, '26');
insert into Slots (costToPlay, rigScore, winAmount, playerId) values (15, 0.49, 585, '29');
insert into Slots (costToPlay, rigScore, winAmount, playerId) values (10, 0.36, 399, '24');
insert into Slots (costToPlay, rigScore, winAmount, playerId) values (500, 0.32, 359, '11');
insert into Slots (costToPlay, rigScore, winAmount, playerId) values (500, 0.44, 540, '1');
insert into Slots (costToPlay, rigScore, winAmount, playerId) values (50, 0.67, 749, '31');
insert into Slots (costToPlay, rigScore, winAmount, playerId) values (10, 0.4, 198, '9');
insert into Slots (costToPlay, rigScore, winAmount, playerId) values (25, 0.5, 283, '19');
insert into Slots (costToPlay, rigScore, winAmount, playerId) values (100, 0.29, 776, '10');
insert into Slots (costToPlay, rigScore, winAmount, playerId) values (25, 0.57, 163, '22');
insert into Slots (costToPlay, rigScore, winAmount, playerId) values (10, 0.84, 116, '41');
insert into Slots (costToPlay, rigScore, winAmount, playerId) values (50, 0.04, 202, '12');
insert into Slots (costToPlay, rigScore, winAmount, playerId) values (50, 0.29, 963, '3');
insert into Slots (costToPlay, rigScore, winAmount, playerId) values (500, 0.26, 250, '37');
insert into Slots (costToPlay, rigScore, winAmount, playerId) values (10, 0.09, 90, '36');
insert into Slots (costToPlay, rigScore, winAmount, playerId) values (100, 0.39, 78, '21');
insert into Slots (costToPlay, rigScore, winAmount, playerId) values (25, 0.06, 990, '39');
insert into Slots (costToPlay, rigScore, winAmount, playerId) values (10, 0.34, 177, '15');
insert into Slots (costToPlay, rigScore, winAmount, playerId) values (50, 0.79, 109, '42');
insert into Slots (costToPlay, rigScore, winAmount, playerId) values (50, 0.82, 893, '13');
insert into Slots (costToPlay, rigScore, winAmount, playerId) values (50, 0.74, 680, '35');
insert into Slots (costToPlay, rigScore, winAmount, playerId) values (10, 0.28, 730, '27');
insert into Slots (costToPlay, rigScore, winAmount, playerId) values (100, 0.63, 105, '49');
insert into Slots (costToPlay, rigScore, winAmount, playerId) values (25, 0.07, 269, '30');
insert into Slots (costToPlay, rigScore, winAmount, playerId) values (25, 0.88, 307, '18');
insert into Slots (costToPlay, rigScore, winAmount, playerId) values (15, 0.36, 781, '28');
insert into Slots (costToPlay, rigScore, winAmount, playerId) values (25, 0.17, 873, '46');

insert into AdminSlotsBridge (adminId, slotsId) values ('39', '6');
insert into AdminSlotsBridge (adminId, slotsId) values ('25', '20');
insert into AdminSlotsBridge (adminId, slotsId) values ('18', '44');
insert into AdminSlotsBridge (adminId, slotsId) values ('33', '17');
insert into AdminSlotsBridge (adminId, slotsId) values ('17', '16');
insert into AdminSlotsBridge (adminId, slotsId) values ('30', '36');
insert into AdminSlotsBridge (adminId, slotsId) values ('16', '29');
insert into AdminSlotsBridge (adminId, slotsId) values ('27', '50');
insert into AdminSlotsBridge (adminId, slotsId) values ('6', '35');
insert into AdminSlotsBridge (adminId, slotsId) values ('4', '25');
insert into AdminSlotsBridge (adminId, slotsId) values ('32', '24');
insert into AdminSlotsBridge (adminId, slotsId) values ('2', '26');
insert into AdminSlotsBridge (adminId, slotsId) values ('48', '43');
insert into AdminSlotsBridge (adminId, slotsId) values ('20', '15');
insert into AdminSlotsBridge (adminId, slotsId) values ('47', '42');
insert into AdminSlotsBridge (adminId, slotsId) values ('9', '10');
insert into AdminSlotsBridge (adminId, slotsId) values ('22', '19');
insert into AdminSlotsBridge (adminId, slotsId) values ('31', '30');
insert into AdminSlotsBridge (adminId, slotsId) values ('5', '46');
insert into AdminSlotsBridge (adminId, slotsId) values ('29', '22');
insert into AdminSlotsBridge (adminId, slotsId) values ('40', '47');
insert into AdminSlotsBridge (adminId, slotsId) values ('41', '39');
insert into AdminSlotsBridge (adminId, slotsId) values ('50', '11');
insert into AdminSlotsBridge (adminId, slotsId) values ('42', '49');
insert into AdminSlotsBridge (adminId, slotsId) values ('49', '32');
insert into AdminSlotsBridge (adminId, slotsId) values ('1', '34');
insert into AdminSlotsBridge (adminId, slotsId) values ('21', '14');
insert into AdminSlotsBridge (adminId, slotsId) values ('13', '1');
insert into AdminSlotsBridge (adminId, slotsId) values ('35', '45');
insert into AdminSlotsBridge (adminId, slotsId) values ('3', '12');
insert into AdminSlotsBridge (adminId, slotsId) values ('36', '31');
insert into AdminSlotsBridge (adminId, slotsId) values ('34', '48');
insert into AdminSlotsBridge (adminId, slotsId) values ('12', '33');
insert into AdminSlotsBridge (adminId, slotsId) values ('15', '40');
insert into AdminSlotsBridge (adminId, slotsId) values ('44', '4');
insert into AdminSlotsBridge (adminId, slotsId) values ('11', '27');
insert into AdminSlotsBridge (adminId, slotsId) values ('24', '9');
insert into AdminSlotsBridge (adminId, slotsId) values ('46', '2');
insert into AdminSlotsBridge (adminId, slotsId) values ('28', '18');
insert into AdminSlotsBridge (adminId, slotsId) values ('23', '38');
insert into AdminSlotsBridge (adminId, slotsId) values ('8', '8');
insert into AdminSlotsBridge (adminId, slotsId) values ('37', '13');
insert into AdminSlotsBridge (adminId, slotsId) values ('10', '41');
insert into AdminSlotsBridge (adminId, slotsId) values ('45', '7');
insert into AdminSlotsBridge (adminId, slotsId) values ('38', '21');
insert into AdminSlotsBridge (adminId, slotsId) values ('7', '28');
insert into AdminSlotsBridge (adminId, slotsId) values ('14', '5');
insert into AdminSlotsBridge (adminId, slotsId) values ('43', '37');
insert into AdminSlotsBridge (adminId, slotsId) values ('26', '3');
insert into AdminSlotsBridge (adminId, slotsId) values ('19', '23');

insert into AdminTableBridge (tableId, adminId) values ('6', '29');
insert into AdminTableBridge (tableId, adminId) values ('5', '32');
insert into AdminTableBridge (tableId, adminId) values ('3', '30');
insert into AdminTableBridge (tableId, adminId) values ('1', '17');
insert into AdminTableBridge (tableId, adminId) values ('2', '43');
insert into AdminTableBridge (tableId, adminId) values ('9', '16');
insert into AdminTableBridge (tableId, adminId) values ('7', '19');
insert into AdminTableBridge (tableId, adminId) values ('10', '49');
insert into AdminTableBridge (tableId, adminId) values ('4', '1');
insert into AdminTableBridge (tableId, adminId) values ('8', '48');
insert into AdminTableBridge (tableId, adminId) values ('4', '12');
insert into AdminTableBridge (tableId, adminId) values ('5', '27');
insert into AdminTableBridge (tableId, adminId) values ('3', '3');
insert into AdminTableBridge (tableId, adminId) values ('1', '37');
insert into AdminTableBridge (tableId, adminId) values ('9', '39');
insert into AdminTableBridge (tableId, adminId) values ('7', '21');
insert into AdminTableBridge (tableId, adminId) values ('6', '7');
insert into AdminTableBridge (tableId, adminId) values ('8', '47');
insert into AdminTableBridge (tableId, adminId) values ('2', '50');
insert into AdminTableBridge (tableId, adminId) values ('10', '10');
insert into AdminTableBridge (tableId, adminId) values ('3', '18');
insert into AdminTableBridge (tableId, adminId) values ('7', '9');
insert into AdminTableBridge (tableId, adminId) values ('2', '11');
insert into AdminTableBridge (tableId, adminId) values ('10', '45');
insert into AdminTableBridge (tableId, adminId) values ('6', '24');
insert into AdminTableBridge (tableId, adminId) values ('9', '26');
insert into AdminTableBridge (tableId, adminId) values ('4', '20');
insert into AdminTableBridge (tableId, adminId) values ('8', '36');
insert into AdminTableBridge (tableId, adminId) values ('5', '14');
insert into AdminTableBridge (tableId, adminId) values ('1', '4');
insert into AdminTableBridge (tableId, adminId) values ('7', '5');
insert into AdminTableBridge (tableId, adminId) values ('10', '40');
insert into AdminTableBridge (tableId, adminId) values ('6', '23');
insert into AdminTableBridge (tableId, adminId) values ('9', '35');
insert into AdminTableBridge (tableId, adminId) values ('4', '34');
insert into AdminTableBridge (tableId, adminId) values ('1', '38');
insert into AdminTableBridge (tableId, adminId) values ('3', '31');
insert into AdminTableBridge (tableId, adminId) values ('2', '44');
insert into AdminTableBridge (tableId, adminId) values ('5', '25');
insert into AdminTableBridge (tableId, adminId) values ('8', '8');
insert into AdminTableBridge (tableId, adminId) values ('10', '6');
insert into AdminTableBridge (tableId, adminId) values ('2', '13');
insert into AdminTableBridge (tableId, adminId) values ('6', '33');
insert into AdminTableBridge (tableId, adminId) values ('5', '46');
insert into AdminTableBridge (tableId, adminId) values ('3', '41');
insert into AdminTableBridge (tableId, adminId) values ('8', '42');
insert into AdminTableBridge (tableId, adminId) values ('4', '15');
insert into AdminTableBridge (tableId, adminId) values ('7', '2');
insert into AdminTableBridge (tableId, adminId) values ('9', '28');
insert into AdminTableBridge (tableId, adminId) values ('1', '22');

insert into Dealer (firstName, lastName, friendliness, corruptness, scumminess, tableId) values ('Zarla', 'Pinnell', 9, 8, 6, '7');
insert into Dealer (firstName, lastName, friendliness, corruptness, scumminess, tableId) values ('Tommie', 'Chattey', 1, 8, 0, '2');
insert into Dealer (firstName, lastName, friendliness, corruptness, scumminess, tableId) values ('Margery', 'Burnard', 3, 1, 1, '6');
insert into Dealer (firstName, lastName, friendliness, corruptness, scumminess, tableId) values ('Chevalier', 'O''Corrane', 2, 1, 9, '8');
insert into Dealer (firstName, lastName, friendliness, corruptness, scumminess, tableId) values ('Cloris', 'Cronchey', 7, 9, 8, '3');
insert into Dealer (firstName, lastName, friendliness, corruptness, scumminess, tableId) values ('Nerte', 'Yeoman', 0, 3, 9, '4');
insert into Dealer (firstName, lastName, friendliness, corruptness, scumminess, tableId) values ('Roma', 'Pullin', 7, 0, 3, '9');
insert into Dealer (firstName, lastName, friendliness, corruptness, scumminess, tableId) values ('Emmye', 'Lethbury', 0, 5, 0, '5');
insert into Dealer (firstName, lastName, friendliness, corruptness, scumminess, tableId) values ('Maude', 'Lisle', 2, 2, 6, '10');
insert into Dealer (firstName, lastName, friendliness, corruptness, scumminess, tableId) values ('Ashby', 'Conrath', 7, 10, 7, '1');
insert into Dealer (firstName, lastName, friendliness, corruptness, scumminess, tableId) values ('Ashla', 'Bridge', 0, 10, 2, '4');
insert into Dealer (firstName, lastName, friendliness, corruptness, scumminess, tableId) values ('Gifford', 'Bristow', 7, 3, 7, '8');
insert into Dealer (firstName, lastName, friendliness, corruptness, scumminess, tableId) values ('Damian', 'Rubinowitch', 6, 3, 8, '5');
insert into Dealer (firstName, lastName, friendliness, corruptness, scumminess, tableId) values ('Corella', 'Szubert', 9, 7, 9, '9');
insert into Dealer (firstName, lastName, friendliness, corruptness, scumminess, tableId) values ('Claudell', 'Mueller', 4, 2, 5, '6');
insert into Dealer (firstName, lastName, friendliness, corruptness, scumminess, tableId) values ('Aurilia', 'Bearsmore', 4, 3, 9, '3');
insert into Dealer (firstName, lastName, friendliness, corruptness, scumminess, tableId) values ('Robin', 'Tippin', 8, 6, 10, '1');
insert into Dealer (firstName, lastName, friendliness, corruptness, scumminess, tableId) values ('Read', 'Shrimplin', 9, 7, 4, '2');
insert into Dealer (firstName, lastName, friendliness, corruptness, scumminess, tableId) values ('Karlis', 'Boshere', 1, 0, 6, '7');
insert into Dealer (firstName, lastName, friendliness, corruptness, scumminess, tableId) values ('Ianthe', 'Pettecrew', 7, 4, 7, '10');
insert into Dealer (firstName, lastName, friendliness, corruptness, scumminess, tableId) values ('Rene', 'Dellenbroker', 7, 7, 5, '3');
insert into Dealer (firstName, lastName, friendliness, corruptness, scumminess, tableId) values ('Susann', 'Cronchey', 6, 0, 0, '8');
insert into Dealer (firstName, lastName, friendliness, corruptness, scumminess, tableId) values ('Elwira', 'Congreave', 10, 8, 7, '4');
insert into Dealer (firstName, lastName, friendliness, corruptness, scumminess, tableId) values ('Caren', 'Crippes', 8, 5, 2, '9');
insert into Dealer (firstName, lastName, friendliness, corruptness, scumminess, tableId) values ('Vyky', 'Bettam', 7, 5, 4, '7');
insert into Dealer (firstName, lastName, friendliness, corruptness, scumminess, tableId) values ('Dana', 'Alton', 5, 5, 5, '1');
insert into Dealer (firstName, lastName, friendliness, corruptness, scumminess, tableId) values ('Ulises', 'Hardy', 6, 9, 2, '6');
insert into Dealer (firstName, lastName, friendliness, corruptness, scumminess, tableId) values ('Bradney', 'Littledyke', 2, 2, 10, '10');
insert into Dealer (firstName, lastName, friendliness, corruptness, scumminess, tableId) values ('Roch', 'Straun', 3, 10, 4, '5');
insert into Dealer (firstName, lastName, friendliness, corruptness, scumminess, tableId) values ('Toddie', 'Glossup', 7, 9, 0, '2');
insert into Dealer (firstName, lastName, friendliness, corruptness, scumminess, tableId) values ('Valenka', 'Hoggan', 7, 1, 3, '2');
insert into Dealer (firstName, lastName, friendliness, corruptness, scumminess, tableId) values ('Dex', 'Ebben', 1, 8, 4, '5');
insert into Dealer (firstName, lastName, friendliness, corruptness, scumminess, tableId) values ('Garv', 'Rickertsen', 9, 8, 6, '7');
insert into Dealer (firstName, lastName, friendliness, corruptness, scumminess, tableId) values ('Nanni', 'Greatex', 8, 5, 4, '4');
insert into Dealer (firstName, lastName, friendliness, corruptness, scumminess, tableId) values ('Camila', 'Frend', 8, 7, 2, '3');
insert into Dealer (firstName, lastName, friendliness, corruptness, scumminess, tableId) values ('Ragnar', 'Rothman', 1, 9, 8, '6');
insert into Dealer (firstName, lastName, friendliness, corruptness, scumminess, tableId) values ('Johannah', 'Managh', 7, 0, 2, '8');
insert into Dealer (firstName, lastName, friendliness, corruptness, scumminess, tableId) values ('Torre', 'Grinley', 5, 8, 7, '1');
insert into Dealer (firstName, lastName, friendliness, corruptness, scumminess, tableId) values ('Jerad', 'Paulin', 2, 10, 5, '10');
insert into Dealer (firstName, lastName, friendliness, corruptness, scumminess, tableId) values ('Goldi', 'Thickin', 9, 7, 6, '9');
insert into Dealer (firstName, lastName, friendliness, corruptness, scumminess, tableId) values ('Helenka', 'Cocksedge', 0, 9, 3, '2');
insert into Dealer (firstName, lastName, friendliness, corruptness, scumminess, tableId) values ('Carolina', 'Skiplorne', 8, 1, 10, '1');
insert into Dealer (firstName, lastName, friendliness, corruptness, scumminess, tableId) values ('Bren', 'Cordet', 2, 2, 9, '6');
insert into Dealer (firstName, lastName, friendliness, corruptness, scumminess, tableId) values ('Rudd', 'Moat', 0, 8, 7, '4');
insert into Dealer (firstName, lastName, friendliness, corruptness, scumminess, tableId) values ('Arlyne', 'Kernes', 3, 7, 9, '3');
insert into Dealer (firstName, lastName, friendliness, corruptness, scumminess, tableId) values ('Frank', 'Burnyate', 4, 3, 10, '7');
insert into Dealer (firstName, lastName, friendliness, corruptness, scumminess, tableId) values ('Enid', 'Whyborn', 5, 7, 9, '10');
insert into Dealer (firstName, lastName, friendliness, corruptness, scumminess, tableId) values ('Wat', 'McKew', 0, 5, 0, '9');
insert into Dealer (firstName, lastName, friendliness, corruptness, scumminess, tableId) values ('Ches', 'Iskov', 9, 0, 0, '8');
insert into Dealer (firstName, lastName, friendliness, corruptness, scumminess, tableId) values ('Yovonnda', 'Burlingame', 7, 3, 6, '5');

insert into Drink (name, alcoholContent) values ('Petron', 0.4);
insert into Drink (name, alcoholContent) values ('Bombay Sapphire', 0.72);
insert into Drink (name, alcoholContent) values ('Jack Daniels', 0.72);
insert into Drink (name, alcoholContent) values ('Grey Goose', 0.29);
insert into Drink (name, alcoholContent) values ('Smirnoff', 0.64);
insert into Drink (name, alcoholContent) values ('Bombay Sapphire', 0.89);
insert into Drink (name, alcoholContent) values ('Bacardi', 0.88);
insert into Drink (name, alcoholContent) values ('Grey Goose', 0.97);
insert into Drink (name, alcoholContent) values ('Bombay Sapphire', 0.56);
insert into Drink (name, alcoholContent) values ('Smirnoff', 0.62);
insert into Drink (name, alcoholContent) values ('Bacardi', 0.75);
insert into Drink (name, alcoholContent) values ('Petron', 0.04);
insert into Drink (name, alcoholContent) values ('Smirnoff', 0.39);
insert into Drink (name, alcoholContent) values ('Jack Daniels', 0.42);
insert into Drink (name, alcoholContent) values ('Titos', 0.9);
insert into Drink (name, alcoholContent) values ('Bombay Sapphire', 0.03);
insert into Drink (name, alcoholContent) values ('Petron', 0.63);
insert into Drink (name, alcoholContent) values ('Jager', 0.52);
insert into Drink (name, alcoholContent) values ('Jager', 0.05);
insert into Drink (name, alcoholContent) values ('Smirnoff', 0.74);
insert into Drink (name, alcoholContent) values ('Grey Goose', 0.05);
insert into Drink (name, alcoholContent) values ('Grey Goose', 0.52);
insert into Drink (name, alcoholContent) values ('Jager', 0.53);
insert into Drink (name, alcoholContent) values ('Grey Goose', 0.45);
insert into Drink (name, alcoholContent) values ('Smirnoff', 0.08);
insert into Drink (name, alcoholContent) values ('Jack Daniels', 0.04);
insert into Drink (name, alcoholContent) values ('Grey Goose', 0.61);
insert into Drink (name, alcoholContent) values ('Jager', 0.2);
insert into Drink (name, alcoholContent) values ('Bacardi', 0.49);
insert into Drink (name, alcoholContent) values ('Smirnoff', 0.33);
insert into Drink (name, alcoholContent) values ('Grey Goose', 0.28);
insert into Drink (name, alcoholContent) values ('Petron', 0.67);
insert into Drink (name, alcoholContent) values ('Grey Goose', 0.02);
insert into Drink (name, alcoholContent) values ('Bombay Sapphire', 0.12);
insert into Drink (name, alcoholContent) values ('Bombay Sapphire', 0.25);
insert into Drink (name, alcoholContent) values ('Bombay Sapphire', 0.93);
insert into Drink (name, alcoholContent) values ('Titos', 0.53);
insert into Drink (name, alcoholContent) values ('Bacardi', 0.42);
insert into Drink (name, alcoholContent) values ('Jack Daniels', 0.62);
insert into Drink (name, alcoholContent) values ('Jack Daniels', 0.9);
insert into Drink (name, alcoholContent) values ('Petron', 0.86);
insert into Drink (name, alcoholContent) values ('Jager', 0.19);
insert into Drink (name, alcoholContent) values ('Grey Goose', 0.61);
insert into Drink (name, alcoholContent) values ('Smirnoff', 0.21);
insert into Drink (name, alcoholContent) values ('Titos', 0.43);
insert into Drink (name, alcoholContent) values ('Titos', 0.18);
insert into Drink (name, alcoholContent) values ('Bombay Sapphire', 0.25);
insert into Drink (name, alcoholContent) values ('Bombay Sapphire', 0.77);
insert into Drink (name, alcoholContent) values ('Smirnoff', 0.21);
insert into Drink (name, alcoholContent) values ('Bombay Sapphire', 0.6);

insert into Address (street, city, state, country, zip, playerId) values ('733 Jenna Plaza', 'Kansas City', 'Missouri', 'United States', '64199', '16');
insert into Address (street, city, state, country, zip, playerId) values ('2 Briar Crest Junction', 'Cumming', 'Georgia', 'United States', '30130', '6');
insert into Address (street, city, state, country, zip, playerId) values ('755 Artisan Pass', 'El Paso', 'Texas', 'United States', '88569', '1');
insert into Address (street, city, state, country, zip, playerId) values ('346 Mccormick Parkway', 'Atlanta', 'Georgia', 'United States', '31106', '42');
insert into Address (street, city, state, country, zip, playerId) values ('52 Hudson Crossing', 'Springfield', 'Ohio', 'United States', '45505', '41');
insert into Address (street, city, state, country, zip, playerId) values ('121 Ludington Lane', 'Tulsa', 'Oklahoma', 'United States', '74141', '40');
insert into Address (street, city, state, country, zip, playerId) values ('1796 Mitchell Way', 'Pinellas Park', 'Florida', 'United States', '34665', '28');
insert into Address (street, city, state, country, zip, playerId) values ('78 Bashford Place', 'Evansville', 'Indiana', 'United States', '47747', '2');
insert into Address (street, city, state, country, zip, playerId) values ('9 Atwood Hill', 'Wichita', 'Kansas', 'United States', '67236', '48');
insert into Address (street, city, state, country, zip, playerId) values ('1964 Blue Bill Park Pass', 'Pittsburgh', 'Pennsylvania', 'United States', '15274', '33');
insert into Address (street, city, state, country, zip, playerId) values ('2295 Columbus Drive', 'Kansas City', 'Missouri', 'United States', '64149', '20');
insert into Address (street, city, state, country, zip, playerId) values ('37476 Sycamore Street', 'Charlotte', 'North Carolina', 'United States', '28205', '45');
insert into Address (street, city, state, country, zip, playerId) values ('9832 Fair Oaks Hill', 'Las Vegas', 'Nevada', 'United States', '89155', '32');
insert into Address (street, city, state, country, zip, playerId) values ('19 Annamark Crossing', 'Madison', 'Wisconsin', 'United States', '53785', '46');
insert into Address (street, city, state, country, zip, playerId) values ('03 Beilfuss Street', 'Independence', 'Missouri', 'United States', '64054', '12');
insert into Address (street, city, state, country, zip, playerId) values ('6 Kings Trail', 'Las Vegas', 'Nevada', 'United States', '89140', '50');
insert into Address (street, city, state, country, zip, playerId) values ('72237 Manitowish Hill', 'Kansas City', 'Missouri', 'United States', '64199', '18');
insert into Address (street, city, state, country, zip, playerId) values ('6 Eagle Crest Road', 'Oakland', 'California', 'United States', '94622', '23');
insert into Address (street, city, state, country, zip, playerId) values ('12 Claremont Avenue', 'Lafayette', 'Indiana', 'United States', '47905', '35');
insert into Address (street, city, state, country, zip, playerId) values ('1203 Continental Center', 'Fresno', 'California', 'United States', '93794', '47');
insert into Address (street, city, state, country, zip, playerId) values ('1295 Hudson Hill', 'Irvine', 'California', 'United States', '92619', '34');
insert into Address (street, city, state, country, zip, playerId) values ('165 Fairview Park', 'Amarillo', 'Texas', 'United States', '79188', '11');
insert into Address (street, city, state, country, zip, playerId) values ('82457 Pine View Crossing', 'Washington', 'District of Columbia', 'United States', '20016', '30');
insert into Address (street, city, state, country, zip, playerId) values ('8352 Drewry Hill', 'Los Angeles', 'California', 'United States', '90076', '7');
insert into Address (street, city, state, country, zip, playerId) values ('0 Cambridge Lane', 'Dallas', 'Texas', 'United States', '75260', '26');
insert into Address (street, city, state, country, zip, playerId) values ('170 Little Fleur Drive', 'Colorado Springs', 'Colorado', 'United States', '80935', '15');
insert into Address (street, city, state, country, zip, playerId) values ('5 Kenwood Court', 'San Diego', 'California', 'United States', '92137', '36');
insert into Address (street, city, state, country, zip, playerId) values ('2 Reinke Pass', 'Denver', 'Colorado', 'United States', '80243', '21');
insert into Address (street, city, state, country, zip, playerId) values ('4045 Sommers Hill', 'Jackson', 'Mississippi', 'United States', '39236', '24');
insert into Address (street, city, state, country, zip, playerId) values ('22261 Village Green Park', 'Pittsburgh', 'Pennsylvania', 'United States', '15240', '9');
insert into Address (street, city, state, country, zip, playerId) values ('47081 Prentice Avenue', 'New York City', 'New York', 'United States', '10125', '10');
insert into Address (street, city, state, country, zip, playerId) values ('528 New Castle Place', 'Austin', 'Texas', 'United States', '78749', '31');
insert into Address (street, city, state, country, zip, playerId) values ('98 Clemons Court', 'Dallas', 'Texas', 'United States', '75246', '4');
insert into Address (street, city, state, country, zip, playerId) values ('894 Lakeland Place', 'Evansville', 'Indiana', 'United States', '47719', '29');
insert into Address (street, city, state, country, zip, playerId) values ('4 Park Meadow Lane', 'New Haven', 'Connecticut', 'United States', '06533', '3');
insert into Address (street, city, state, country, zip, playerId) values ('7086 Schmedeman Plaza', 'Washington', 'District of Columbia', 'United States', '20540', '43');
insert into Address (street, city, state, country, zip, playerId) values ('20 Walton Park', 'Tallahassee', 'Florida', 'United States', '32309', '14');
insert into Address (street, city, state, country, zip, playerId) values ('449 Wayridge Pass', 'Topeka', 'Kansas', 'United States', '66699', '13');
insert into Address (street, city, state, country, zip, playerId) values ('0237 Birchwood Court', 'Kansas City', 'Missouri', 'United States', '64101', '8');
insert into Address (street, city, state, country, zip, playerId) values ('94 Susan Drive', 'Portland', 'Oregon', 'United States', '97201', '44');
insert into Address (street, city, state, country, zip, playerId) values ('781 Lake View Drive', 'New York City', 'New York', 'United States', '10004', '38');
insert into Address (street, city, state, country, zip, playerId) values ('809 Steensland Road', 'Des Moines', 'Iowa', 'United States', '50362', '27');
insert into Address (street, city, state, country, zip, playerId) values ('23077 Sommers Pass', 'Atlanta', 'Georgia', 'United States', '30358', '37');
insert into Address (street, city, state, country, zip, playerId) values ('3303 Steensland Way', 'El Paso', 'Texas', 'United States', '79911', '22');
insert into Address (street, city, state, country, zip, playerId) values ('128 Johnson Avenue', 'Salt Lake City', 'Utah', 'United States', '84189', '25');
insert into Address (street, city, state, country, zip, playerId) values ('49307 Carey Road', 'Pasadena', 'California', 'United States', '91186', '39');
insert into Address (street, city, state, country, zip, playerId) values ('4 Roth Center', 'Atlanta', 'Georgia', 'United States', '30375', '19');
insert into Address (street, city, state, country, zip, playerId) values ('2449 Goodland Avenue', 'Albuquerque', 'New Mexico', 'United States', '87201', '17');
insert into Address (street, city, state, country, zip, playerId) values ('76 Hauk Junction', 'Alexandria', 'Virginia', 'United States', '22313', '49');
insert into Address (street, city, state, country, zip, playerId) values ('771 Logan Plaza', 'Nashville', 'Tennessee', 'United States', '37205', '5');
insert into Address (street, city, state, country, zip, playerId) values ('1332 Corben Way', 'Pittsburgh', 'Pennsylvania', 'United States', '15279', '4');
insert into Address (street, city, state, country, zip, playerId) values ('671 Fallview Crossing', 'San Jose', 'California', 'United States', '95118', '32');
insert into Address (street, city, state, country, zip, playerId) values ('3358 Novick Court', 'San Diego', 'California', 'United States', '92145', '49');
insert into Address (street, city, state, country, zip, playerId) values ('127 Fuller Terrace', 'Chicago', 'Illinois', 'United States', '60697', '16');
insert into Address (street, city, state, country, zip, playerId) values ('3800 Blaine Place', 'Salt Lake City', 'Utah', 'United States', '84130', '43');
insert into Address (street, city, state, country, zip, playerId) values ('0491 Bartelt Avenue', 'Jacksonville', 'Florida', 'United States', '32259', '10');
insert into Address (street, city, state, country, zip, playerId) values ('11125 Barby Center', 'Cleveland', 'Ohio', 'United States', '44118', '31');
insert into Address (street, city, state, country, zip, playerId) values ('29996 Buena Vista Junction', 'Fort Lauderdale', 'Florida', 'United States', '33330', '47');
insert into Address (street, city, state, country, zip, playerId) values ('5515 Sherman Circle', 'Stamford', 'Connecticut', 'United States', '06922', '35');
insert into Address (street, city, state, country, zip, playerId) values ('39331 Graedel Junction', 'Philadelphia', 'Pennsylvania', 'United States', '19172', '33');
insert into Address (street, city, state, country, zip, playerId) values ('2 Kensington Crossing', 'Palmdale', 'California', 'United States', '93591', '48');
insert into Address (street, city, state, country, zip, playerId) values ('251 Mandrake Court', 'Carol Stream', 'Illinois', 'United States', '60158', '23');
insert into Address (street, city, state, country, zip, playerId) values ('4 Dahle Circle', 'Beaumont', 'Texas', 'United States', '77705', '42');
insert into Address (street, city, state, country, zip, playerId) values ('06442 Lakewood Street', 'Washington', 'District of Columbia', 'United States', '20088', '14');
insert into Address (street, city, state, country, zip, playerId) values ('32 Butterfield Center', 'Honolulu', 'Hawaii', 'United States', '96825', '50');
insert into Address (street, city, state, country, zip, playerId) values ('3880 Esch Circle', 'Shawnee Mission', 'Kansas', 'United States', '66210', '26');
insert into Address (street, city, state, country, zip, playerId) values ('92828 Linden Center', 'Hartford', 'Connecticut', 'United States', '06160', '15');
insert into Address (street, city, state, country, zip, playerId) values ('6 Crowley Place', 'Boise', 'Idaho', 'United States', '83732', '25');
insert into Address (street, city, state, country, zip, playerId) values ('86446 Melody Junction', 'Alhambra', 'California', 'United States', '91841', '18');
insert into Address (street, city, state, country, zip, playerId) values ('74 Melby Pass', 'Alpharetta', 'Georgia', 'United States', '30022', '28');
insert into Address (street, city, state, country, zip, playerId) values ('7 Arrowood Circle', 'Fort Worth', 'Texas', 'United States', '76178', '9');
insert into Address (street, city, state, country, zip, playerId) values ('8 Pine View Park', 'Moreno Valley', 'California', 'United States', '92555', '30');
insert into Address (street, city, state, country, zip, playerId) values ('64 Randy Drive', 'Memphis', 'Tennessee', 'United States', '38131', '27');
insert into Address (street, city, state, country, zip, playerId) values ('49008 Hoard Junction', 'Wichita', 'Kansas', 'United States', '67215', '2');
insert into Address (street, city, state, country, zip, playerId) values ('84503 Moulton Junction', 'Jersey City', 'New Jersey', 'United States', '07310', '8');
insert into Address (street, city, state, country, zip, playerId) values ('2 Lukken Way', 'Orlando', 'Florida', 'United States', '32885', '11');
insert into Address (street, city, state, country, zip, playerId) values ('77 Rieder Way', 'Charleston', 'West Virginia', 'United States', '25336', '17');
insert into Address (street, city, state, country, zip, playerId) values ('709 Atwood Street', 'Saint Petersburg', 'Florida', 'United States', '33731', '1');
insert into Address (street, city, state, country, zip, playerId) values ('2 Pond Circle', 'Saint Louis', 'Missouri', 'United States', '63158', '12');
insert into Address (street, city, state, country, zip, playerId) values ('8781 Mallory Park', 'Shawnee Mission', 'Kansas', 'United States', '66276', '39');

insert into PlayerDrinkBridge (drinkId, playerId) values ('46', '2');
insert into PlayerDrinkBridge (drinkId, playerId) values ('33', '9');
insert into PlayerDrinkBridge (drinkId, playerId) values ('23', '34');
insert into PlayerDrinkBridge (drinkId, playerId) values ('22', '47');
insert into PlayerDrinkBridge (drinkId, playerId) values ('19', '1');
insert into PlayerDrinkBridge (drinkId, playerId) values ('20', '24');
insert into PlayerDrinkBridge (drinkId, playerId) values ('48', '43');
insert into PlayerDrinkBridge (drinkId, playerId) values ('42', '16');
insert into PlayerDrinkBridge (drinkId, playerId) values ('10', '48');
insert into PlayerDrinkBridge (drinkId, playerId) values ('31', '28');
insert into PlayerDrinkBridge (drinkId, playerId) values ('41', '49');
insert into PlayerDrinkBridge (drinkId, playerId) values ('25', '44');
insert into PlayerDrinkBridge (drinkId, playerId) values ('27', '31');
insert into PlayerDrinkBridge (drinkId, playerId) values ('24', '10');
insert into PlayerDrinkBridge (drinkId, playerId) values ('13', '7');
insert into PlayerDrinkBridge (drinkId, playerId) values ('34', '33');
insert into PlayerDrinkBridge (drinkId, playerId) values ('39', '19');
insert into PlayerDrinkBridge (drinkId, playerId) values ('35', '26');
insert into PlayerDrinkBridge (drinkId, playerId) values ('36', '38');
insert into PlayerDrinkBridge (drinkId, playerId) values ('17', '32');
insert into PlayerDrinkBridge (drinkId, playerId) values ('43', '25');
insert into PlayerDrinkBridge (drinkId, playerId) values ('49', '36');
insert into PlayerDrinkBridge (drinkId, playerId) values ('50', '42');
insert into PlayerDrinkBridge (drinkId, playerId) values ('18', '40');
insert into PlayerDrinkBridge (drinkId, playerId) values ('11', '18');
insert into PlayerDrinkBridge (drinkId, playerId) values ('12', '46');
insert into PlayerDrinkBridge (drinkId, playerId) values ('16', '20');
insert into PlayerDrinkBridge (drinkId, playerId) values ('5', '4');
insert into PlayerDrinkBridge (drinkId, playerId) values ('44', '50');
insert into PlayerDrinkBridge (drinkId, playerId) values ('2', '22');

insert into Portfolio (num_1, num_5, num_10, num_25, num_100, total_chips_value, playerId) values (1, 6, 4, 10, 3, 621, '29');
insert into Portfolio (num_1, num_5, num_10, num_25, num_100, total_chips_value, playerId) values (5, 9, 1, 8, 9, 1160, '17');
insert into Portfolio (num_1, num_5, num_10, num_25, num_100, total_chips_value, playerId) values (3, 9, 11, 11, 0, 433, '21');
insert into Portfolio (num_1, num_5, num_10, num_25, num_100, total_chips_value, playerId) values (5, 0, 5, 0, 8, 855, '50');
insert into Portfolio (num_1, num_5, num_10, num_25, num_100, total_chips_value, playerId) values (1, 3, 14, 12, 1, 556, '27');
insert into Portfolio (num_1, num_5, num_10, num_25, num_100, total_chips_value, playerId) values (2, 3, 7, 0, 5, 587, '23');
insert into Portfolio (num_1, num_5, num_10, num_25, num_100, total_chips_value, playerId) values (2, 7, 6, 8, 9, 1197, '32');
insert into Portfolio (num_1, num_5, num_10, num_25, num_100, total_chips_value, playerId) values (2, 3, 3, 4, 5, 647, '39');
insert into Portfolio (num_1, num_5, num_10, num_25, num_100, total_chips_value, playerId) values (5, 10, 15, 6, 6, 955, '37');
insert into Portfolio (num_1, num_5, num_10, num_25, num_100, total_chips_value, playerId) values (3, 8, 7, 11, 5, 888, '3');
insert into Portfolio (num_1, num_5, num_10, num_25, num_100, total_chips_value, playerId) values (3, 9, 14, 11, 5, 963, '40');
insert into Portfolio (num_1, num_5, num_10, num_25, num_100, total_chips_value, playerId) values (3, 3, 2, 2, 5, 588, '26');
insert into Portfolio (num_1, num_5, num_10, num_25, num_100, total_chips_value, playerId) values (4, 2, 8, 1, 5, 619, '20');
insert into Portfolio (num_1, num_5, num_10, num_25, num_100, total_chips_value, playerId) values (2, 2, 13, 4, 1, 342, '45');
insert into Portfolio (num_1, num_5, num_10, num_25, num_100, total_chips_value, playerId) values (1, 10, 1, 0, 9, 961, '6');
insert into Portfolio (num_1, num_5, num_10, num_25, num_100, total_chips_value, playerId) values (2, 7, 13, 7, 3, 642, '47');
insert into Portfolio (num_1, num_5, num_10, num_25, num_100, total_chips_value, playerId) values (4, 2, 4, 3, 2, 329, '31');
insert into Portfolio (num_1, num_5, num_10, num_25, num_100, total_chips_value, playerId) values (5, 7, 14, 5, 8, 1105, '5');
insert into Portfolio (num_1, num_5, num_10, num_25, num_100, total_chips_value, playerId) values (3, 10, 14, 10, 6, 1043, '19');
insert into Portfolio (num_1, num_5, num_10, num_25, num_100, total_chips_value, playerId) values (3, 4, 13, 10, 5, 903, '8');
insert into Portfolio (num_1, num_5, num_10, num_25, num_100, total_chips_value, playerId) values (0, 5, 0, 8, 6, 825, '28');
insert into Portfolio (num_1, num_5, num_10, num_25, num_100, total_chips_value, playerId) values (3, 6, 2, 8, 0, 253, '33');
insert into Portfolio (num_1, num_5, num_10, num_25, num_100, total_chips_value, playerId) values (1, 4, 15, 7, 6, 946, '22');
insert into Portfolio (num_1, num_5, num_10, num_25, num_100, total_chips_value, playerId) values (2, 4, 0, 11, 3, 597, '9');
insert into Portfolio (num_1, num_5, num_10, num_25, num_100, total_chips_value, playerId) values (3, 7, 10, 6, 1, 388, '30');
insert into Portfolio (num_1, num_5, num_10, num_25, num_100, total_chips_value, playerId) values (4, 10, 6, 9, 8, 1139, '38');
insert into Portfolio (num_1, num_5, num_10, num_25, num_100, total_chips_value, playerId) values (4, 4, 5, 7, 10, 1249, '44');
insert into Portfolio (num_1, num_5, num_10, num_25, num_100, total_chips_value, playerId) values (3, 10, 14, 2, 0, 243, '48');
insert into Portfolio (num_1, num_5, num_10, num_25, num_100, total_chips_value, playerId) values (0, 6, 14, 8, 5, 870, '14');
insert into Portfolio (num_1, num_5, num_10, num_25, num_100, total_chips_value, playerId) values (1, 6, 8, 6, 7, 961, '1');
insert into Portfolio (num_1, num_5, num_10, num_25, num_100, total_chips_value, playerId) values (4, 7, 4, 3, 6, 754, '36');
insert into Portfolio (num_1, num_5, num_10, num_25, num_100, total_chips_value, playerId) values (3, 9, 13, 10, 3, 728, '43');
insert into Portfolio (num_1, num_5, num_10, num_25, num_100, total_chips_value, playerId) values (2, 0, 6, 7, 7, 937, '49');
insert into Portfolio (num_1, num_5, num_10, num_25, num_100, total_chips_value, playerId) values (2, 3, 13, 7, 0, 322, '24');
insert into Portfolio (num_1, num_5, num_10, num_25, num_100, total_chips_value, playerId) values (4, 3, 7, 12, 1, 489, '41');
insert into Portfolio (num_1, num_5, num_10, num_25, num_100, total_chips_value, playerId) values (2, 7, 1, 3, 2, 322, '34');
insert into Portfolio (num_1, num_5, num_10, num_25, num_100, total_chips_value, playerId) values (3, 4, 10, 5, 7, 948, '35');
insert into Portfolio (num_1, num_5, num_10, num_25, num_100, total_chips_value, playerId) values (0, 4, 13, 9, 6, 975, '10');
insert into Portfolio (num_1, num_5, num_10, num_25, num_100, total_chips_value, playerId) values (1, 5, 15, 11, 4, 851, '15');
insert into Portfolio (num_1, num_5, num_10, num_25, num_100, total_chips_value, playerId) values (2, 7, 14, 6, 9, 1227, '4');
insert into Portfolio (num_1, num_5, num_10, num_25, num_100, total_chips_value, playerId) values (5, 6, 5, 10, 4, 735, '7');
insert into Portfolio (num_1, num_5, num_10, num_25, num_100, total_chips_value, playerId) values (0, 10, 5, 9, 9, 1225, '18');
insert into Portfolio (num_1, num_5, num_10, num_25, num_100, total_chips_value, playerId) values (4, 9, 4, 2, 6, 739, '13');
insert into Portfolio (num_1, num_5, num_10, num_25, num_100, total_chips_value, playerId) values (1, 8, 3, 7, 10, 1246, '42');
insert into Portfolio (num_1, num_5, num_10, num_25, num_100, total_chips_value, playerId) values (2, 8, 4, 0, 1, 182, '16');
insert into Portfolio (num_1, num_5, num_10, num_25, num_100, total_chips_value, playerId) values (5, 0, 9, 6, 1, 345, '25');
insert into Portfolio (num_1, num_5, num_10, num_25, num_100, total_chips_value, playerId) values (1, 5, 13, 5, 5, 781, '2');
insert into Portfolio (num_1, num_5, num_10, num_25, num_100, total_chips_value, playerId) values (3, 7, 7, 3, 8, 983, '46');
insert into Portfolio (num_1, num_5, num_10, num_25, num_100, total_chips_value, playerId) values (5, 8, 8, 12, 8, 1225, '11');
insert into Portfolio (num_1, num_5, num_10, num_25, num_100, total_chips_value, playerId) values (0, 10, 11, 2, 4, 610, '12');

insert into SlotsHistory (timeOfPlay, winLoss) values ('2022-01-28 20:17:56', 96208);
insert into SlotsHistory (timeOfPlay, winLoss) values ('2022-02-28 18:32:07', -51817);
insert into SlotsHistory (timeOfPlay, winLoss) values ('2022-06-11 19:43:23', -98402);
insert into SlotsHistory (timeOfPlay, winLoss) values ('2022-09-20 09:30:29', -31236);
insert into SlotsHistory (timeOfPlay, winLoss) values ('2021-10-12 09:02:33', 14520);
insert into SlotsHistory (timeOfPlay, winLoss) values ('2022-12-26 00:51:08', -163458);
insert into SlotsHistory (timeOfPlay, winLoss) values ('2022-11-12 00:46:30', -119861);
insert into SlotsHistory (timeOfPlay, winLoss) values ('2021-11-18 07:05:16', 36701);
insert into SlotsHistory (timeOfPlay, winLoss) values ('2021-12-01 02:46:37', 40502);
insert into SlotsHistory (timeOfPlay, winLoss) values ('2022-07-11 00:46:28', -97396);
insert into SlotsHistory (timeOfPlay, winLoss) values ('2022-12-14 00:09:39', 50108);
insert into SlotsHistory (timeOfPlay, winLoss) values ('2022-07-08 14:02:24', -175932);
insert into SlotsHistory (timeOfPlay, winLoss) values ('2021-11-28 20:36:28', -117610);
insert into SlotsHistory (timeOfPlay, winLoss) values ('2022-07-24 01:59:51', -9050);
insert into SlotsHistory (timeOfPlay, winLoss) values ('2022-03-18 10:30:47', -1215);
insert into SlotsHistory (timeOfPlay, winLoss) values ('2022-02-27 03:02:48', -75119);
insert into SlotsHistory (timeOfPlay, winLoss) values ('2022-05-28 00:42:06', 78418);
insert into SlotsHistory (timeOfPlay, winLoss) values ('2022-05-03 15:49:10', -144585);
insert into SlotsHistory (timeOfPlay, winLoss) values ('2022-07-17 18:44:11', -111051);
insert into SlotsHistory (timeOfPlay, winLoss) values ('2022-12-06 20:41:48', 48122);
insert into SlotsHistory (timeOfPlay, winLoss) values ('2022-01-02 00:13:40', 42170);
insert into SlotsHistory (timeOfPlay, winLoss) values ('2022-11-21 13:20:38', 71021);
insert into SlotsHistory (timeOfPlay, winLoss) values ('2022-05-26 02:40:55', -134964);
insert into SlotsHistory (timeOfPlay, winLoss) values ('2021-10-07 06:48:46', -38373);
insert into SlotsHistory (timeOfPlay, winLoss) values ('2022-06-16 22:08:05', -132438);
insert into SlotsHistory (timeOfPlay, winLoss) values ('2021-12-16 00:39:02', -53052);
insert into SlotsHistory (timeOfPlay, winLoss) values ('2022-07-12 12:21:59', 66543);
insert into SlotsHistory (timeOfPlay, winLoss) values ('2022-03-30 07:23:00', -157752);
insert into SlotsHistory (timeOfPlay, winLoss) values ('2022-07-12 13:14:59', 33536);
insert into SlotsHistory (timeOfPlay, winLoss) values ('2022-10-20 10:33:54', -21538);
insert into SlotsHistory (timeOfPlay, winLoss) values ('2022-04-29 01:42:32', -70786);
insert into SlotsHistory (timeOfPlay, winLoss) values ('2021-12-11 20:58:12', 89540);
insert into SlotsHistory (timeOfPlay, winLoss) values ('2021-10-09 03:52:11', -119451);
insert into SlotsHistory (timeOfPlay, winLoss) values ('2021-10-24 23:22:32', 47060);
insert into SlotsHistory (timeOfPlay, winLoss) values ('2022-02-20 08:08:44', 60602);
insert into SlotsHistory (timeOfPlay, winLoss) values ('2022-11-18 01:20:08', 50408);
insert into SlotsHistory (timeOfPlay, winLoss) values ('2022-11-05 13:18:43', -45417);
insert into SlotsHistory (timeOfPlay, winLoss) values ('2022-06-22 22:12:35', -111786);
insert into SlotsHistory (timeOfPlay, winLoss) values ('2022-06-29 06:26:44', 10389);
insert into SlotsHistory (timeOfPlay, winLoss) values ('2021-12-16 02:07:42', -131456);
insert into SlotsHistory (timeOfPlay, winLoss) values ('2021-10-30 15:31:54', -83197);
insert into SlotsHistory (timeOfPlay, winLoss) values ('2022-12-11 18:54:49', 58727);
insert into SlotsHistory (timeOfPlay, winLoss) values ('2022-07-28 07:15:16', 67747);
insert into SlotsHistory (timeOfPlay, winLoss) values ('2022-08-26 20:04:52', -167492);
insert into SlotsHistory (timeOfPlay, winLoss) values ('2022-06-04 10:22:30', -35816);
insert into SlotsHistory (timeOfPlay, winLoss) values ('2022-04-26 08:45:54', -152019);
insert into SlotsHistory (timeOfPlay, winLoss) values ('2022-10-17 10:49:32', -72812);
insert into SlotsHistory (timeOfPlay, winLoss) values ('2022-03-10 10:05:45', 20864);
insert into SlotsHistory (timeOfPlay, winLoss) values ('2022-08-30 08:26:36', -147181);
insert into SlotsHistory (timeOfPlay, winLoss) values ('2021-10-28 15:46:17', -148566);

insert into SlotsHistoryBridge (slotId, slotsHistoryId) values ('15', '3');
insert into SlotsHistoryBridge (slotId, slotsHistoryId) values ('5', '4');
insert into SlotsHistoryBridge (slotId, slotsHistoryId) values ('23', '49');
insert into SlotsHistoryBridge (slotId, slotsHistoryId) values ('25', '35');
insert into SlotsHistoryBridge (slotId, slotsHistoryId) values ('47', '20');
insert into SlotsHistoryBridge (slotId, slotsHistoryId) values ('13', '8');
insert into SlotsHistoryBridge (slotId, slotsHistoryId) values ('30', '39');
insert into SlotsHistoryBridge (slotId, slotsHistoryId) values ('4', '25');
insert into SlotsHistoryBridge (slotId, slotsHistoryId) values ('33', '9');
insert into SlotsHistoryBridge (slotId, slotsHistoryId) values ('50', '18');
insert into SlotsHistoryBridge (slotId, slotsHistoryId) values ('49', '11');
insert into SlotsHistoryBridge (slotId, slotsHistoryId) values ('24', '43');
insert into SlotsHistoryBridge (slotId, slotsHistoryId) values ('7', '2');
insert into SlotsHistoryBridge (slotId, slotsHistoryId) values ('39', '34');
insert into SlotsHistoryBridge (slotId, slotsHistoryId) values ('43', '38');
insert into SlotsHistoryBridge (slotId, slotsHistoryId) values ('9', '26');
insert into SlotsHistoryBridge (slotId, slotsHistoryId) values ('48', '10');
insert into SlotsHistoryBridge (slotId, slotsHistoryId) values ('12', '12');
insert into SlotsHistoryBridge (slotId, slotsHistoryId) values ('10', '16');
insert into SlotsHistoryBridge (slotId, slotsHistoryId) values ('44', '33');
insert into SlotsHistoryBridge (slotId, slotsHistoryId) values ('8', '19');
insert into SlotsHistoryBridge (slotId, slotsHistoryId) values ('34', '1');
insert into SlotsHistoryBridge (slotId, slotsHistoryId) values ('42', '29');
insert into SlotsHistoryBridge (slotId, slotsHistoryId) values ('31', '31');
insert into SlotsHistoryBridge (slotId, slotsHistoryId) values ('18', '40');
insert into SlotsHistoryBridge (slotId, slotsHistoryId) values ('29', '46');
insert into SlotsHistoryBridge (slotId, slotsHistoryId) values ('38', '22');
insert into SlotsHistoryBridge (slotId, slotsHistoryId) values ('28', '50');
insert into SlotsHistoryBridge (slotId, slotsHistoryId) values ('16', '24');
insert into SlotsHistoryBridge (slotId, slotsHistoryId) values ('19', '14');
insert into SlotsHistoryBridge (slotId, slotsHistoryId) values ('14', '30');
insert into SlotsHistoryBridge (slotId, slotsHistoryId) values ('2', '37');
insert into SlotsHistoryBridge (slotId, slotsHistoryId) values ('41', '7');
insert into SlotsHistoryBridge (slotId, slotsHistoryId) values ('1', '32');
insert into SlotsHistoryBridge (slotId, slotsHistoryId) values ('35', '23');
insert into SlotsHistoryBridge (slotId, slotsHistoryId) values ('3', '15');
insert into SlotsHistoryBridge (slotId, slotsHistoryId) values ('17', '5');
insert into SlotsHistoryBridge (slotId, slotsHistoryId) values ('20', '17');
insert into SlotsHistoryBridge (slotId, slotsHistoryId) values ('46', '27');
insert into SlotsHistoryBridge (slotId, slotsHistoryId) values ('27', '47');
insert into SlotsHistoryBridge (slotId, slotsHistoryId) values ('37', '28');
insert into SlotsHistoryBridge (slotId, slotsHistoryId) values ('11', '6');
insert into SlotsHistoryBridge (slotId, slotsHistoryId) values ('22', '42');
insert into SlotsHistoryBridge (slotId, slotsHistoryId) values ('21', '21');
insert into SlotsHistoryBridge (slotId, slotsHistoryId) values ('32', '13');
insert into SlotsHistoryBridge (slotId, slotsHistoryId) values ('45', '48');
insert into SlotsHistoryBridge (slotId, slotsHistoryId) values ('26', '44');
insert into SlotsHistoryBridge (slotId, slotsHistoryId) values ('36', '36');
insert into SlotsHistoryBridge (slotId, slotsHistoryId) values ('40', '41');
insert into SlotsHistoryBridge (slotId, slotsHistoryId) values ('6', '45');

insert into TableHistory (timeOfPlay, winLossAmt, tableId) values ('2021-11-01 04:03:03', -577, '8');
insert into TableHistory (timeOfPlay, winLossAmt, tableId) values ('2021-10-31 22:19:45', 212, '3');
insert into TableHistory (timeOfPlay, winLossAmt, tableId) values ('2022-08-09 13:44:13', -161, '6');
insert into TableHistory (timeOfPlay, winLossAmt, tableId) values ('2022-10-14 07:19:28', -89, '10');
insert into TableHistory (timeOfPlay, winLossAmt, tableId) values ('2021-11-15 22:25:26', -8, '9');
insert into TableHistory (timeOfPlay, winLossAmt, tableId) values ('2022-02-15 13:50:01', -510, '2');
insert into TableHistory (timeOfPlay, winLossAmt, tableId) values ('2022-11-13 12:58:16', 483, '1');
insert into TableHistory (timeOfPlay, winLossAmt, tableId) values ('2022-08-18 05:32:20', 412, '5');
insert into TableHistory (timeOfPlay, winLossAmt, tableId) values ('2022-09-24 23:47:27', -648, '7');
insert into TableHistory (timeOfPlay, winLossAmt, tableId) values ('2022-06-15 23:41:02', -244, '4');
insert into TableHistory (timeOfPlay, winLossAmt, tableId) values ('2022-12-13 06:51:59', -383, '2');
insert into TableHistory (timeOfPlay, winLossAmt, tableId) values ('2022-12-08 02:50:17', 729, '3');
insert into TableHistory (timeOfPlay, winLossAmt, tableId) values ('2022-11-21 09:54:12', 452, '6');
insert into TableHistory (timeOfPlay, winLossAmt, tableId) values ('2022-03-26 14:18:12', 426, '10');
insert into TableHistory (timeOfPlay, winLossAmt, tableId) values ('2022-09-05 23:46:28', 801, '7');
insert into TableHistory (timeOfPlay, winLossAmt, tableId) values ('2022-12-29 05:21:59', 804, '8');
insert into TableHistory (timeOfPlay, winLossAmt, tableId) values ('2022-06-19 22:08:55', -714, '9');
insert into TableHistory (timeOfPlay, winLossAmt, tableId) values ('2022-04-20 23:52:34', 299, '5');
insert into TableHistory (timeOfPlay, winLossAmt, tableId) values ('2021-10-08 13:43:30', 326, '4');
insert into TableHistory (timeOfPlay, winLossAmt, tableId) values ('2021-12-01 02:19:30', -864, '1');
insert into TableHistory (timeOfPlay, winLossAmt, tableId) values ('2022-08-03 09:14:07', -962, '3');
insert into TableHistory (timeOfPlay, winLossAmt, tableId) values ('2022-03-05 00:39:49', -887, '5');
insert into TableHistory (timeOfPlay, winLossAmt, tableId) values ('2022-12-02 13:28:39', 691, '1');
insert into TableHistory (timeOfPlay, winLossAmt, tableId) values ('2022-01-21 22:41:16', -154, '8');
insert into TableHistory (timeOfPlay, winLossAmt, tableId) values ('2022-01-06 04:06:52', 310, '7');
insert into TableHistory (timeOfPlay, winLossAmt, tableId) values ('2022-09-06 20:46:23', -969, '4');
insert into TableHistory (timeOfPlay, winLossAmt, tableId) values ('2022-08-17 01:33:54', -685, '9');
insert into TableHistory (timeOfPlay, winLossAmt, tableId) values ('2021-10-14 00:42:17', 564, '2');
insert into TableHistory (timeOfPlay, winLossAmt, tableId) values ('2022-06-16 04:32:31', -747, '6');
insert into TableHistory (timeOfPlay, winLossAmt, tableId) values ('2022-08-29 07:06:47', -210, '10');
insert into TableHistory (timeOfPlay, winLossAmt, tableId) values ('2022-01-02 06:55:19', 826, '9');
insert into TableHistory (timeOfPlay, winLossAmt, tableId) values ('2021-10-09 03:35:14', -572, '2');
insert into TableHistory (timeOfPlay, winLossAmt, tableId) values ('2021-10-19 11:32:53', 784, '8');
insert into TableHistory (timeOfPlay, winLossAmt, tableId) values ('2022-04-10 21:14:23', 988, '1');
insert into TableHistory (timeOfPlay, winLossAmt, tableId) values ('2022-11-23 20:55:40', -96, '3');
insert into TableHistory (timeOfPlay, winLossAmt, tableId) values ('2022-01-10 00:16:18', -908, '4');
insert into TableHistory (timeOfPlay, winLossAmt, tableId) values ('2022-09-03 20:53:43', -385, '10');
insert into TableHistory (timeOfPlay, winLossAmt, tableId) values ('2022-05-23 09:33:25', 311, '7');
insert into TableHistory (timeOfPlay, winLossAmt, tableId) values ('2021-10-14 11:59:19', -890, '5');
insert into TableHistory (timeOfPlay, winLossAmt, tableId) values ('2022-09-12 15:55:43', -564, '6');
insert into TableHistory (timeOfPlay, winLossAmt, tableId) values ('2022-04-15 15:10:20', 157, '5');
insert into TableHistory (timeOfPlay, winLossAmt, tableId) values ('2022-09-16 15:25:33', 395, '1');
insert into TableHistory (timeOfPlay, winLossAmt, tableId) values ('2022-01-17 04:20:06', 236, '9');
insert into TableHistory (timeOfPlay, winLossAmt, tableId) values ('2022-07-02 13:09:08', -188, '4');
insert into TableHistory (timeOfPlay, winLossAmt, tableId) values ('2022-10-25 07:23:56', -199, '2');
insert into TableHistory (timeOfPlay, winLossAmt, tableId) values ('2022-01-21 19:36:39', 502, '3');
insert into TableHistory (timeOfPlay, winLossAmt, tableId) values ('2022-09-11 03:57:07', 704, '8');
insert into TableHistory (timeOfPlay, winLossAmt, tableId) values ('2022-04-25 19:30:42', -854, '7');
insert into TableHistory (timeOfPlay, winLossAmt, tableId) values ('2021-12-20 03:32:22', -198, '6');
insert into TableHistory (timeOfPlay, winLossAmt, tableId) values ('2022-08-05 01:08:33', 156, '10');

insert into TableHistoryBridge (tableId, tableHistoryId) values ('4', '25');
insert into TableHistoryBridge (tableId, tableHistoryId) values ('10', '37');
insert into TableHistoryBridge (tableId, tableHistoryId) values ('3', '14');
insert into TableHistoryBridge (tableId, tableHistoryId) values ('2', '49');
insert into TableHistoryBridge (tableId, tableHistoryId) values ('5', '31');
insert into TableHistoryBridge (tableId, tableHistoryId) values ('7', '45');
insert into TableHistoryBridge (tableId, tableHistoryId) values ('6', '32');
insert into TableHistoryBridge (tableId, tableHistoryId) values ('9', '12');
insert into TableHistoryBridge (tableId, tableHistoryId) values ('1', '13');
insert into TableHistoryBridge (tableId, tableHistoryId) values ('8', '9');
insert into TableHistoryBridge (tableId, tableHistoryId) values ('10', '8');
insert into TableHistoryBridge (tableId, tableHistoryId) values ('6', '39');
insert into TableHistoryBridge (tableId, tableHistoryId) values ('4', '48');
insert into TableHistoryBridge (tableId, tableHistoryId) values ('7', '5');
insert into TableHistoryBridge (tableId, tableHistoryId) values ('9', '28');
insert into TableHistoryBridge (tableId, tableHistoryId) values ('3', '47');
insert into TableHistoryBridge (tableId, tableHistoryId) values ('5', '22');
insert into TableHistoryBridge (tableId, tableHistoryId) values ('1', '36');
insert into TableHistoryBridge (tableId, tableHistoryId) values ('8', '4');
insert into TableHistoryBridge (tableId, tableHistoryId) values ('2', '20');
insert into TableHistoryBridge (tableId, tableHistoryId) values ('5', '33');
insert into TableHistoryBridge (tableId, tableHistoryId) values ('7', '15');
insert into TableHistoryBridge (tableId, tableHistoryId) values ('4', '38');
insert into TableHistoryBridge (tableId, tableHistoryId) values ('9', '7');
insert into TableHistoryBridge (tableId, tableHistoryId) values ('2', '11');
insert into TableHistoryBridge (tableId, tableHistoryId) values ('6', '44');
insert into TableHistoryBridge (tableId, tableHistoryId) values ('3', '1');
insert into TableHistoryBridge (tableId, tableHistoryId) values ('1', '21');
insert into TableHistoryBridge (tableId, tableHistoryId) values ('8', '43');
insert into TableHistoryBridge (tableId, tableHistoryId) values ('10', '27');
insert into TableHistoryBridge (tableId, tableHistoryId) values ('1', '18');
insert into TableHistoryBridge (tableId, tableHistoryId) values ('2', '46');
insert into TableHistoryBridge (tableId, tableHistoryId) values ('9', '29');
insert into TableHistoryBridge (tableId, tableHistoryId) values ('5', '17');
insert into TableHistoryBridge (tableId, tableHistoryId) values ('8', '40');
insert into TableHistoryBridge (tableId, tableHistoryId) values ('7', '24');
insert into TableHistoryBridge (tableId, tableHistoryId) values ('4', '23');
insert into TableHistoryBridge (tableId, tableHistoryId) values ('3', '6');
insert into TableHistoryBridge (tableId, tableHistoryId) values ('6', '2');
insert into TableHistoryBridge (tableId, tableHistoryId) values ('10', '30');
insert into TableHistoryBridge (tableId, tableHistoryId) values ('9', '3');
insert into TableHistoryBridge (tableId, tableHistoryId) values ('8', '19');
insert into TableHistoryBridge (tableId, tableHistoryId) values ('10', '42');
insert into TableHistoryBridge (tableId, tableHistoryId) values ('1', '34');
insert into TableHistoryBridge (tableId, tableHistoryId) values ('5', '16');
insert into TableHistoryBridge (tableId, tableHistoryId) values ('7', '41');
insert into TableHistoryBridge (tableId, tableHistoryId) values ('2', '10');
insert into TableHistoryBridge (tableId, tableHistoryId) values ('6', '50');
insert into TableHistoryBridge (tableId, tableHistoryId) values ('4', '26');
insert into TableHistoryBridge (tableId, tableHistoryId) values ('3', '35');

insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-08-22 18:30:23', 9729, 'DEPOSIT', '7');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-11-14 10:02:53', 4945, 'WITHDRAWAL', '10');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2021-10-11 11:23:21', 9162, 'WITHDRAWAL', '42');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-07-06 10:31:12', 5537, 'DEPOSIT', '9');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-03-18 20:54:17', 3317, 'WITHDRAWAL', '40');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2021-10-29 18:14:50', 1837, 'DEPOSIT', '48');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2021-11-04 07:22:07', 8034, 'WITHDRAWAL', '46');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-07-06 15:27:00', 6023, 'WITHDRAWAL', '25');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-12-09 03:50:51', 9960, 'DEPOSIT', '16');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-02-18 14:05:01', 3741, 'DEPOSIT', '41');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-08-21 03:16:16', 753, 'WITHDRAWAL', '50');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-07-05 03:07:05', 4817, 'DEPOSIT', '1');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-07-25 09:55:32', 1060, 'WITHDRAWAL', '13');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-12-07 04:14:42', 3029, 'WITHDRAWAL', '18');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2021-10-24 22:09:02', 8377, 'WITHDRAWAL', '22');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-11-29 22:54:16', 1269, 'WITHDRAWAL', '21');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-01-31 07:43:13', 4238, 'WITHDRAWAL', '23');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-10-16 20:00:58', 612, 'WITHDRAWAL', '11');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-11-14 19:23:58', 6602, 'DEPOSIT', '2');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-02-27 20:20:03', 8390, 'WITHDRAWAL', '33');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-05-04 12:50:16', 7108, 'WITHDRAWAL', '45');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-07-12 14:51:56', 1642, 'DEPOSIT', '17');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-02-27 03:45:24', 7387, 'WITHDRAWAL', '36');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-06-29 09:58:02', 1958, 'DEPOSIT', '31');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2021-12-23 19:29:13', 4037, 'DEPOSIT', '34');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-01-26 18:36:34', 8019, 'WITHDRAWAL', '24');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2021-12-17 17:45:15', 1439, 'DEPOSIT', '15');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-12-31 16:53:08', 4227, 'DEPOSIT', '3');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-06-26 00:33:06', 8837, 'DEPOSIT', '38');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2021-10-02 17:55:59', 154, 'DEPOSIT', '20');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-05-07 12:33:52', 4700, 'WITHDRAWAL', '29');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-11-17 00:51:23', 167, 'DEPOSIT', '47');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-08-27 20:34:54', 3074, 'WITHDRAWAL', '30');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-03-03 14:02:07', 1456, 'WITHDRAWAL', '4');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-09-01 04:43:28', 3694, 'WITHDRAWAL', '27');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-10-07 18:07:33', 1844, 'WITHDRAWAL', '43');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-02-14 21:24:06', 6011, 'WITHDRAWAL', '5');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2021-10-07 00:11:46', 4373, 'DEPOSIT', '12');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-03-15 16:27:37', 919, 'DEPOSIT', '39');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2021-11-06 22:10:05', 91, 'WITHDRAWAL', '35');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-07-27 20:34:21', 5819, 'DEPOSIT', '8');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-12-01 07:38:13', 425, 'WITHDRAWAL', '19');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-04-25 12:18:11', 9685, 'WITHDRAWAL', '32');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-12-28 07:37:04', 4546, 'DEPOSIT', '28');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-12-20 15:46:56', 247, 'WITHDRAWAL', '14');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-03-27 05:17:15', 2045, 'WITHDRAWAL', '6');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-07-14 15:08:56', 6863, 'DEPOSIT', '49');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-07-10 18:32:45', 8380, 'DEPOSIT', '37');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-03-08 08:39:02', 7494, 'DEPOSIT', '44');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-06-27 16:02:08', 5522, 'WITHDRAWAL', '26');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-12-26 10:54:03', 843, 'WITHDRAWAL', '2');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-02-02 01:38:06', 9193, 'DEPOSIT', '11');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-01-14 05:35:25', 3947, 'WITHDRAWAL', '10');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2021-10-29 03:29:11', 7826, 'WITHDRAWAL', '38');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2021-10-23 05:09:58', 3842, 'DEPOSIT', '1');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-10-06 14:20:09', 8951, 'DEPOSIT', '27');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-03-16 08:06:14', 7313, 'WITHDRAWAL', '29');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2021-10-31 01:15:09', 6651, 'DEPOSIT', '8');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-06-01 08:07:29', 4004, 'WITHDRAWAL', '26');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-07-05 23:38:09', 8535, 'WITHDRAWAL', '13');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-01-09 15:18:42', 7246, 'DEPOSIT', '9');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-12-17 09:10:10', 9245, 'DEPOSIT', '17');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-01-11 11:42:41', 8411, 'DEPOSIT', '41');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-04-07 09:50:09', 189, 'DEPOSIT', '45');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-05-10 09:05:21', 6214, 'DEPOSIT', '14');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2021-12-07 22:44:07', 764, 'DEPOSIT', '40');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-10-14 23:46:04', 4279, 'DEPOSIT', '28');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-09-07 22:23:58', 8526, 'DEPOSIT', '19');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-02-02 16:28:08', 3239, 'DEPOSIT', '7');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2021-10-01 04:10:29', 5025, 'DEPOSIT', '43');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-05-02 12:27:42', 5530, 'DEPOSIT', '5');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-07-15 05:48:53', 3653, 'WITHDRAWAL', '39');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2021-10-17 10:44:18', 7716, 'WITHDRAWAL', '16');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-05-17 14:50:16', 4617, 'WITHDRAWAL', '15');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-02-27 10:46:24', 603, 'DEPOSIT', '6');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-10-23 00:48:56', 1566, 'WITHDRAWAL', '32');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2021-10-22 01:40:20', 6173, 'WITHDRAWAL', '18');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-10-23 21:35:19', 4689, 'DEPOSIT', '49');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2021-11-09 13:46:15', 2543, 'DEPOSIT', '33');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-07-31 22:21:49', 777, 'WITHDRAWAL', '37');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-02-16 06:11:12', 3393, 'DEPOSIT', '22');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-09-27 22:35:10', 4263, 'DEPOSIT', '44');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-08-03 01:23:53', 3380, 'DEPOSIT', '36');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-08-14 08:52:42', 4034, 'WITHDRAWAL', '47');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-12-14 06:37:25', 5050, 'WITHDRAWAL', '24');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2021-11-02 21:33:15', 504, 'WITHDRAWAL', '23');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-05-11 16:38:37', 9070, 'WITHDRAWAL', '12');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-03-22 11:52:21', 4038, 'WITHDRAWAL', '34');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-04-07 20:06:27', 3582, 'WITHDRAWAL', '31');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-11-28 17:31:48', 5956, 'WITHDRAWAL', '30');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-05-02 18:21:14', 5129, 'WITHDRAWAL', '4');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-04-27 17:08:22', 5209, 'DEPOSIT', '46');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-08-13 23:57:08', 9415, 'WITHDRAWAL', '35');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2021-11-02 06:30:00', 9277, 'WITHDRAWAL', '20');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2021-11-08 18:41:13', 438, 'WITHDRAWAL', '3');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2021-10-01 23:34:01', 4933, 'WITHDRAWAL', '25');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-05-02 19:03:14', 1028, 'DEPOSIT', '50');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2021-11-22 00:14:54', 4754, 'WITHDRAWAL', '21');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2021-12-30 18:55:36', 5858, 'DEPOSIT', '42');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-09-23 20:10:14', 9535, 'DEPOSIT', '48');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-03-18 20:32:23', 8442, 'DEPOSIT', '7');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2021-11-07 07:53:52', 1556, 'WITHDRAWAL', '35');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-08-14 11:12:16', 7408, 'WITHDRAWAL', '44');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-02-26 00:22:33', 7677, 'DEPOSIT', '13');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-09-25 16:25:05', 9165, 'WITHDRAWAL', '11');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-12-12 05:54:49', 3126, 'WITHDRAWAL', '27');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-06-23 01:50:33', 1085, 'DEPOSIT', '37');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2021-11-16 09:13:43', 3584, 'WITHDRAWAL', '39');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-05-07 10:04:54', 8167, 'DEPOSIT', '8');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-04-06 23:54:16', 4127, 'DEPOSIT', '40');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2021-12-13 12:10:53', 3491, 'WITHDRAWAL', '30');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-12-12 16:42:34', 6202, 'DEPOSIT', '34');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-05-22 07:43:39', 5197, 'WITHDRAWAL', '47');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-12-10 20:26:39', 159, 'DEPOSIT', '18');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-06-08 20:18:43', 6088, 'DEPOSIT', '46');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-11-23 13:17:32', 445, 'DEPOSIT', '10');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-03-19 11:01:57', 528, 'WITHDRAWAL', '20');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-01-05 14:41:52', 7840, 'DEPOSIT', '33');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-01-15 10:58:02', 2982, 'WITHDRAWAL', '42');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-07-21 18:39:31', 3070, 'DEPOSIT', '28');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-10-21 07:14:37', 6505, 'WITHDRAWAL', '2');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-03-25 04:30:07', 7693, 'DEPOSIT', '38');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-07-02 01:13:33', 3271, 'DEPOSIT', '15');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-05-25 17:11:11', 8299, 'DEPOSIT', '4');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-04-07 00:25:59', 4869, 'WITHDRAWAL', '36');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-08-29 09:24:01', 1067, 'DEPOSIT', '9');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-11-22 10:39:48', 9527, 'WITHDRAWAL', '6');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-12-21 00:03:36', 676, 'WITHDRAWAL', '14');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-06-02 15:03:57', 1908, 'DEPOSIT', '21');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2021-10-05 09:59:14', 7957, 'DEPOSIT', '3');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-12-12 01:56:41', 4912, 'WITHDRAWAL', '1');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-10-14 12:32:21', 232, 'DEPOSIT', '41');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-05-16 05:10:31', 8326, 'DEPOSIT', '29');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-03-01 15:08:05', 8552, 'WITHDRAWAL', '31');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-09-27 08:35:41', 6214, 'DEPOSIT', '25');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-06-19 11:23:35', 6272, 'DEPOSIT', '26');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-02-08 02:59:47', 6191, 'WITHDRAWAL', '17');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-05-12 10:15:10', 8473, 'WITHDRAWAL', '19');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-10-12 03:21:32', 9317, 'WITHDRAWAL', '12');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-09-03 01:47:10', 2292, 'WITHDRAWAL', '43');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-04-11 01:35:42', 8959, 'DEPOSIT', '50');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-04-17 14:57:47', 8461, 'WITHDRAWAL', '48');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-12-31 00:26:34', 6807, 'DEPOSIT', '24');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-09-04 21:45:38', 5476, 'DEPOSIT', '5');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-02-03 23:11:04', 1673, 'DEPOSIT', '49');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2021-11-24 13:30:45', 3120, 'WITHDRAWAL', '22');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2021-11-13 21:53:37', 74, 'DEPOSIT', '45');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-02-05 22:38:18', 8775, 'DEPOSIT', '32');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2021-11-13 10:23:08', 8837, 'WITHDRAWAL', '16');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-03-16 13:46:55', 2239, 'DEPOSIT', '23');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-05-13 09:31:55', 3595, 'WITHDRAWAL', '36');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2021-11-01 05:41:54', 1119, 'DEPOSIT', '42');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2021-12-29 06:44:14', 7747, 'DEPOSIT', '39');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-07-12 11:36:57', 9404, 'DEPOSIT', '10');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-08-06 11:24:16', 4981, 'WITHDRAWAL', '19');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-05-05 04:50:50', 5880, 'WITHDRAWAL', '49');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-05-12 04:03:50', 7919, 'DEPOSIT', '28');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-12-20 10:09:35', 2587, 'DEPOSIT', '21');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-02-19 17:13:00', 6507, 'WITHDRAWAL', '41');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-12-30 03:51:11', 5673, 'WITHDRAWAL', '15');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2021-11-23 05:55:47', 2346, 'DEPOSIT', '11');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-07-15 19:54:10', 898, 'WITHDRAWAL', '5');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2021-12-22 10:32:13', 7238, 'DEPOSIT', '50');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2021-12-07 03:26:45', 268, 'WITHDRAWAL', '44');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2021-12-18 21:09:31', 7675, 'WITHDRAWAL', '25');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2021-11-08 04:20:07', 9558, 'WITHDRAWAL', '22');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-06-28 22:03:02', 5810, 'WITHDRAWAL', '48');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-11-05 03:24:23', 6725, 'DEPOSIT', '46');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-09-12 11:37:48', 8892, 'WITHDRAWAL', '12');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-02-20 23:33:59', 8161, 'DEPOSIT', '2');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-06-12 20:20:39', 1273, 'DEPOSIT', '31');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-07-29 09:40:28', 7221, 'WITHDRAWAL', '17');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-07-31 14:10:00', 3575, 'DEPOSIT', '4');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-12-27 09:50:25', 3648, 'WITHDRAWAL', '33');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-03-20 18:26:59', 3978, 'DEPOSIT', '24');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-02-11 22:22:07', 7366, 'WITHDRAWAL', '1');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-08-12 04:22:54', 7545, 'DEPOSIT', '23');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-07-05 04:43:35', 1833, 'DEPOSIT', '14');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-06-02 11:21:24', 7673, 'DEPOSIT', '45');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-08-23 08:39:56', 2052, 'WITHDRAWAL', '9');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2021-12-11 06:19:58', 8584, 'WITHDRAWAL', '26');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2021-11-11 00:39:50', 5365, 'WITHDRAWAL', '47');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-10-23 09:00:54', 5139, 'WITHDRAWAL', '20');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-02-24 12:19:33', 5552, 'WITHDRAWAL', '40');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-12-12 23:05:38', 633, 'WITHDRAWAL', '3');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-09-13 07:36:55', 6695, 'DEPOSIT', '13');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-04-20 19:17:28', 7270, 'WITHDRAWAL', '18');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-01-23 09:50:55', 3865, 'WITHDRAWAL', '6');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-09-17 05:42:42', 7492, 'WITHDRAWAL', '7');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-06-05 14:42:09', 4896, 'DEPOSIT', '8');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-06-02 01:10:28', 5868, 'WITHDRAWAL', '38');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2021-11-28 00:58:38', 363, 'DEPOSIT', '34');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-02-26 17:40:14', 5274, 'DEPOSIT', '29');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-03-20 09:32:39', 6474, 'WITHDRAWAL', '30');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-10-26 15:45:16', 5140, 'DEPOSIT', '37');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-11-02 10:15:49', 8580, 'WITHDRAWAL', '43');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-07-11 12:18:02', 522, 'WITHDRAWAL', '35');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-03-05 14:28:54', 569, 'DEPOSIT', '27');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-03-18 10:46:17', 705, 'WITHDRAWAL', '16');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-10-10 06:25:30', 1127, 'DEPOSIT', '32');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2021-12-26 18:41:40', 1233, 'WITHDRAWAL', '28');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-11-12 15:25:25', 1523, 'WITHDRAWAL', '42');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-12-12 04:30:20', 9509, 'DEPOSIT', '6');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-02-13 03:39:54', 4981, 'WITHDRAWAL', '3');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-06-07 13:54:18', 4094, 'WITHDRAWAL', '22');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-11-30 14:06:19', 4734, 'DEPOSIT', '40');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-01-09 02:20:59', 9531, 'WITHDRAWAL', '25');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-10-01 22:53:47', 2671, 'WITHDRAWAL', '44');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-01-13 18:33:01', 8756, 'DEPOSIT', '14');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-05-26 09:42:35', 9471, 'WITHDRAWAL', '45');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-12-02 02:34:17', 3985, 'WITHDRAWAL', '32');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-02-02 06:25:12', 3035, 'DEPOSIT', '9');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-02-20 14:08:36', 2608, 'DEPOSIT', '39');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-03-22 21:37:54', 8138, 'WITHDRAWAL', '2');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-01-04 13:25:05', 1747, 'DEPOSIT', '48');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-05-30 04:57:27', 6283, 'WITHDRAWAL', '12');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-04-24 07:01:20', 32, 'WITHDRAWAL', '34');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-10-15 00:33:56', 5959, 'WITHDRAWAL', '30');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-11-22 04:24:25', 2616, 'WITHDRAWAL', '16');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-01-13 06:23:57', 9859, 'WITHDRAWAL', '23');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-07-03 18:46:17', 1784, 'DEPOSIT', '26');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-11-19 16:45:29', 5810, 'DEPOSIT', '41');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-07-11 05:17:17', 319, 'DEPOSIT', '4');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-09-18 06:31:49', 8094, 'WITHDRAWAL', '1');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-09-18 05:56:47', 2021, 'DEPOSIT', '50');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-08-23 03:49:31', 4632, 'DEPOSIT', '21');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-05-20 03:04:37', 4358, 'WITHDRAWAL', '37');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-12-09 14:32:53', 2357, 'DEPOSIT', '35');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-01-20 18:09:58', 9669, 'WITHDRAWAL', '36');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-01-31 06:10:35', 1646, 'DEPOSIT', '43');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-12-08 11:35:08', 3836, 'DEPOSIT', '13');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-08-19 03:36:07', 6269, 'WITHDRAWAL', '20');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2021-11-09 05:30:05', 5905, 'DEPOSIT', '31');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-04-29 21:43:53', 434, 'DEPOSIT', '10');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-05-15 18:28:05', 8302, 'WITHDRAWAL', '47');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-04-09 06:36:35', 3194, 'DEPOSIT', '49');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-05-13 07:30:25', 1510, 'WITHDRAWAL', '11');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-07-21 05:42:24', 9002, 'DEPOSIT', '38');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-10-16 20:35:28', 4512, 'DEPOSIT', '7');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-08-29 22:38:20', 4291, 'WITHDRAWAL', '27');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-08-15 23:18:56', 5620, 'WITHDRAWAL', '29');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-09-16 14:53:28', 378, 'DEPOSIT', '24');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-10-23 13:38:16', 197, 'DEPOSIT', '15');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-01-15 18:08:27', 6541, 'DEPOSIT', '8');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-12-26 13:35:11', 5675, 'DEPOSIT', '19');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-01-30 09:43:58', 2308, 'DEPOSIT', '33');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-03-08 14:46:39', 1649, 'WITHDRAWAL', '5');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-11-11 22:56:38', 5225, 'WITHDRAWAL', '18');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2022-10-29 18:12:33', 4261, 'DEPOSIT', '46');
insert into Transactions (timeOfTransaction, amount, type, playerId) values ('2021-10-24 21:14:19', 6327, 'WITHDRAWAL', '17');
