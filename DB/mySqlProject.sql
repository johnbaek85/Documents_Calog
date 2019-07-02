-- root에서 설정, database명: project, userid: calog, password:if 
create database project;
create user 'calog'@'localhost' identified by 'if';
grant all privileges on project.* to 'calog'@'localhost';

use project;

-- 칼로리 단위: calorie, 시간 단위: 분으로 통일

-- user table
-- del_check_user_id:회원탈퇴시 값을 1로 업데이트, 탈퇴 여부 확인 key
create table user(
	user_id varchar(30) not null,
    password varchar(50) not null,
    name varchar(50),
    email varchar(50),
    phone varchar(20),
    address varchar(100),
    birthday timestamp,
    gender char(2),
    height double default 0,
    weight double default 0,
    bmi double default 0,
    del_check_user_id int default 0,
    primary key(user_id)
);

insert into user(user_id, password, name, email, phone, address, birthday, 
gender, height, weight)
values('spider', '1111', '스파이더맨', 'spider@spider.com', '010-1111-1111',
'서울시 금천구 가산동', '1997/01/01', '남', 170, 65);
insert into user(user_id, password, name, email, phone, address, birthday, 
gender, height, weight)
values('hulk', '2222', '헐크', 'hulk@hulk.com', '010-2222-2222',
'서울시 노원구 하계동', '1992/08/15', '남', 180, 70);
insert into user(user_id, password, name, email, phone, address, birthday, 
gender, height, weight)
values('scarlet', '3333', '스칼렛', 'scarlet@scarlet.com', '010-3333-3333',
'경기도 오산시 오산동', '2000/12/25', '여', 165, 50);
insert into user(user_id, password, name, email, phone, address, birthday, 
gender, height, weight)
values('natasha', '5555', '블랙위도우', 'natasha@natasha.com', '010-5555-5555',
'인천시 송도 송도동', '1980/03/01', '여', 170, 60);
insert into user(user_id, password, name, email, phone, address, birthday, 
gender, height, weight)
values('panther', '7777', binary'블랙팬서', 'panther@panther.com', '010-7777-7777',
'부산시 해운대구 바다동', '1999/04/05', '남', 172, 80);

-- 식단 type table(아침, 점심, 저녁, 간식 등)
create table diet_type(
	diet_type_id int auto_increment,
    diet_type_name varchar(30) not null,
    primary key(diet_type_id)
); 

insert into diet_type(diet_type_name) values('아침');
insert into diet_type(diet_type_name) values('점심');
insert into diet_type(diet_type_name) values('저녁');
insert into diet_type(diet_type_name) values('간식');

-- 식단 메뉴 table(라면, 김밥 등)
create table diet_menu(
	diet_menu_id int auto_increment,
    diet_menu_name varchar(30) not null,
    calorie int not null,
    primary key(diet_menu_id)
);

insert into diet_menu(diet_menu_name, calorie) values('라면', 1500);
insert into diet_menu(diet_menu_name, calorie) values('김밥', 700);
insert into diet_menu(diet_menu_name, calorie) values('쫄면', 800);
insert into diet_menu(diet_menu_name, calorie) values('우동', 900);
insert into diet_menu(diet_menu_name, calorie) values('짜장면', 1200);

-- 식단 table(primary key: 누가(userid), 언제(dietdate), 어떤 type(예:아침), 어떤 메뉴(예:라면))
create table diet(
	user_id varchar(30) not null,
    diet_date timestamp default now(),
    diet_type_id int not null,
    diet_menu_id int not null,
    total_calorie double default 0,
    primary key(user_id, diet_date, diet_type_id, diet_menu_id),
    foreign key(user_id) references user(user_id),
    foreign key(diet_type_id) references diet_type(diet_type_id),
    foreign key(diet_menu_id) references diet_menu(diet_menu_id)
);

