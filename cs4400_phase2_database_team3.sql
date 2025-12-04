-- CS4400: Introduction to Database Systems (Fall 2025)
-- Phase II: Create Table & Insert Statements [v0] Monday, September 15, 2025 @ 17:00 EST

-- Team 3
-- Daniel Huang (dhuang332)
-- Albert Ying (aying9)
-- Tong Wu (twu465)

-- Directions:
-- Please follow all instructions for Phase II as listed in the instructions document.
-- Fill in the team number and names and GT usernames for all members above.
-- Create Table statements must be manually written, not taken from a SQL Dump file.
-- This file must run without error for credit.

/* This is a standard preamble for most of our scripts.  The intent is to establish
a consistent environment for the database behavior. */
set global transaction isolation level serializable;
set global SQL_MODE = 'ANSI,TRADITIONAL';
set names utf8mb4;
set SQL_SAFE_UPDATES = 0;

set @thisDatabase = 'er_management';
drop database if exists er_management;
create database if not exists er_management;
use er_management;

-- Define the database structures
/* You must enter your tables definitions (with primary, unique, and foreign key declarations,
data types, and check constraints) and data insertion statements here.  You may sequence them in
any order that works for you (and runs successfully).  When executed, your statements must create 
a functional database that contains all of the data and supports as many of the constraints as possible. */

CREATE TABLE Person (
	ssn			CHAR(11) 		PRIMARY KEY,
    firstName	VARCHAR(50)		NOT NULL,
    lastName	VARCHAR(50)		NOT NULL,
    birthdate	DATE			NOT NULL,
    address		VARCHAR(200)	NOT NULL
);

CREATE TABLE Staff (
	staffID		VARCHAR(6)	PRIMARY KEY,
    ssn			CHAR(11)	NOT NULL UNIQUE REFERENCES Person(ssn)
        ON UPDATE RESTRICT ON DELETE CASCADE,
    salary		INT			NOT NULL,
    hireDate	DATE		NOT NULL
);

CREATE TABLE Doctor (
	licenseNumber	VARCHAR(5)	PRIMARY KEY,
    staffID			VARCHAR(6)	NOT NULL UNIQUE REFERENCES Staff(staffID)
        ON UPDATE RESTRICT ON DELETE CASCADE,
    experience		INT			NOT NULL
);

CREATE TABLE Nurse (
	staffID			VARCHAR(6)	PRIMARY KEY REFERENCES Staff(staffID)
        ON UPDATE RESTRICT ON DELETE CASCADE,
	shiftType		VARCHAR(10)	NOT NULL,
    regExpiration	DATE		NOT NULL
);


CREATE TABLE Department (
	deptID		INT				PRIMARY KEY,
    name		VARCHAR(20)		NOT NULL,
    managerID	VARCHAR(6)		NOT NULL UNIQUE REFERENCES Staff(staffID)
        ON UPDATE RESTRICT ON DELETE RESTRICT
);

CREATE TABLE WorksIn (
	staffID		VARCHAR(6)	NOT NULL REFERENCES Staff(staffID)
        ON UPDATE RESTRICT ON DELETE CASCADE,
	deptID		INT			NOT NULL REFERENCES Department(deptID)
        ON UPDATE RESTRICT ON DELETE CASCADE,
    PRIMARY KEY (staffID, deptID)
);


CREATE TABLE Room (
	number		INT			PRIMARY KEY,
    type		VARCHAR(20)	NOT NULL,
    deptID		INT			NOT NULL REFERENCES Department(deptID)
        ON UPDATE RESTRICT ON DELETE RESTRICT
);

CREATE TABLE Assigned (
	roomNumber	INT			NOT NULL REFERENCES Room(number)
        ON UPDATE RESTRICT ON DELETE CASCADE,
    staffID		VARCHAR(6)	NOT NULL REFERENCES Nurse(staffID)
        ON UPDATE RESTRICT ON DELETE CASCADE,
    PRIMARY KEY (roomNumber, staffID)
);


CREATE TABLE Patient (
	ssn			CHAR(11)	PRIMARY KEY REFERENCES Person(ssn)
        ON UPDATE RESTRICT ON DELETE CASCADE,
    contact		CHAR(12)	NOT NULL,
    funds		INT			NOT NULL,
    roomNumber	INT			UNIQUE REFERENCES Room(number)
        ON UPDATE RESTRICT ON DELETE RESTRICT
);


CREATE TABLE Appointment (
	patientSsn	CHAR(11)	NOT NULL REFERENCES Patient(ssn)
        ON UPDATE RESTRICT ON DELETE RESTRICT,
    date		DATE		NOT NULL,
    time		TIME		NOT NULL,
    cost		INT			NOT NULL,
    PRIMARY KEY (patientSsn, date, time)
);

