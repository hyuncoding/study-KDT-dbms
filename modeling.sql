/*
    회원		    주문		    상품
	------------------------------------
	번호PK		번호PK		번호PK
	------------------------------------
	아이디U, NN	날짜NN		이름NN
	비밀번호NN	회원번호FK, NN	가격D=0
	이름NN		상품번호FK, NN	재고D=0
	주소NN
	이메일
	생일
*/

create table tbl_user(
    id bigint primary key,
    user_id varchar(255) unique not null,
    password varchar(255) not null,
    name varchar(255) not null,
    address varchar(255) not null,
    email varchar(255),
    birth date
);

create table tbl_product(
    id bigint primary key,
    name varchar(255) not null,
    price int default 0,
    stock int default 0
);

create table tbl_order(
    id bigint primary key,
    order_date datetime default current_timestamp,
    user_id bigint not null,
    product_id bigint not null,
    constraint fk_order_user foreign key(user_id)
    references tbl_user(id) on delete cascade,
    constraint fk_order_product foreign key(product_id)
    references tbl_product(id)
);

/*
    1. 요구사항 분석
        꽃 테이블과 화분 테이블 2개가 필요하고,
        꽃을 구매할 때 화분도 같이 구매합니다.
        꽃은 이름과 색상, 가격이 있고,
        화분은 제품번호, 색상, 모양이 있습니다.
        화분은 모든 꽃을 담을 수 없고 정해진 꽃을 담아야 합니다.

    2. 개념 모델링

        꽃                   화분
    -----------------------------------
        번호                 (제품)번호
    -----------------------------------
        이름                 색상
        색상                 모양
        가격                 꽃번호
        재고                 가격
                            재고

    3. 논리 모델링

        꽃                   화분
    -----------------------------------
        번호PK               (제품)번호PK
    -----------------------------------
        이름U, NN            색상NN
        색상NN               모양NN
        가격D=0              꽃번호FK, NN
        재고D=0              가격D=0
                            재고D=0

    4. 물리 모델링

    tbl_flower                              tbl_vase
    ---------------------------------------------------------------
    id bigint primary key                   id bigint primary key
    ---------------------------------------------------------------
    name varchar(255) unique not null       color varchar(255) not null
    color varchar(255) not null             shape varchar(255) not null
    price int default 0                     flower_id bigint not null
    stock int default 0                     price int default 0
                                            stock int default 0

    5. 구현
*/

/*
    복합키(조합키): 하나의 PK에 여러 컬럼을 설정한다.
*/
create table tbl_flower(
    name varchar(255) unique not null,
    color varchar(255) not null,
    price int default 0,
    primary key(name, color)
);

create table tbl_vase(
    id bigint primary key,
    color varchar(255) not null,
    shape varchar(255) not null,
    flower_name varchar(255) not null,
    flower_color varchar(255) not null,
    constraint fk_vase_flower foreign key(flower_name, flower_color)
    references tbl_flower(name, color)
);

/*
    1. 요구사항 분석
        안녕하세요, 동물병원을 곧 개원합니다.
        동물은 보호자랑 항상 같이 옵니다. 가끔 보호소에서 오는 동물도 있습니다.
        보호자가 여러 마리의 동물을 데리고 올 수 있습니다.
        보호자는 이름, 나이, 전화번호, 주소가 필요하고
        동물은 병명, 이름, 나이, 몸무게가 필요합니다.

    2. 개념 모델링

        동물                      보호자
    --------------------------------------
        번호                      번호
    --------------------------------------
        병명                      이름
        이름                      나이
        나이                      전화번호
        몸무게                    주소
        보호자

    3. 논리 모델링

        동물                      보호자
    --------------------------------------
        번호PK                    번호PK
    --------------------------------------
        병명NN                    이름NN
        이름NN                    나이D=0
        나이D=0                   전화번호NN
        몸무게D=0                 주소NN
        보호자FK

    4. 물리 모델링

        tbl_pet                                  tbl_family
    --------------------------------------------------------------------------------------
        id bigint primary key                       id bigint primary key
    --------------------------------------------------------------------------------------
        disease varchar(255) not null               name varchar(255) not null
        name varchar(255) not null                  age int default 0
        age int default 0                           phone varchar(255) not null
        weight decimal(3, 2) default 0              address varchar(255) not null
        family_id bigint

    5. 구현
*/
create table tbl_family(
    id bigint primary key,
    name varchar(255) not null,
    age int default 0,
    phone varchar(255) not null,
    address varchar(255) not null
);

