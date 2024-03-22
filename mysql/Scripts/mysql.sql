create database test;
use test;

create table tbl_guest(
	id bigint unsigned auto_increment primary key,
	guest_name varchar(255),
	created_date datetime default current_timestamp()
);

insert into tbl_guest(guest_name) 
values('�ѵ���');
insert into tbl_guest() 
values();

select * from tbl_guest;

select concat(id, '�� ', guest_name) from tbl_guest;

select current_timestamp() from dual;

select date_format(created_date, '%Y�� %m�� %d�� %H:%i:%s') created_date 
from tbl_guest
where id = 1;

select id, ifnull(guest_name, '����') guest_name, created_date from tbl_guest;

/*guest ���� ����*/
create database guest;
/*guest ���� ���*/
use guest;
/*tbl_member ���̺� ����*/
create table tbl_member(
	id bigint unsigned auto_increment primary key,
	member_name varchar(255) not null,
	member_birth date
);
/*��ȣ, �̸�, �������*/
select * from tbl_member;
/*ȸ�� ���� �߰�*/
insert into tbl_member(member_name, member_birth)
values('�ѵ���', 20000111);
/*ȸ�� ���� ��ȸ*/
select * from tbl_member
where id = 1;
/*ȸ�� ���� ����*/
update tbl_member
set member_birth = 20000112
where id = 1;

select * from tbl_member;
/*ȸ�� ���� ����*/
delete from tbl_member
where id = 1;
/*���̺� ����*/
drop table tbl_member;
/*���� ����*/
drop database guest;