CREATE TABLE Symptom (
    patientSsn	CHAR(11)	NOT NULL,
    date		DATE		NOT NULL,
    time		TIME		NOT NULL,
    type		VARCHAR(50)	NOT NULL,
    numDays		INT			NOT NULL,
    PRIMARY KEY (patientSsn, date, time, type),
    FOREIGN KEY (patientSsn, date, time)
        REFERENCES Appointment(patientSsn, date, time)
        ON UPDATE CASCADE ON DELETE CASCADE,
	CHECK (numDays > 0)
);


CREATE TABLE ScheduledFor (
	patientSsn		CHAR(11)	NOT NULL,
    date			DATE		NOT NULL,
    time			TIME		NOT NULL,
	licenseNumber	VARCHAR(5)	NOT NULL REFERENCES Doctor(licenseNumber)
        ON UPDATE RESTRICT ON DELETE RESTRICT,
    PRIMARY KEY (patientSsn, date, time, licenseNumber),
	UNIQUE (date, time, licenseNumber),
    FOREIGN KEY (patientSsn, date, time) REFERENCES Appointment(patientSsn, date, time)
        ON UPDATE CASCADE ON DELETE CASCADE
);


CREATE TABLE PatientOrder (
	orderNumber		INT			PRIMARY KEY AUTO_INCREMENT,
    patientSsn		CHAR(11)	NOT NULL REFERENCES Patient(ssn)
        ON UPDATE RESTRICT ON DELETE RESTRICT,
    licenseNumber	VARCHAR(5)	NOT NULL REFERENCES Doctor(licenseNumber)
        ON UPDATE RESTRICT ON DELETE RESTRICT,
    priority		INT			NOT NULL,
    date			DATE		NOT NULL,
    cost			INT			NOT NULL,
    CHECK (priority between 1 and 5)
);

CREATE TABLE Prescription (
	orderNumber		INT			PRIMARY KEY REFERENCES PatientOrder(orderNumber)
        ON UPDATE RESTRICT ON DELETE CASCADE,
    drugType		VARCHAR(50)	NOT NULL,
    dosageMg		INT			NOT NULL
);

CREATE TABLE LabWork (
	orderNumber		INT			PRIMARY KEY REFERENCES PatientOrder(orderNumber)
        ON UPDATE RESTRICT ON DELETE CASCADE,
    type			VARCHAR(50)	NOT NULL
);


INSERT INTO Person (ssn, firstName, lastName, birthdate, address) VALUES
('909-10-1111', 'Maria', 'Alvarez', '1987-03-22', '81 Peachtree Pl NE, Atlanta, GA 30309'),
('323-44-5555', 'Marcus', 'Lee', '1979-12-11', '1420 Oak Terrace, Decatur, GA 30030'),
('123-45-6789', 'Christopher', 'Davis', '1965-02-25', '1234 Peach Street, Atlanta, GA 30305'),
('636-77-8888', 'Olivia', 'Bennett', '1970-01-01', '950 W Peachtree, Atlanta, GA 30308'),
('858-99-0000', 'Chloe', 'Davis', '1975-06-24', '500 North Ave, Atlanta, GA 30302'),
('969-00-1112', 'Liam', 'Foster', '1980-12-14', '670 Piedmont Ave, Atlanta, GA 30303'),
('212-33-4444', 'Priya', 'Shah', '1986-06-06', '1000 Howell Mill Rd, Atlanta, GA 30303'),
('101-22-3030', 'Emily', 'Park', '1997-05-19', '848 Spring St NW, Atlanta, GA 30308'),
('454-66-7777', 'Omar', 'Haddad', '1980-05-01', '108 Main St, Atlanta, GA 30308'),
('888-77-6666', 'Sarah', 'Mitchell', '1975-06-10', '742 Maple Avenue, Decatur, GA 30030'),
('135-79-0000', 'David', 'Thompson', '1980-08-15', '925 Brookside Drive, Marietta, GA 30062'),
('204-60-8010', 'Laura', 'Chen', '1978-04-22', '488 Willow Creek Lane, Johns Creek, GA 30097'),
('987-65-4321', 'Matthew', 'Nguyen', '1970-03-01', '3100 Briarcliff Road, Atlanta, GA 30329'),
('300-40-5000', 'David', 'Taylor', '1985-01-10', '124 Oakwood Circle, Smyrna, GA 30080'),
('800-50-7676', 'Ethan', 'Brooks', '1987-07-18', '275 Pine Hollow Drive, Roswell, GA 30075'),
('103-05-7090', 'Hannah', 'Wilson', '1990-09-25', '889 Laurel Springs Lane, Alpharetta, GA 30022');

