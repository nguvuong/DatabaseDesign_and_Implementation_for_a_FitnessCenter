use section24
go

DROP TABLE GymLocation
DROP TABLE Amenity
DROP TABLE Coach
DROP TABLE Certificate
DROP TABLE Reference
DROP TABLE Client
DROP TABLE Class
DROP TABLE Review
DROP TABLE CoachLocation



exec sp_help GymLocation;



---- create table

CREATE TABLE GymLocation(
    locationid NUMERIC(3) PRIMARY KEY,
    locationname VARCHAR(30),
    address VARCHAR(30),
    tel VARCHAR(30),
    email VARCHAR(30),
    visitedTime NUMERIC(3)
)


CREATE TABLE Amenity (
    amenityid NUMERIC(3) PRIMARY KEY,
    amenity VARCHAR(30),
    locationid numeric(3) CONSTRAINT gymlocation_locationid_pk FOREIGN KEY REFERENCES GymLocation(locationid) 
)




CREATE TABLE Certificate (
    certificateid NUMERIC(3) PRIMARY KEY,
    coachid NUMERIC(3) CONSTRAINT coach_coachid_pk FOREIGN KEY REFERENCES Coach(coachid),
    certificatename VARCHAR(30)

)

CREATE TABLE Coach (
    coachid NUMERIC(3) PRIMARY KEY,
    coachname VARCHAR(30),
    level NUMERIC(2),
    rating NUMERIC(2)
)



CREATE TABLE CoachLocation (
    coachlocationid NUMERIC(3) PRIMARY KEY,
    coachid NUMERIC(3) CONSTRAINT coach_coachid_pk1 FOREIGN KEY REFERENCES Coach(coachid),
    locationid NUMERIC(3) CONSTRAINT gymlocation_locationid_pk1 FOREIGN KEY REFERENCES GymLocation(locationid)
)

CREATE TABLE Review (
    reviewid numeric(3) PRIMARY KEY,
    reviewdate DATE NOT NULL,
    communication int CONSTRAINT chk_in_rating CHECK (communication in (1, 2, 3, 4, 5)),
    enthusiasm int CONSTRAINT chk_in_rating2 CHECK (enthusiasm in (1, 2, 3, 4, 5)),
    punctuality int  CONSTRAINT chk_in_rating3 CHECK (punctuality in (1, 2, 3, 4, 5)),
    description VARCHAR(30),
    coachid numeric(3)  CONSTRAINT coach_coachid_pk2 FOREIGN KEY REFERENCES Coach(coachid)
)


CREATE TABLE Reference (
    referenceid NUMERIC(3) PRIMARY KEY,
    coachid NUMERIC(3) CONSTRAINT coach_coachid_pk3 FOREIGN KEY REFERENCES Coach(coachid), 
    clientid NUMERIC(3) CONSTRAINT client_clientid_pk FOREIGN KEY REFERENCES Client(clientid),
  
)


CREATE TABLE Client (
    clientid numeric(3) PRIMARY KEY,
    clientname VARCHAR(30),
    phone VARCHAR(30),
    email VARCHAR(30)
)


CREATE TABLE Class (
    classid NUMERIC(3) PRIMARY KEY,
    date DATE, 
    time TIME,
    classname VARCHAR(30),
    price DECIMAL(5, 2) CONSTRAINT chk_in_price1 CHECK (price >= 0.0),
    room VARCHAR(30), 
    locationid NUMERIC(3) CONSTRAINT locationid_pl FOREIGN KEY REFERENCES GymLocation(locationid)

)



-------
-------insert
INSERT INTO GymLocation
VALUES (100, 'Midtown', 'Brampton', '123-456-789', 'nguvuong@sheridancollege.ca'  ,15),
        (101, 'Çabbagetown', 'Brampton1', '123-456-789', 'nguvuong1@sheridancollege.ca' , 8),
        (102, 'Midtown',  'Brampton2', '123-456-789', 'nguvuon2g@sheridancollege.ca' , 3)

INSERT INTO Reference
VALUES (1,100, 100), (2, 100,101), (3, 100,102)

INSERT INTO client
VALUES (100, 'vuong1', '111-222-333', 'aa@aaa.com'), (101, 'vuong2', '111-222-333', 'bb@bbb'), (102, 'vuong3', '111-222-333', 'cc@ccc')


INSERT INTO class 
VALUES (100, '2023-06-15', '6:00', 'Yoga', 10, 'Big Studio', 100),
(101, '2023-06-16','7:00', 'Swimming', 13.5, 'Big Studio', 100),
(102, '2023-06-17','8:00', 'Yoga', 15, 'Small Studio', 100)

INSERT INTO Review 
VALUES (100, '12-1-2023', 4,5,4, 'good', 100),
(101, '12-1-2023', 4,5,4, 'good', 100),
(102, '12-2-2023', 5,5,5, 'very good', 100),
(103, '12-3-2023', 3,5,3, 'great', 100),
(104, '12-4-2023', 4,5,4, 'perfect', 100)

insert into Certificate
values (100, 100, 'message'), (101, 100, 'yoga'), (102, 100, 'swimming')

INSERT INTO Amenity
VALUES(10, 'Sauna', 100 ),(11, 'Green Zone', 100),(12, 'Hot Yoga', 100)

insert into CoachLocation 
values (1, 100, 100), (2, 101, 100), (3, 102, 100)

insert into Coach
VALUES (100, 'Sally', 3, 5), (101, 'Adam', 2, 3), (102, 'Sander', 3, 5)






-----
------  select
--) wireframe 1 

SELECT locationname as Locations, visitedTime as Timevisitedthismonth from GymLocation

--) wireframe 2 
SELECT
    GymLocation.address,
    GymLocation.tel,
    GymLocation.email,
    Amenity.amenity as Amenities,
    Coach.coachname as Coaches
FROM
    GymLocation
JOIN
    Amenity ON GymLocation.locationid = Amenity.locationid
JOIN 
    CoachLocation ON CoachLocation.locationid = GymLocation.locationid
JOIN 
    Coach ON Coach.coachid =   CoachLocation.coachid
WHERE
    GymLocation.locationname = 'Midtown';


--) wireframe 3 
select  coach.coachname as Coaches, coach.level,  coach.rating from coach


--) wireframe 4 
SELECT Coach.coachname,
    Coach.[level],
    Coach.rating,
    GymLocation.locationname as Locations_I_work_from, 
    Certificate.certificatename as Certificates,
    Client.clientname,
    Client.email,
    Client.phone
    
FROM GymLocation,
     CoachLocation,
     Coach,
     Certificate,
     Reference,
     Client
WHERE Certificate.coachid = (select Coach.coachid where coachname = 'Sally')
AND Reference.coachid = (select Coach.coachid where coachname = 'Sally')
AND GymLocation.locationid = any (select CoachLocation.locationid where CoachLocation.coachid =  (select Coach.coachid where coachname = 'Sally'))
AND Client.clientid = any (select Reference.clientid  where Reference.coachid = (select Coach.coachid where coachname = 'Sally')) 