create table tbl_pet(
    id bigint primary key,
    ill_name varchar(255) not null,
    name varchar(255) default '사랑',
    age int default 0,
    weight decimal(3, 2) default 0,
    family_id bigint,
    constraint fk_pet_family foreign key(family_id)
    references tbl_family(id)
);

drop table tbl_pet;
drop table tbl_family;

/*
    1. 요구사항 분석
        안녕하세요 중고차 딜러입니다.
        이번에 자동차와 차주를 관리하고자 방문했습니다.
        자동차는 여러 명의 차주로 히스토리에 남아야 하고,
        차주는 여러 대의 자동차를 소유할 수 있습니다.
        그래서 우리는 항상 등록증(Registration)을 작성합니다.
        자동차는 브랜드, 모델명, 가격, 출시날짜가 필요하고
        차주는 이름, 전화번호, 주소가 필요합니다.

    2. 개념 모델링

        자동차                 등록증                    차주

        번호                   번호                     번호
        브랜드                 자동차번호                이름
        모델명                 차주번호                  전화번호
        가격                  계약(매매)날짜              주소
        출시날짜

    3. 논리 모델링

        자동차                 등록증                    차주

        번호PK                 번호PK                   번호PK
        브랜드NN               자동차번호FK, NN           이름NN
        모델명NN               차주번호FK, NN            전화번호NN
        가격D=0               계약(매매)날짜D=CT          주소NN
        출시날짜D=CD

    4. 물리 모델링

        tbl_car

        id bigint primary key
        brand varchar(255) not null
        model_name varchar(255) not null
        price int default 0
        release_date date default current_date

        tbl_owner

        id bigint primary key
        name varchar(255) not null
        phone varchar(255) not null
        address varchar(255) not null

        tbl_registration

        id bigint primary key
        car_id bigint
        owner_id bigint
        register_date datetime default current_timestamp

    5. 구현
*/

create table tbl_car(
    id bigint primary key,
    brand varchar(255) not null,
    model_name varchar(255) not null,
    price int default 0,
    release_date date default (current_date)
);

create table tbl_owner(
    id bigint primary key,
    name varchar(255) not null,
    phone varchar(255) not null,
    address varchar(255) not null
);

create table tbl_registration(
    id bigint primary key,
    car_id bigint not null,
    owner_id bigint not null,
    register_date datetime default current_timestamp,
    constraint fk_registration_car foreign key(car_id)
    references tbl_car(id),
    constraint fk_registration_owner foreign key(owner_id)
    references tbl_owner(id)
);

drop table tbl_registration;
drop table tbl_car;
drop table tbl_owner;

/*
    요구 사항
    커뮤니티 게시판을 만들고 싶어요.
    게시판에는 게시글 제목과 게시글 내용, 작성한 시간, 작성자가 있고,
    게시글에는 댓글이 있어서 댓글 내용들이 나와야 해요.
    작성자는 회원(TBL_USER) 정보를 그대로 사용해요.
    댓글에도 작성자가 필요해요.
*/

create table tbl_user(
    id bigint primary key,
    user_id varchar(255) unique not null,
    password varchar(255) not null,
    name varchar(255) not null,
    address varchar(255) not null,
    email varchar(255),
    birth date
);

create table tbl_post(
    id bigint primary key,
    title varchar(255) not null,
    content varchar(255) not null,
    post_time datetime default current_timestamp,
    user_id bigint,
    constraint fk_post_user foreign key(user_id)
    references tbl_user(id)
);

create table tbl_comment(
    id bigint primary key,
    content varchar(255) not null,
    post_id bigint not null,
    user_id bigint not null,
    comment_time datetime default current_timestamp,
    constraint fk_comment_post foreign key(post_id)
    references tbl_post(id),
    constraint fk_comment_user foreign key(user_id)
    references tbl_user(id)
);



/*
    요구사항

    마이페이지에서 회원 프로필을 구현하고 싶습니다.
    회원당 프로필을 여러 개 설정할 수 있고,
    대표 이미지로 선택된 프로필만 화면에 보여주고 싶습니다.
*/

create table tbl_member(
    id bigint primary key,
    member_id varchar(255) unique not null,
    password varchar(255) not null,
    name varchar(255) not null,
    address varchar(255) not null,
    email varchar(255),
    birth date
);