INSERT INTO Staff (staffID, ssn, salary, hireDate) VALUES
('720301', '636-77-8888', 92000, '2023-02-01'),
('720303', '858-99-0000', 93500, '2021-11-30'),
('720304', '969-00-1112', 90500, '2020-08-20'),
('510201', '212-33-4444', 265000, '2016-08-19'),
('510202', '323-44-5555', 238000, '2019-09-03'),
('510203', '101-22-3030', 312000, '2014-02-27'),
('510204', '454-66-7777', 328000, '2012-11-05'),
('107435', '888-77-6666', 200000, '2017-03-11'),
('237432', '135-79-0000', 250000, '2019-02-05'),
('902385', '204-60-8010', 300000, '2012-05-30'),
('511283', '987-65-4321', 450000, '2010-01-01'),
('936497', '300-40-5000', 79000, '2021-09-15'),
('783404', '800-50-7676', 91000, '2017-11-23'),
('416799', '103-05-7090', 85000, '2019-08-13');

INSERT INTO Doctor (licenseNumber, staffID, experience) VALUES
('77231', '510201', 11),
('88342', '510202', 7),
('66125', '510203', 15),
('99473', '510204', 18),
('89012', '107435', 16),
('23456', '237432', 8),
('34567', '902385', 12),
('56789', '511283', 20);

INSERT INTO Nurse (staffID, shiftType, regExpiration) VALUES
('720301', 'Morning', '2027-01-31'),
('720303', 'Night', '2026-05-31'),
('720304', 'Afternoon', '2026-12-31'),
('936497', 'Morning', '2026-06-01'),
('783404', 'Afternoon', '2026-07-15'),
('416799', 'Night', '2026-05-31');


INSERT INTO Department (deptID, name, managerID) VALUES
(4, 'Ophthalmology', '902385'),
(7, 'Cardiology', '510203'),
(9, 'Neurology', '510204'),
(11, 'Primary care', '511283');

INSERT INTO WorksIn (staffID, deptID) VALUES
('720301', 9),
('720301', 7),
('720303', 7),
('720303', 4),
('720304', 7),
('510201', 7),
('510202', 9),
('510203', 7),
('510204', 9),
('107435', 11),
('237432', 4),
('902385', 4),
('511283', 11),
('936497', 4),
('783404', 4),
('416799', 11);

INSERT INTO Room (number, type, deptID) VALUES
(3102, 'Shared', 9),
(1421, 'Private', 7),
(1108, 'Private', 4),
(908, 'Shared', 11);

INSERT INTO Assigned (roomNumber, staffID) VALUES
(3102, '720301'),
(908, '720301'),
(1421, '720303'),
(1421, '720304'),
(1108, '720304'),
(1108, '936497'),
(1108, '783404'),
(1108, '416799');

INSERT INTO Patient (ssn, contact, funds, roomNumber) VALUES
('909-10-1111', '404-555-1010', 1800, 3102),
('323-44-5555', '470-555-2020', 2400, 1421),
('123-45-6789', '470-321-6543', 2000, 1108);

INSERT INTO Appointment (patientSsn, date, time, cost) VALUES
('909-10-1111', '2025-09-15', '09:20:00', 520),
('323-44-5555', '2025-09-15', '14:05:00', 460),
('123-45-6789', '2025-03-15', '15:00:00', 300),
('123-45-6789', '2025-04-27', '11:30:00', 750);

INSERT INTO Symptom (patientSsn, date, time, type, numDays) VALUES
('909-10-1111', '2025-09-15', '09:20:00', 'Migraine', 5),
('909-10-1111', '2025-09-15', '09:20:00', 'Numbness in fingers', 2),
('323-44-5555', '2025-09-15', '14:05:00', 'Chest tightness', 1),
('123-45-6789', '2025-03-15', '15:00:00', 'Blurry vision', 7),
('123-45-6789', '2025-04-27', '11:30:00', 'Blurry vision', 40),
('123-45-6789', '2025-04-27', '11:30:00', 'Sensitivity to bright light', 10),
('123-45-6789', '2025-04-27', '11:30:00', 'Seeing halos around objects', 2);

INSERT INTO ScheduledFor (patientSsn, date, time, licenseNumber) VALUES
('909-10-1111', '2025-09-15', '09:20:00', '88342'),
('909-10-1111', '2025-09-15', '09:20:00', '77231'),
('323-44-5555', '2025-09-15', '14:05:00', '66125'),
('123-45-6789', '2025-03-15', '15:00:00', '89012'),
('123-45-6789', '2025-04-27', '11:30:00', '23456'),
('123-45-6789', '2025-04-27', '11:30:00', '34567');

INSERT INTO PatientOrder (orderNumber, patientSsn, licenseNumber, priority, date, cost) VALUES
(3100451, '909-10-1111', '88342', 2, '2025-09-15', 25),
(3750129, '323-44-5555', '66125', 1, '2025-09-15', 95),
(1560238, '123-45-6789', '89012', 2, '2025-04-27', 15),
(1561902, '123-45-6789', '23456', 1, '2025-05-01', 50);

INSERT INTO Prescription (orderNumber, drugType, dosageMg) VALUES
(3100451, 'Sumatriptan', 50),
(1560238, 'Pain relievers', 800);

INSERT INTO LabWork (orderNumber, type) VALUES
(3750129, 'Cardiac enzyme panel'),
(1561902, 'Blood test');
