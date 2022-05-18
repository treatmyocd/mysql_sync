CREATE DATABASE IF NOT EXISTS syncer_demo;
USE syncer_demo;

DROP TABLE syncer_src;
CREATE TABLE syncer_src (
  id int not null auto_increment primary key,
  name varchar(255) not null,
  favorite_animal varchar(255),
  UNIQUE KEY (`name`)
);


DROP TABLE syncer_dst;
CREATE TABLE syncer_dst (
  id int not null auto_increment primary key,
  name varchar(255) not null,
  favorite_animal varchar(255),
  UNIQUE KEY (`name`)
);


INSERT INTO syncer_src (name, favorite_animal) 
VALUES ('Tim', 'Dog'),
       ('Jane', 'Fish'),
       ('Jack', 'Horse'),
       ('Mary', 'Cat'); 