insert into diet(user_id, diet_type_id, diet_menu_id) values('spider', 1, 1);
insert into diet(user_id, diet_type_id, diet_menu_id) values('spider', 1, 2);
insert into diet(user_id, diet_type_id, diet_menu_id) values('spider', 2, 5);
insert into diet(user_id, diet_type_id, diet_menu_id) values('spider', 3, 4);
insert into diet(user_id, diet_type_id, diet_menu_id) values('spider', 4, 3);
insert into diet(user_id, diet_type_id, diet_menu_id) values('hulk', 1, 5);
insert into diet(user_id, diet_type_id, diet_menu_id) values('hulk', 2, 1);
insert into diet(user_id, diet_type_id, diet_menu_id) values('hulk', 2, 2);
insert into diet(user_id, diet_type_id, diet_menu_id) values('hulk', 3, 4);
insert into diet(user_id, diet_type_id, diet_menu_id) values('hulk', 4, 3);
insert into diet(user_id, diet_type_id, diet_menu_id) values('scarlet', 1, 3);
insert into diet(user_id, diet_type_id, diet_menu_id) values('scarlet', 2, 1);
insert into diet(user_id, diet_type_id, diet_menu_id) values('scarlet', 2, 4);
insert into diet(user_id, diet_type_id, diet_menu_id) values('scarlet', 3, 2);
insert into diet(user_id, diet_type_id, diet_menu_id) values('scarlet', 4, 5);
insert into diet(user_id, diet_type_id, diet_menu_id) values('natasha', 1, 3);
insert into diet(user_id, diet_type_id, diet_menu_id) values('natasha', 2, 1);
insert into diet(user_id, diet_type_id, diet_menu_id) values('natasha', 3, 2);
insert into diet(user_id, diet_type_id, diet_menu_id) values('natasha', 4, 5);
insert into diet(user_id, diet_type_id, diet_menu_id) values('panther', 1, 1);
insert into diet(user_id, diet_type_id, diet_menu_id) values('panther', 2, 2);
insert into diet(user_id, diet_type_id, diet_menu_id) values('panther', 3, 5);
insert into diet(user_id, diet_type_id, diet_menu_id) values('panther', 3, 4);
insert into diet(user_id, diet_type_id, diet_menu_id) values('panther', 4, 3);

-- 운동 type table(유산소은동, 근력운동등)
create table fitness_type(
	fitness_type_id int auto_increment,
    fitness_type_name varchar(30) not null,
    primary key(fitness_type_id)
);

insert into fitness_type(fitness_type_name) values('유산소운동');
insert into fitness_type(fitness_type_name) values('근력운동');

-- 운동 메뉴(달리기, 팔굽혀펴기 등)
create table fitness_menu(
	fitness_menu_id int auto_increment,
    fitness_menu_name varchar(30) not null,
    fitness_type_id int not null,
    primary key(fitness_menu_id),
    foreign key(fitness_type_id) references fitness_type(fitness_type_id)
);

insert into fitness_menu(fitness_type_id, fitness_menu_name) values(1, '달리기');
insert into fitness_menu(fitness_type_id, fitness_menu_name) values(1, '걷기');
insert into fitness_menu(fitness_type_id, fitness_menu_name) values(1, '자전거');
insert into fitness_menu(fitness_type_id, fitness_menu_name) values(2, '팔굽혀펴기');
insert into fitness_menu(fitness_type_id, fitness_menu_name) values(2, '윗몸일으키기');

