CREATE DATABASE payment;
\c payment
CREATE TABLE transaction(id SERIAL PRIMARY KEY, amount int, customerId varchar(36));


--insert into transaction(id, amount,customerId) values(85, 87,'37b920fd-ecdd-7172-693a-d7be6db9792c');
--update transaction set amount=77 where id=85
