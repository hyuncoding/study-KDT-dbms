create database test;
use test;

create table tbl_guest(
	id bigint unsigned auto_increment primary key,
	guest_name varchar(255),
	created_date datetime default current_timestamp()
);

insert into tbl_guest(guest_name) 
values('한동석');
insert into tbl_guest() 
values();

select * from tbl_guest;

select concat(id, '번 ', guest_name) from tbl_guest;

select current_timestamp() from dual;

select date_format(created_date, '%Y년 %m월 %d일 %H:%i:%s') created_date 
from tbl_guest
where id = 1;

select id, ifnull(guest_name, '미정') guest_name, created_date from tbl_guest;

/*guest 계정 생성*/
create database guest;
/*guest 계정 사용*/
use guest;
/*tbl_member 테이블 생성*/
create table tbl_member(
	id bigint unsigned auto_increment primary key,
	member_name varchar(255) not null,
	member_birth date
);
/*번호, 이름, 생년월일*/
select * from tbl_member;
/*회원 정보 추가*/
insert into tbl_member(member_name, member_birth)
values('한동석', 20000111);
/*회원 정보 조회*/
select * from tbl_member
where id = 1;
/*회원 정보 수정*/
update tbl_member
set member_birth = 20000112
where id = 1;

select * from tbl_member;
/*회원 정보 삭제*/
delete from tbl_member
where id = 1;
/*테이블 삭제*/
drop table tbl_member;
/*계정 삭제*/
drop database guest;