create table tbl_profile(
    id bigint primary key,
    image_path varchar(255) default '/upload/',
    file_name varchar(255) not null,
    member_id bigint,
    is_selected varchar(255) default 'ELSE',
    constraint fk_profile_member foreign key(member_id)
    references tbl_member(id)
);



/*
    요구사항

    학사 관리 시스템에 학생과 교수, 과목을 관리합니다.
    학생은 학번, 이름, 전공, 학년이 필요하고
    교수는 교수 번호, 이름, 전공, 직위가 필요합니다.
    과목은 고유한 과목 번호와 과목명, 학점이 필요합니다.
    학생은 여러 과목을 수강할 수 있으며,
    교수는 여러 과목을 강의할 수 있습니다.
    학생이 수강한 과목은 성적(점수)이 모두 기록됩니다.
*/

/* 학생 테이블 */
create table tbl_student(
    id bigint auto_increment primary key,
    name varchar(255) not null,
    major varchar(255) not null,
    grade int default 1
);

/* 교수 테이블 */
create table tbl_professor(
    id bigint auto_increment primary key,
    name varchar(255) not null,
    major varchar(255) not null,
    position varchar(255) default '일반'
);

/* 과목 테이블 */
create table tbl_subject(
    id bigint auto_increment primary key,
    name varchar(255) not null,
    degree int default 0
);

/* 과목-교수 중간 테이블 */
create table tbl_lecture(
    id bigint primary key,
    subject_id bigint not null,
    professor_id bigint not null,
    constraint fk_lecture_subject foreign key(subject_id)
    references tbl_subject(id),
    constraint fk_lecture_professor foreign key(professor_id)
    references tbl_professor(id)
);

/* 과목-학생 중간 테이블 (성적) */
create table tbl_score(
    id bigint primary key,
    student_id bigint not null,
    subject_id bigint not null,
    professor_id bigint not null,
    score decimal(3, 2) default 0.0,
    status varchar(255) default '수강중',
    constraint check_status check (status in ('수강중', '수강완료')),
    constraint fk_score_student foreign key(student_id)
    references tbl_student(id),
    constraint fk_score_subject foreign key(subject_id)
    references tbl_subject(id),
    constraint fk_score_professor foreign key(professor_id)
    references tbl_professor(id)
);


/*
    요구사항

    대카테고리, 소카테고리가 필요해요.
*/

/* 대카테고리 테이블 */
create table tbl_category_a(
    id bigint auto_increment primary key,
    title varchar(255) unique not null
);

/* 소카테고리 테이블 */
create table tbl_category_b(
    id bigint auto_increment primary key,
    title varchar(255) unique not null,
    category_a_id bigint not null,
    constraint fk_category_b_category_a foreign key(category_a_id)
    references tbl_category_a(id)
);


/*
    요구사항

    회의실 예약 서비스를 제작하고 싶습니다.
    회원별로 등급이 존재하고 사무실마다 회의실이 여러 개 있습니다.
    회의실 이용 가능 시간은 파트 타임으로서 여러 시간대가 존재합니다.
*/

/* 회원 테이블 */
create table tbl_member2(
    member_id varchar(255) primary key,
    password varchar(255) not null,
    name varchar(255) not null,
    address varchar(255) not null,
    email varchar(255),
    birth date,
    level varchar(255) default 'BASIC'
);

/* 사무실 테이블 */
create table tbl_office(
    id bigint auto_increment primary key,
    name varchar(255) not null,
    address varchar(255) not null
);

/* 회의실 테이블 */
create table tbl_conference_room(
    id bigint auto_increment primary key,
    office_id bigint not null,
    constraint fk_conference_room_office foreign key(office_id)
    references tbl_office(id)
);

/* 파트타임 테이블 (시간) */
create table tbl_part_time(
    id bigint auto_increment primary key,
    time time not null,
    conference_room_id bigint not null,
    constraint fk_part_time_cf_room foreign key(conference_room_id)
    references tbl_conference_room(id)
);

/* 예약 테이블 (회원-사무실 중간 테이블) */
create table tbl_reservation(
    id bigint auto_increment primary key,
    member_id varchar(255) not null,
    conference_room_id bigint not null,
    time time not null,
    created_at datetime default (current_timestamp),
    constraint fk_reservation_member foreign key(member_id)
    references tbl_member2(member_id),
    constraint fk_reservation_cf_room foreign key(conference_room_id)
    references tbl_conference_room(id)
);

