create database mybatis;
use mybatis;

create table tbl_product(
	id bigint unsigned auto_increment primary key,
	product_name varchar(255) not null,
	product_price int default 0,
	product_stock int default 0
);