-- 유산소 운동 table(primary key(누가(userid), 언제(fitnessdate), 어떤메뉴운동(예:달리기))
create table fitness_cardio(
	user_id varchar(30) not null,
    fitness_date timestamp default now(),
    fitness_menu_id int not null,
    fitness_hours int not null,
    distance int not null,
    number_steps int not null,
    used_calorie int not null,
    primary key(user_id, fitness_date, fitness_menu_id),
    foreign key(user_id) references user(user_id),
    foreign key(fitness_menu_id) references fitness_menu(fitness_menu_id)
);

insert into fitness_cardio(user_id, fitness_menu_id, fitness_hours, distance, number_steps, used_calorie) 
values('spider', 1, 30, 2000, 3500, 600);
insert into fitness_cardio(user_id, fitness_menu_id, fitness_hours, distance, number_steps, used_calorie) 
values('hulk', 2, 60, 2000, 3000, 500);
insert into fitness_cardio(user_id, fitness_menu_id, fitness_hours, distance, number_steps, used_calorie) 
values('scarlet', 3, 30, 4000, 4000, 800);
insert into fitness_cardio(user_id, fitness_menu_id, fitness_hours, distance, number_steps, used_calorie) 
values('natasha', 1, 20, 1500, 2800, 400);
insert into fitness_cardio(user_id, fitness_menu_id, fitness_hours, distance, number_steps, used_calorie) 
values('panther', 2, 40, 1500, 2000, 300);

-- 근력 운동 table(primary key(누가(userid), 언제(fitnessdate), 어떤메뉴운동(예:달리기))
create table fitness_weight(
	user_id varchar(30) not null,
    fitness_date timestamp default now(),
    fitness_menu_id int not null,
    fitness_hours int not null,
    used_calorie int not null,
    primary key(user_id, fitness_date, fitness_menu_id),
    foreign key(user_id) references user(user_id),
    foreign key(fitness_menu_id) references fitness_menu(fitness_menu_id)
);

insert into fitness_weight(user_id, fitness_menu_id, fitness_hours, used_calorie) values('spider', 4, 10, 600);
insert into fitness_weight(user_id, fitness_menu_id, fitness_hours, used_calorie) values('hulk', 4, 30, 1800);
insert into fitness_weight(user_id, fitness_menu_id, fitness_hours, used_calorie) values('scarlet', 5, 20, 800);
insert into fitness_weight(user_id, fitness_menu_id, fitness_hours, used_calorie) values('natasha', 5, 15, 600);
insert into fitness_weight(user_id, fitness_menu_id, fitness_hours, used_calorie) values('panther', 4, 20, 1200);

-- 수면 table
create table sleeping(
	user_id varchar(30) not null,
	sleeping_date timestamp default now(),
    sleeping_hours int not null,
    snoring_hours int not null,
    primary key(sleeping_date),
    foreign key(user_id) references user(user_id)
);

insert into sleeping(user_id, sleeping_hours, snoring_hours) values('spider', 480, 30);
insert into sleeping(user_id, sleeping_hours, snoring_hours) values('hulk', 300, 30);
insert into sleeping(user_id, sleeping_hours, snoring_hours) values('scarlet', 360, 30);
insert into sleeping(user_id, sleeping_hours, snoring_hours) values('natasha', 400, 30);
insert into sleeping(user_id, sleeping_hours, snoring_hours) values('panther', 540, 30);

-- 음주 table
create table drinking(
	user_id varchar(30) not null,
	drinking_date timestamp default now(),
    alcohol_content double not null,
    primary key(drinking_date),
    foreign key(user_id) references user(user_id)
);

insert into drinking(user_id, alcohol_content) values('spider', 0.8);
insert into drinking(user_id, alcohol_content) values('hulk', 1.2);
insert into drinking(user_id, alcohol_content) values('scarlet', 0.5);
insert into drinking(user_id, alcohol_content) values('natasha', 0.3);
insert into drinking(user_id, alcohol_content) values('panther', 0.6);

-- 각 table 조회
select * from user;
select * from diet;
select * from diet_menu;
select * from diet_type;
select * from fitness_menu;
select * from fitness_type;
select * from fitness_cardio;
select * from fitness_weight;
select * from sleeping;
select * from drinking;

-- user별 전체 정보 조회
select * from user, diet, fitness_cardio, fitness_weight, sleeping, drinking
where user.user_id=diet.user_id and user.user_id=fitness_cardio.user_id 
and user.user_id=fitness_weight.user_id and user.user_id=sleeping.user_id and user.user_id=drinking.user_id
group by user.user_id;

-- user별 식단 정보 조회
select user.user_id, user.name, diet_type.diet_type_name, diet_menu.diet_menu_name, diet.diet_date, diet.total_calorie
from user, diet, diet_menu, diet_type
where user.user_id=diet.user_id and diet.diet_type_id=diet_type.diet_type_id and diet.diet_menu_id=diet_menu.diet_menu_id
order by user_id;

-- user별 유산소운동 정보 조회
select user.user_id, user.name, fitness_type.fitness_type_name, fitness_menu.fitness_menu_name, 
fitness_cardio.fitness_date, fitness_cardio.fitness_hours, fitness_cardio.distance, fitness_cardio.number_steps, fitness_cardio.used_calorie
from user, fitness_type, fitness_menu, fitness_cardio
where user.user_id=fitness_cardio.user_id and fitness_type.fitness_type_id=fitness_menu.fitness_type_id and
fitness_menu.fitness_menu_id=fitness_cardio.fitness_menu_id and fitness_menu.fitness_type_id=fitness_type.fitness_type_id;

-- user별 근력운동 정보 조회
select user.user_id, user.name, fitness_type.fitness_type_name, fitness_menu.fitness_menu_name, 
fitness_weight.fitness_date, fitness_weight.fitness_hours
from user, fitness_type, fitness_menu, fitness_weight
where user.user_id=fitness_weight.user_id and fitness_type.fitness_type_id=fitness_menu.fitness_type_id and
fitness_menu.fitness_menu_id=fitness_weight.fitness_menu_id and fitness_menu.fitness_type_id=fitness_type.fitness_type_id;

-- user별 수면 정보 조회
select user.user_id, user.name, sleeping.sleeping_date, sleeping.sleeping_hours, sleeping.snoring_hours
from user, sleeping
where user.user_id=sleeping.user_id;

-- user별 음주 정보 조회
select user.user_id, user.name, drinking.drinking_date, drinking.alcohol_content
from user, drinking
where user.user_id=drinking.user_id;





