/*
    요구사항

    유치원을 하려고 하는데, 아이들이 체험학습 프로그램을 신청해야 합니다.
    아이들 정보는 이름, 나이, 성별이 필요하고 학부모는 이름, 나이, 주소, 전화번호, 성별이 필요해요
    체험학습은 체험학습 제목, 체험학습 내용, 이벤트 이미지 여러 장이 필요합니다.
    아이들은 여러 번 체험학습에 등록할 수 있어요.
*/
/* 부모 테이블 */
create table tbl_parent(
    id bigint auto_increment primary key,
    name varchar(255) not null,
    age tinyint default 0,
    address varchar(255) not null,
    phone varchar(255) not null,
    gender varchar(255) not null
);

/* 아이 테이블 */
create table tbl_child(
    id bigint auto_increment primary key,
    name varchar(255) not null,
    age tinyint default 0,
    gender varchar(255) not null,
    parent_id bigint,
    constraint fk_child_parent foreign key(parent_id)
    references tbl_parent(id)
);

/* 체험학습 테이블 */
create table tbl_field_trip(
    id bigint auto_increment primary key,
    field_trip_title varchar(255) not null,
    field_trip_content varchar(255) not null,
    max_count tinyint default 0
);

/* 파일 테이블 (슈퍼키로 활용) */
create table tbl_file(
    id bigint auto_increment primary key,
    file_path varchar(255) not null,
    file_name varchar(255) not null
);

/* 체험학습 이벤트이미지 테이블 */
create table tbl_field_trip_file(
    id bigint primary key,
    field_trip_id bigint not null,
    constraint fk_file_field_trip foreign key(field_trip_id)
    references tbl_field_trip(id),
    constraint fk_field_trip_file_file foreign key(id)
    references tbl_file(id)
);

/* 체험학습 등록 테이블 (아이들 - 체험학습 중간 테이블) */
create table tbl_apply(
    id bigint auto_increment primary key,
    child_id bigint not null,
    field_trip_id bigint not null,
    constraint fk_apply_child foreign key(child_id)
    references tbl_child(id),
    constraint fk_apply_parent foreign key(field_trip_id)
    references tbl_field_trip(id)
);

/*
    요구사항

    안녕하세요, 광고 회사를 운영하려고 준비중인 사업가입니다.
    광고주는 기업이고 기업 정보는 이름, 주소, 대표번호, 기업종류(스타트업, 중소기업, 중견기업, 대기업)입니다.
    광고는 제목, 내용이 있고 기업은 여러 광고를 신청할 수 있습니다.
    기업이 광고를 선택할 때에는 카테고리로 선택하며, 대카테고리, 중카테고리, 소카테고리가 있습니다.
*/

/* 기업 테이블 */
create table tbl_company(
    id bigint auto_increment primary key,
    name varchar(255) not null,
    address varchar(255) not null,
    main_phone varchar(255) not null,
    company_type varchar(255) not null
);

/* 대카테고리 테이블 */
create table tbl_category_1(
    id bigint auto_increment primary key,
    title varchar(255) not null
);

/* 중카테고리 테이블 */
create table tbl_category_2(
    id bigint auto_increment primary key,
    title varchar(255) not null,
    category_1_id bigint,
    constraint fk_category_2_1 foreign key(category_1_id)
    references tbl_category_1(id)
);

/* 소카테고리 테이블 */
create table tbl_category_3(
    id bigint auto_increment primary key,
    title varchar(255) not null,
    category_2_id bigint,
    constraint fk_category_3_2 foreign key(category_2_id)
    references tbl_category_2(id)
);

/* 광고 테이블 */
create table tbl_advertisement(
    id bigint auto_increment primary key,
    title varchar(255) not null,
    content varchar(255) not null,
    category_3_id bigint,
    constraint fk_advertisement_category_3 foreign key(category_3_id)
    references tbl_category_3(id)
);

/* 광고-기업 계약 테이블 */
create table tbl_contract(
    id bigint auto_increment primary key,
    company_id bigint,
    advertisement_id bigint,
    created_date datetime default (current_timestamp),
    updated_date datetime default (current_timestamp) on update (current_timestamp),
    constraint fk_contract_company foreign key(company_id)
    references tbl_company(id),
    constraint fk_contract_advertisement foreign key(advertisement_id)
    references tbl_advertisement(id)
);

/*
    요구사항

    음료수 판매 업체입니다. 음료수마다 당첨번호가 있습니다.
    음료수의 당첨번호는 1개이고 당첨자의 정보를 알아야 상품을 배송할 수 있습니다.
    당첨 번호마다 당첨 상품이 있고, 당첨 상품이 배송 중인지 배송 완료인지 구분해야 합니다.
*/

