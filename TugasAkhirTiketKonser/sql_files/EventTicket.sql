CREATE TABLE events (
	eventId serial primary key not null,
	namaevent varchar (30) not null,
	tempat varchar (20) not null,
	tanggal date not null
);

INSERT INTO events (namaevent, tempat, tanggal)
VALUES ('Java Jazz Fest', 'Senayan Jakarta', '2022-03-05');

CREATE TABLE ticket (
	eventId serial not null,
	ticketId varchar(8) primary key not null,
	harga int not null,
	stok int not null
);

INSERT INTO ticket (eventid, ticketid, harga, stok)
VALUES (4, 'VVJJF04', 300000, 150);

ALTER TABLE ticket
ADD FOREIGN KEY (eventId) REFERENCES events (eventId)
ON DELETE CASCADE ON UPDATE CASCADE;

CREATE TABLE customer (
	customerId serial primary key not null,
	nama varchar(30) not null,
	nohp varchar(13) not null,
	email varchar(20) not null,
	username varchar(20) not null,
	userpassword varchar(8) not null
);

CREATE TABLE customerOrder (
	orderId serial not null,
	customerId serial not null,
	ticketId varchar(8) not null,
	jumlah int not null,
	tanggal date
);

ALTER TABLE customerOrder
ADD FOREIGN KEY (customerId) REFERENCES customer (customerId)
ON DELETE CASCADE ON UPDATE CASCADE,
ADD FOREIGN KEY (ticketId) REFERENCES ticket (ticketId)
ON DELETE CASCADE ON UPDATE CASCADE;

CREATE VIEW detailOrder as
SELECT customerOrder.orderId, ticket.ticketId, customerOrder.jumlah, (customerOrder.jumlah * ticket.harga) as subtotal
FROM customerOrder
JOIN ticket on customerOrder.ticketId = ticket.ticketId;

CREATE VIEW orderTotal as
SELECT customerOrder.orderId, customerOrder.tanggal, Sum(detailOrder.subtotal) as total
FROM customerOrder
INNER JOIN detailOrder on customerOrder.orderId = detailOrder.orderId
GROUP BY customerOrder.orderId, customerOrder.tanggal;

CREATE VIEW detailtiket as
SELECT ticket.ticketid, events.namaevent, ticket.harga, ticket.stok
FROM ticket
JOIN events ON ticket.eventid = events.eventid;