/* 음료수 테이블 */
create table tbl_drink(
    id bigint auto_increment primary key,
    name varchar(255) not null,
    price int default 0
);

/* 상품 테이블 */
create table tbl_product(
    id bigint auto_increment primary key,
    name varchar(255) not null
);

/* 당첨번호-상품 테이블 */
create table tbl_lotto(
    id bigint auto_increment primary key,
    lotto_num varchar(255) not null,
    product_id bigint,
    constraint fk_lotto_product foreign key(product_id)
    references tbl_product(id)
);

/* 당첨번호 - 음료수 중간 테이블 */
create table tbl_circulation(
    id bigint auto_increment primary key,
    drink_id bigint not null,
    lotto_id bigint not null,
    constraint fk_circulation_drink foreign key(drink_id)
    references tbl_drink(id),
    constraint fk_circulation_lotto foreign key(lotto_id)
    references tbl_lotto(id)
);

/* 유저 테이블 */
create table tbl_member3(
    id bigint auto_increment primary key,
    name varchar(255) not null,
    phone varchar(255) not null,
    address varchar(255) not null,
    age tinyint default 0,
    birth date
);

/* 배송 테이블 (lotto_id로 음료수, 상품 갖고오고 member_id로 당첨자 가져옴) */
create table tbl_delivery(
    id bigint auto_increment primary key,
    status varchar(255),
    product_id bigint not null,
    member_id bigint not null,
    constraint check_delivery_status check( status in ('상품준비중', '배송중', '배송완료')),
    constraint fk_delivery_product foreign key(product_id)
    references tbl_product(id),
    constraint fk_delivery_member foreign key(member_id)
    references tbl_member3(id)
);

/*
    요구사항

    이커머스 창업 준비중입니다. 기업과 사용자 간 거래를 위해 기업의 정보와 사용자 정보가 필요합니다.
    기업의 정보는 기업 이름, 주소, 대표번호가 있고
    사용자 정보는 이름, 주소, 전화번호가 있습니다. 결제 시 사용자 정보와 기업의 정보, 결제한 카드의 정보 모두 필요하며,
    상품의 정보도 필요합니다. 상품의 정보는 이름, 가격, 재고입니다.
    사용자는 등록한 카드의 정보를 저장할 수 있으며, 카드의 정보는 카드번호, 카드사, 회원 정보가 필요합니다.
*/

/* 사용자 테이블 */
create table tbl_member4(
    id bigint auto_increment primary key,
    name varchar(255) not null,
    address varchar(255) not null,
    phone varchar(255) not null
);

/* 기업 테이블 */
create table tbl_company2(
    id bigint auto_increment primary key,
    name varchar(255) not null,
    address varchar(255) not null,
    main_phone varchar(255) not null
);

/* 상품 테이블 */
create table tbl_product2(
    id bigint auto_increment primary key,
    name varchar(255) not null,
    price int default 0,
    stock int default 0,
    company_id bigint not null,
    constraint fk_product_company foreign key(company_id)
    references tbl_company2(id)
);

/* 카드 테이블 */
create table tbl_card(
    id bigint auto_increment primary key,
    card_number varchar(255) unique not null,
    card_company varchar(255) not null,
    member_id bigint,
    constraint fk_card_member foreign key(member_id)
    references tbl_member4(id)
);

/* 카운트 테이블 (sequence) */
create table tbl_sequence(
    id bigint auto_increment primary key,
    sequence bigint default 0
);

/* 주문 테이블 */

create table tbl_order(
    id bigint,
    created_date date default (current_date),
    primary key(id, created_date)
);

/* 중간 테이블 */
create table tbl_order_product(
    id bigint auto_increment primary key,
    order_id bigint,
    order_created_date date,
    product_id bigint,
    count int default 0,
    constraint fk_order_product_order foreign key(order_id, order_created_date)
    references tbl_order(id, created_date),
    constraint fk_order_product_product foreign key(product_id)
    references tbl_product2(id)
);

/* 결제 테이블 */
create table tbl_payment(
    id bigint auto_increment primary key,
    order_id bigint,
    order_created_date date,
    card_id bigint,
    constraint fk_payment_order foreign key (order_id, order_created_date)
    references tbl_order(id, created_date),
    constraint fk_payment_card foreign key(card_id)
    references tbl_card(id)
);


