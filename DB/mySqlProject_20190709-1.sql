-- root에서 설정, database명: project, userid: calog, password:if 
create database project;
create user 'calog'@'localhost' identified by 'if';
grant all privileges on *.* to 'calog'@'localhost';

use project;

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

desc user;
desc diet_menu;
desc diet;
desc diet_type;
desc sleeping;
desc drinking;

desc user_diet_view;
desc user_total_calories_view;
desc user_fitness_cardio_view;
desc user_total_cardio_view;
desc user_fitness_weight_view;
desc user_total_weight_view;
desc user_fitness_favorite_view;


-- ======================================= 각 table 정보 조회 시작 =========================================================

-- user별 전체 정보 조회
select * from user, diet, fitness_cardio, fitness_weight, sleeping, drinking
	where user.user_id=diet.user_id and user.user_id=fitness_cardio.user_id 
		and user.user_id=fitness_weight.user_id and user.user_id=sleeping.user_id 
        and user.user_id=drinking.user_id
	group by user.user_id;

-- user별 식단 정보 조회 
create view user_diet_view as(
	select user.user_id, user.name, diet_type.diet_type_id, diet_type.diet_type_name, diet_menu.diet_menu_name, 
		diet.diet_amount, diet_menu.calorie, diet.sum_calorie, diet.diet_date
	from user, diet, diet_menu, diet_type
	where user.user_id=diet.user_id and diet.diet_type_id=diet_type.diet_type_id 
		and diet.diet_menu_id=diet_menu.diet_menu_id
	order by user_id, diet_date, diet_type_id
);
select * from user_diet_view;

-- 특정 user가 특정일에 먹은 메뉴 리스트(spider& 2019/07/01 2271kcal)
select * from user_diet_view 
where user_id='spider' and diet_date='2019/07/01';

-- user별 먹은 총 칼로리(spider& 2019/07/01 2271kcal)
create view user_total_calories_view as(
	select user.user_id, user.name, sum(diet.sum_calorie), diet.diet_date
	from user, diet, diet_menu, diet_type
	where user.user_id=diet.user_id and diet_menu.diet_menu_id=diet.diet_menu_id 
		and diet_type.diet_type_id=diet.diet_type_id
	group by diet.diet_date
    order by user.user_id
);
select * from user_total_calories_view;

-- 특정 user가 특정일 먹은 총 칼로리(spider& 2019/07/01 2271kcal)
select * from user_total_calories_view 
where user_id='spider' and diet_date='2019/07/01';

-- user별 유산소운동 정보 조회
create view user_fitness_cardio_view as(
	select user.user_id, user.name, fitness_type.fitness_type_name, 
		fitness_menu.fitness_menu_name, fitness_cardio.fitness_date, 
        fitness_cardio.fitness_seconds, fitness_cardio.distance, 
		fitness_cardio.number_steps, fitness_cardio.used_calorie
	from user, fitness_type, fitness_menu, fitness_cardio
	where user.user_id=fitness_cardio.user_id 
		and fitness_type.fitness_type_id=fitness_menu.fitness_type_id 
		and	fitness_menu.fitness_menu_id=fitness_cardio.fitness_menu_id
    order by user_id, fitness_date, fitness_menu_name
);
select * from user_fitness_cardio_view;

-- 특정 user가 특정일에 유산소 운동한 리스트
select * from user_fitness_cardio_view
where user_id='spider' and fitness_date='2019/07/01';

-- user별 유산소 운동한 총 시간, 총 거리, 총 걸음수, 총 소모 칼로리
create view user_total_cardio_view as(
	select user.user_id, user.name, sum(fitness_cardio.fitness_seconds), 
		sum(fitness_cardio.distance), sum(fitness_cardio.number_steps), 
        sum(fitness_cardio.used_calorie), fitness_cardio.fitness_date
	from user, fitness_type, fitness_menu, fitness_cardio
	where user.user_id=fitness_cardio.user_id 
		and fitness_type.fitness_type_id=fitness_menu.fitness_type_id 
		and fitness_menu.fitness_menu_id=fitness_cardio.fitness_menu_id
	group by fitness_cardio.fitness_date
    order by user.user_id
);
select * from user_total_cardio_view;

-- 특정 user가 특정일에 유산소 운동한 총 시간, 총 거리, 총 걸음수, 총 소모 칼로리
select * from user_total_cardio_view
where user_id='spider' and fitness_date='2019/07/01';

-- user별 근력운동 정보 조회
create view user_fitness_weight_view as(
	select user.user_id, user.name, fitness_type.fitness_type_name, 
		fitness_menu.fitness_menu_name, fitness_weight.fitness_date, 
        fitness_weight.fitness_seconds, fitness_menu.unit_calorie
	from user, fitness_type, fitness_menu, fitness_weight
	where user.user_id=fitness_weight.user_id 
		and fitness_type.fitness_type_id=fitness_menu.fitness_type_id 
		and	fitness_menu.fitness_menu_id=fitness_weight.fitness_menu_id
    order by user_id, fitness_date, fitness_menu_name
);
select * from user_fitness_weight_view;

-- 특정 user가 특정일에 근력 운동한 리스트
select * from user_fitness_weight_view
where user_id='spider' and fitness_date='2019/07/01';

-- 특정 user가 특정일에 근력 운동한 총 시간, 총 소모 칼로리
create view user_total_weight_view as(
	select user.user_id, user.name, fitness_type.fitness_type_name, 
		sum(fitness_weight.fitness_seconds), 
		sum(fitness_weight.used_calorie), fitness_weight.fitness_date
	from user, fitness_type, fitness_menu, fitness_weight
	where user.user_id=fitness_weight.user_id 
		and fitness_type.fitness_type_id=fitness_menu.fitness_type_id 
		and	fitness_menu.fitness_menu_id=fitness_weight.fitness_menu_id 
		and fitness_menu.fitness_type_id=fitness_type.fitness_type_id
	group by fitness_weight.fitness_date
    order by user.user_id
);
select * from user_total_weight_view;

-- 특정 user가 특정일에 근력 운동한 총 시간, 총 소모 칼로리(680.4)
select * from user_total_weight_view
where user_id='spider' and fitness_date='2019/07/01';

-- user별 운동한 리스트(즐겨찾기 리스트)
create view user_fitness_favorite_view as(
	select user.user_id, user.name, fitness_type.fitness_type_name, 
		fitness_menu.fitness_menu_name
	from user, fitness_type, fitness_menu
	where fitness_type.fitness_type_id=fitness_menu.fitness_type_id
    order by user.user_id
);
select * from user_fitness_favorite_view;

-- 특정 user가 운동한 리스트(즐겨찾기 리스트)
select * from user_fitness_favorite_view
where user_id='spider';



-- 특정 user의 특정일에 대한 수면 정보 조회
select * from sleeping
where user_id='spider' and sleeping_date='2019/07/01';

-- 특정 user의 특정일에 대한 음주 정보 조회
select * from drinking
where user_id='spider' and drinking_date='2019/07/01';

-- ======================================= 각 table 정보 조회 종료 =========================================================

drop table user;
drop table diet;
drop table diet_menu;
drop table diet_type;
drop table drinking;
drop table fitness_cardio;
drop table fitness_menu;
drop table fitness_weight;
drop table fitness_type;
drop table sleeping;

-- 칼로리 단위: kcal, 시간 단위: 초(seconds)로 통일

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
    diet_menu_name varchar(50) not null,
    calorie int not null,
    primary key(diet_menu_id)
);

-- insert into diet_menu(diet_menu_name, calorie) values('라면', 1500);
-- insert into diet_menu(diet_menu_name, calorie) values('김밥', 700);
-- insert into diet_menu(diet_menu_name, calorie) values('쫄면', 800);
-- insert into diet_menu(diet_menu_name, calorie) values('우동', 900);
-- insert into diet_menu(diet_menu_name, calorie) values('짜장면', 1200);

-- 식단 table(primary key: diet_id / 누가(userid), 언제(dietdate), 어떤 type(예:아침), 어떤 메뉴(예:라면))
create table diet(
	diet_id int auto_increment,
	user_id varchar(30) not null,
    diet_date timestamp default now(),
    diet_type_id int not null,
    diet_menu_id int not null,
    diet_amount int not null,
    sum_calorie int not null,
    primary key(diet_id),
    foreign key(user_id) references user(user_id),
    foreign key(diet_type_id) references diet_type(diet_type_id),
    foreign key(diet_menu_id) references diet_menu(diet_menu_id)
);

-- ============================================================================
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/01', 1, 94, 1, 150);
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/01', 1, 660, 1, 32);
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/01', 1, 662, 1, 37);
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/01', 1, 665, 1, 41);
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/01', 1, 2889, 1, 61);
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/01', 2, 2928, 1, 175);
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/01', 2, 2711, 1, 38);
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/01', 2, 1396, 2, 62);
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/01', 3, 1586, 2, 938);
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/01', 3, 2763, 2, 356);
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/01', 3, 95, 1, 152);
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/01', 3, 2908, 1, 37);
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/01', 4, 2986, 1, 192);
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/02', 1, 2935, 1, 161);
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/02', 1, 2936, 1, 172);
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/02', 1, 2715, 1, 46);
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/02', 2, 2973, 1, 122);
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/02', 2, 2010, 1, 266);
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/02', 3, 94, 1, 150);
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/02', 3, 652, 1, 38);
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/02', 3, 747, 1, 118);
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/02', 3, 1030, 1, 10);
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/02', 3, 1376, 1, 53);
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/02', 3, 2907, 1, 175);
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/02', 3, 2756, 2, 92);
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/02', 4, 2910, 1, 151);
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/03', 1, 1333, 1, 84);
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/03', 1, 2010, 1, 266);
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/03', 2, 2901, 1, 156);
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/03', 2, 2715, 1, 46);
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/03', 3, 1652, 1, 387);
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/03', 3, 2762, 2, 254);
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/03', 3, 2756, 2, 92);
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/03', 3, 655, 1, 25);
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/03', 3, 2895, 1, 69);
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/03', 4, 2915, 1, 189);
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/04', 1, 2986, 1, 192);
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/04', 1, 2936, 1, 172);
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/04', 1, 2711, 1, 38);
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/04', 2, 2990, 1, 32);
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/04', 2, 2715, 2, 92);
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/04', 3, 2947, 1, 67);
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/04', 3, 2763, 1, 178);
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/04', 3, 655, 1, 25);
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/04', 4, 2887, 1, 161);
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/04', 4, 2739, 1, 40);
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/05', 1, 2941, 1, 218);
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/05', 1, 2609, 1, 65);
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/05', 1, 2715, 1, 46);
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/05', 2, 2946, 1, 79);
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/05', 2, 2715, 1, 46);
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/05', 3, 94, 1, 150);
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/05', 3, 651, 1, 88);
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/05', 3, 652, 1, 38);
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/05', 3, 1627, 1, 201);
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/05', 3, 1834, 1, 143);
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/05', 3, 2756, 3, 138);
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/05', 3, 2908, 1, 37);
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/05', 4, 1396, 1, 31);
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/05', 4, 2745, 1, 38);
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/06', 1, 2990, 1, 32);
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/06', 1, 655, 1, 25);
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/06', 2, 3005, 1, 229);
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/06', 2, 2745, 1, 38);
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/06', 3, 1586, 2, 938);
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/06', 3, 667, 1, 30);
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/06', 3, 2762, 3, 381);
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/06', 4, 2914, 1, 101);
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/06', 4, 2756, 1, 46);
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/07', 1, 1844, 1, 149);
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/07', 1, 2947, 1, 67);
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/07', 1, 2711, 1, 38);
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/07', 2, 3005, 1, 229);
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/07', 2, 2745, 1, 38);
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/07', 3, 92, 1, 415);
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/07', 3, 666, 1, 49);
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/07', 3, 748, 1, 113);
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/07', 3, 1080, 1, 10);
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/07', 3, 1396, 1, 31);
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/07', 3, 1834, 1, 143);
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/07', 3, 2756, 2, 92);
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/07', 4, 3000, 1, 233);
insert into diet(user_id, diet_date, diet_type_id, diet_menu_id, diet_amount, sum_calorie) values('spider','2019/07/07', 4, 2745, 1, 38);

-- 즉석밥, 누룽지 92 즉석밥, 잡곡밥(멥쌀, 찹쌀, 흑미, 팥, 기장, 찰수수) 94 즉석밥, 백미 95 김치, 갓 김치 650  김치, 고들빼기 651 김치, 깍두기 652 김치, 나박 김치 653 김치, 동치미 654
-- 김치, 배추 김치 655 김치, 열무 김치 660 김치, 오이 소박이 662 김치, 총각 김치 665 김치, 파 김치 666 김치, 얼갈이배추 김치 667 마늘쫑 장아찌 747 마늘 장아찌 748 오이지, 염절임 1030
-- 토마토, 방울토마토, 생것 1122 피망, 빨간색, 생것 1153 감, 연시, 생것 1264 바나나, 생것 1333 사과, 부사(후지), 생것 1376 수박, 적육질, 생것 1396 닭고기, 전체, 튀긴것 1514 돼지고기, 삼겹살(삼겹살), 구운것(팬) 1586
-- 햄, 런천미트햄 1627 소고기, 한우, 등심, 구운것(팬) 1652 달걀, 삶은것 1834 달걀부침, 부친것 1842 스크램블에그, 볶은것 1844 멸치 볶음, 멸치풋고추볶음 2010 우유 2609 커피, 캔 2711 커피, 커피믹스, 물에 탄것(커피믹스 12g) 2715
-- 탄산 음료, 사이다 2739 탄산 음료, 콜라 2745 맥주, 알코올 4.5% 2756 소주, 알코올 17.8% 2762 소주, 알코올 25% 2763 김밥 2884 김밥, 김치 김밥 2885 김밥, 샐러드 김밥 2886 김밥, 소고기 김밥 2887 김밥, 참치 김밥 2888
-- 김치찌개 2889 깐풍기 2890 냉면, 물냉면 2895 냉면, 비빔냉면 2896 냉면, 회냉면 2898 덮밥, 불고기 덮밥 2899 덮밥, 오징어 덮밥 2900 덮밥, 제육 덮밥 2901 덮밥, 참치 덮밥 2902 덮밥, 회 덮밥 2903 돼지고기 볶음 2907
-- 된장찌개 2908 떡만둣국 2909 떡볶이 2910 라면, 조리후 2914 라면, 비빔라면, 끓인것 2915 만두, 물만두 2922 볶음밥, 김치 볶음밥 2927 볶음밥, 새우 볶음밥 2928 볶음밥, 오므라이스 2929 비빔밥 2932 삼각김밥, 고추장 불고기 2934
-- 삼각김밥, 숯불갈비 2935 삼각김밥, 참치 마요네즈 2936 삼계탕 2937 샌드위치, 닭고기 2938 샌드위치, 소고기 2940 샌드위치, 햄, 치즈 2941 소머리국밥 2946 순대국 2947 짜장면 2973 짬뽕 2976 컵라면, 면, 조리후 2986 콩나물해장국 2990
-- 탕수육 2994 튀김, 김말이튀김 2995 피자, 슈퍼슈프림 피자, 냉동 3000 햄버거, 소고기패티, 토마토, 양상추, 양파 3005 


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
    fitness_menu_name varchar(50) not null,
    fitness_menu_image varchar(200) not null,
    unit_calorie double not null, 
    fitness_type_id int not null,
    primary key(fitness_menu_id),
    foreign key(fitness_type_id) references fitness_type(fitness_type_id)
);

insert into fitness_menu(fitness_type_id, fitness_menu_name, fitness_menu_image, unit_calorie) 
values(1, '걷기-4.2km/h', 'https://www.jefit.com/images/exercises/800_600/1288.jpg', 0.05);
insert into fitness_menu(fitness_type_id, fitness_menu_name, fitness_menu_image, unit_calorie) 
values(1, '빠른걷기-6km/h', 'https://www.jefit.com/images/exercises/800_600/1288.jpg', 0.06);
insert into fitness_menu(fitness_type_id, fitness_menu_name, fitness_menu_image, unit_calorie) 
values(1, '등산', 'http://health.chosun.com/site/data/img_dir/2019/03/29/2019032901549_0.jpg', 0.083);
insert into fitness_menu(fitness_type_id, fitness_menu_name, fitness_menu_image, unit_calorie) 
values(1, '달리기(조깅)-8km/h', 'https://www.jefit.com/images/exercises/800_600/1268.jpg', 0.163);
insert into fitness_menu(fitness_type_id, fitness_menu_name, fitness_menu_image, unit_calorie) 
values(1, '달리기-10km/h', 'https://www.jefit.com/images/exercises/800_600/1268.jpg', 0.204);
insert into fitness_menu(fitness_type_id, fitness_menu_name, fitness_menu_image, unit_calorie) 
values(1, '달리기-11km/h', 'https://www.jefit.com/images/exercises/800_600/1268.jpg', 0.245);
insert into fitness_menu(fitness_type_id, fitness_menu_name, fitness_menu_image, unit_calorie) 
values(1, '달리기-13km/h', 'https://www.jefit.com/images/exercises/800_600/1268.jpg', 0.276);
insert into fitness_menu(fitness_type_id, fitness_menu_name, fitness_menu_image, unit_calorie) 
values(1, '달리기-14km/h', 'https://www.jefit.com/images/exercises/800_600/1268.jpg', 0.306);
insert into fitness_menu(fitness_type_id, fitness_menu_name, fitness_menu_image, unit_calorie) 
values(1, '달리기-16km/h', 'https://www.jefit.com/images/exercises/800_600/1268.jpg', 0.327);
insert into fitness_menu(fitness_type_id, fitness_menu_name, fitness_menu_image, unit_calorie) 
values(1, '자전거(싸이클)', 'https://www.jefit.com/images/exercises/800_600/1260.jpg', 0.163);
insert into fitness_menu(fitness_type_id, fitness_menu_name, fitness_menu_image, unit_calorie) 
values(1, '자전거(중간속도)-21km/h', 'https://www.jefit.com/images/exercises/800_600/1260.jpg', 0.163);
insert into fitness_menu(fitness_type_id, fitness_menu_name, fitness_menu_image, unit_calorie) 
values(1, '자전거(빠른속도)-24km/h', 'https://www.jefit.com/images/exercises/800_600/1260.jpg', 0.204);
insert into fitness_menu(fitness_type_id, fitness_menu_name, fitness_menu_image, unit_calorie) 
values(1, '자전거(매우빠른속도)-28km/h', 'https://www.jefit.com/images/exercises/800_600/1260.jpg', 0.245);
insert into fitness_menu(fitness_type_id, fitness_menu_name, fitness_menu_image, unit_calorie) 
values(1, '산악자전거', 'https://www.jefit.com/images/exercises/800_600/1252.jpg', 0.163);
insert into fitness_menu(fitness_type_id, fitness_menu_name, fitness_menu_image, unit_calorie) 
values(1, '계단오르기', 'https://www.jefit.com/images/exercises/800_600/1276.jpg', 0.163);
insert into fitness_menu(fitness_type_id, fitness_menu_name, fitness_menu_image, unit_calorie) 
values(1, '계단 뛰어오르기', 'http://hub.zum.com/view/photo?url=http%3A%2F%2Fstatic.hubzum.zumst.com%2Fhubzum%2F2017%2F10%2F25%2F14%2F188bb592e79740d780dce38daaa585c6.jpg', 0.237);
insert into fitness_menu(fitness_type_id, fitness_menu_name, fitness_menu_image, unit_calorie) 
values(1, '인라인스케이팅', 'https://www.jefit.com/images/exercises/800_600/3752.jpg', 0.204);
insert into fitness_menu(fitness_type_id, fitness_menu_name, fitness_menu_image, unit_calorie) 
values(1, '줄넘기', 'https://www.jefit.com/images/exercises/800_600/3708.jpg', 0.204);
insert into fitness_menu(fitness_type_id, fitness_menu_name, fitness_menu_image, unit_calorie) 
values(2, '가슴, 1 Leg Pushup', 'https://www.jefit.com/images/exercises/800_600/4213.jpg', 0.16);
insert into fitness_menu(fitness_type_id, fitness_menu_name, fitness_menu_image, unit_calorie) 
values(2, '가슴, Clap Push Up', 'https://www.jefit.com/images/exercises/800_600/2909.jpg', 0.16);
insert into fitness_menu(fitness_type_id, fitness_menu_name, fitness_menu_image, unit_calorie)  
values(2, '가슴, Close Hand Pushup', 'https://www.jefit.com/images/exercises/800_600/3441.jpg', 0.1);
insert into fitness_menu(fitness_type_id, fitness_menu_name, fitness_menu_image, unit_calorie) 
values(2, '가슴, Push Up', 'https://www.jefit.com/images/exercises/800_600/189.jpg', 0.095);
insert into fitness_menu(fitness_type_id, fitness_menu_name, fitness_menu_image, unit_calorie) 
values(2, '가슴, Push Up to Side Plank', 'https://www.jefit.com/images/exercises/800_600/3433.jpg', 0.1);
insert into fitness_menu(fitness_type_id, fitness_menu_name, fitness_menu_image, unit_calorie)  
values(2, '가슴, Wide Hand Pushup', 'https://www.jefit.com/images/exercises/800_600/3445.jpg', 0.095);
insert into fitness_menu(fitness_type_id, fitness_menu_name, fitness_menu_image, unit_calorie)  
values(2, '등, Hyperextensions With No Bench', 'https://www.jefit.com/images/exercises/800_600/1417.jpg', 0.052);
insert into fitness_menu(fitness_type_id, fitness_menu_name, fitness_menu_image, unit_calorie)  
values(2, '등, Spine Twist', 'https://www.jefit.com/images/exercises/800_600/2725.jpg', 0.052);
insert into fitness_menu(fitness_type_id, fitness_menu_name, fitness_menu_image, unit_calorie) 
values(2, '복근, Ab Draw Leg Slide', 'https://www.jefit.com/images/exercises/800_600/2681.jpg', 0.15);
insert into fitness_menu(fitness_type_id, fitness_menu_name, fitness_menu_image, unit_calorie) 
values(2, '복근, Abdominal Pendulum', 'https://www.jefit.com/images/exercises/800_600/3869.jpg', 0.15);
insert into fitness_menu(fitness_type_id, fitness_menu_name, fitness_menu_image, unit_calorie) 
values(2, '복근, Air Bike', 'https://www.jefit.com/images/exercises/800_600/228.jpg', 0.15);
insert into fitness_menu(fitness_type_id, fitness_menu_name, fitness_menu_image, unit_calorie)  
values(2, '복근, Alternate Heel Touchers', 'https://www.jefit.com/images/exercises/800_600/232.jpg', 0.15);
insert into fitness_menu(fitness_type_id, fitness_menu_name, fitness_menu_image, unit_calorie) 
values(2, '복근, Alternate Leg Bridge', 'https://www.jefit.com/images/exercises/800_600/2440.jpg', 0.15);
insert into fitness_menu(fitness_type_id, fitness_menu_name, fitness_menu_image, unit_calorie) 
values(2, '복근, Alternate Reach and Catch', 'https://www.jefit.com/images/exercises/800_600/3872.jpg', 0.15);
insert into fitness_menu(fitness_type_id, fitness_menu_name, fitness_menu_image, unit_calorie) 
values(2, '복근, Alternating Arm Cobra', 'https://www.jefit.com/images/exercises/800_600/2504.jpg', 0.15);
insert into fitness_menu(fitness_type_id, fitness_menu_name, fitness_menu_image, unit_calorie) 
values(2, '복근, Bent Knee Hip Raise', 'https://www.jefit.com/images/exercises/800_600/1225.jpg', 0.15);
insert into fitness_menu(fitness_type_id, fitness_menu_name, fitness_menu_image, unit_calorie) 
values(2, '복근, Bent Knee Hundreds', 'https://www.jefit.com/images/exercises/800_600/2569.jpg', 0.15);
insert into fitness_menu(fitness_type_id, fitness_menu_name, fitness_menu_image, unit_calorie) 
values(2, '복근, Butt-Ups', 'https://www.jefit.com/images/exercises/800_600/1309.jpg', 0.15);
insert into fitness_menu(fitness_type_id, fitness_menu_name, fitness_menu_image, unit_calorie) 
values(2, '복근, Cobra', 'https://www.jefit.com/images/exercises/800_600/2501.jpg', 0.15);
insert into fitness_menu(fitness_type_id, fitness_menu_name, fitness_menu_image, unit_calorie) 
values(2, '복근, Cross Body Crunch', 'https://www.jefit.com/images/exercises/800_600/281.jpg', 0.15);
insert into fitness_menu(fitness_type_id, fitness_menu_name, fitness_menu_image, unit_calorie) 
values(2, '복근, Crunch with Hands Overhead', 'https://www.jefit.com/images/exercises/800_600/1313.jpg', 0.15);
insert into fitness_menu(fitness_type_id, fitness_menu_name, fitness_menu_image, unit_calorie) 
values(2, '복근, Crunches', 'https://www.jefit.com/images/exercises/800_600/309.jpg', 0.15);
insert into fitness_menu(fitness_type_id, fitness_menu_name, fitness_menu_image, unit_calorie) 
values(2, '복근, Double Leg Hundreds', 'https://www.jefit.com/images/exercises/800_600/2565.jpg', 0.15);
insert into fitness_menu(fitness_type_id, fitness_menu_name, fitness_menu_image, unit_calorie) 
values(2, '복근, Frog Sit Ups', 'https://www.jefit.com/images/exercises/800_600/277.jpg', 0.15);
insert into fitness_menu(fitness_type_id, fitness_menu_name, fitness_menu_image, unit_calorie) 
values(2, '복근, Jackknife Sit up', 'https://www.jefit.com/images/exercises/800_600/253.jpg', 0.15);
insert into fitness_menu(fitness_type_id, fitness_menu_name, fitness_menu_image, unit_calorie) 
values(2, '복근, Janda Sit Up', 'https://www.jefit.com/images/exercises/800_600/1325.jpg', 0.15);
insert into fitness_menu(fitness_type_id, fitness_menu_name, fitness_menu_image, unit_calorie) 
values(2, '복근, Leg Raise', 'https://www.jefit.com/images/exercises/800_600/177.jpg', 0.15);
insert into fitness_menu(fitness_type_id, fitness_menu_name, fitness_menu_image, unit_calorie) 
values(2, '복근, Lying Alternate Floor Leg Raise', 'https://www.jefit.com/images/exercises/800_600/3933.jpg', 0.15);
insert into fitness_menu(fitness_type_id, fitness_menu_name, fitness_menu_image, unit_calorie) 
values(2, '복근, Lying Floor Knee Raise', 'https://www.jefit.com/images/exercises/800_600/3945.jpg', 0.15);
insert into fitness_menu(fitness_type_id, fitness_menu_name, fitness_menu_image, unit_calorie) 
values(2, '복근, Lying to Side Plank', 'https://www.jefit.com/images/exercises/800_600/2533.jpg', 0.15);
insert into fitness_menu(fitness_type_id, fitness_menu_name, fitness_menu_image, unit_calorie) 
values(2, '복근, Plank', 'https://www.jefit.com/images/exercises/800_600/2524.jpg', 0.06);
insert into fitness_menu(fitness_type_id, fitness_menu_name, fitness_menu_image, unit_calorie) 
values(2, '복근, Plank with Side Kick', 'https://www.jefit.com/images/exercises/800_600/2513.jpg', 0.06);
insert into fitness_menu(fitness_type_id, fitness_menu_name, fitness_menu_image, unit_calorie) 
values(2, '복근, Sit Up', 'https://www.jefit.com/images/exercises/800_600/1381.jpg', 0.15);
insert into fitness_menu(fitness_type_id, fitness_menu_name, fitness_menu_image, unit_calorie) 
values(2, '복근, Tuck Crunch', 'https://www.jefit.com/images/exercises/800_600/285.jpg', 0.15);
insert into fitness_menu(fitness_type_id, fitness_menu_name, fitness_menu_image, unit_calorie) 
values(2, '복근, Twisting Floor Crunch', 'https://www.jefit.com/images/exercises/800_600/4001.jpg', 0.15);
insert into fitness_menu(fitness_type_id, fitness_menu_name, fitness_menu_image, unit_calorie) 
values(2, '복근, Two Leg Slide', 'https://www.jefit.com/images/exercises/800_600/2353.jpg', 0.15);
insert into fitness_menu(fitness_type_id, fitness_menu_name, fitness_menu_image, unit_calorie) 
values(2, '복근, V Ups', 'https://www.jefit.com/images/exercises/800_600/2745.jpg', 0.06);
insert into fitness_menu(fitness_type_id, fitness_menu_name, fitness_menu_image, unit_calorie) 
values(2, '팔뚝, Modified Push Up to Forearms', 'https://www.jefit.com/images/exercises/800_600/2509.jpg', 0.17);
insert into fitness_menu(fitness_type_id, fitness_menu_name, fitness_menu_image, unit_calorie) 
values(2, '둔근, Bridge', 'https://www.jefit.com/images/exercises/800_600/777.jpg', 0.06);
insert into fitness_menu(fitness_type_id, fitness_menu_name, fitness_menu_image, unit_calorie) 
values(2, '둔근, Flutter Kick', 'https://www.jefit.com/images/exercises/800_600/793.jpg', 0.15);
insert into fitness_menu(fitness_type_id, fitness_menu_name, fitness_menu_image, unit_calorie) 
values(2, '둔근, Glute Kickback', 'https://www.jefit.com/images/exercises/800_600/1549.jpg', 0.15);
insert into fitness_menu(fitness_type_id, fitness_menu_name, fitness_menu_image, unit_calorie) 
values(2, '둔근, Leg Lift', 'https://www.jefit.com/images/exercises/800_600/781.jpg', 0.15);
insert into fitness_menu(fitness_type_id, fitness_menu_name, fitness_menu_image, unit_calorie) 
values(2, '둔근, One Leg Kickback', 'https://www.jefit.com/images/exercises/800_600/785.jpg', 0.15);
insert into fitness_menu(fitness_type_id, fitness_menu_name, fitness_menu_image, unit_calorie) 
values(2, '둔근, Single Leg Glute Bridge', 'https://www.jefit.com/images/exercises/800_600/3461.jpg', 0.06);
insert into fitness_menu(fitness_type_id, fitness_menu_name, fitness_menu_image, unit_calorie) 
values(2, '둔근, Standing Adductor', 'https://www.jefit.com/images/exercises/800_600/2984.jpg', 0.1);
insert into fitness_menu(fitness_type_id, fitness_menu_name, fitness_menu_image, unit_calorie) 
values(2, '둔근, Standing Glute Kickback', 'https://www.jefit.com/images/exercises/800_600/4405.jpg', 0.15);
insert into fitness_menu(fitness_type_id, fitness_menu_name, fitness_menu_image, unit_calorie) 
values(2, '둔근, Straight Leg Outer Hip Abductor', 'https://www.jefit.com/images/exercises/800_600/2989.jpg', 0.15);
insert into fitness_menu(fitness_type_id, fitness_menu_name, fitness_menu_image, unit_calorie) 
values(2, '어깨, Handstand Pushups', 'https://www.jefit.com/images/exercises/800_600/3501.jpg', 0.25);
insert into fitness_menu(fitness_type_id, fitness_menu_name, fitness_menu_image, unit_calorie) 
values(2, '삼두근, Close Triceps Pushup', 'https://www.jefit.com/images/exercises/800_600/961.jpg', 0.15);
insert into fitness_menu(fitness_type_id, fitness_menu_name, fitness_menu_image, unit_calorie) 
values(2, '허벅지, Bodyweight Lunge', 'https://www.jefit.com/images/exercises/800_600/4861.jpg', 0.1);
insert into fitness_menu(fitness_type_id, fitness_menu_name, fitness_menu_image, unit_calorie) 
values(2, '허벅지, Bodyweight Side Lunge', 'https://www.jefit.com/images/exercises/800_600/4881.jpg', 0.1);
insert into fitness_menu(fitness_type_id, fitness_menu_name, fitness_menu_image, unit_calorie) 
values(2, '허벅지, Bodyweight Walking Lunge', 'https://www.jefit.com/images/exercises/800_600/4889.jpg', 0.1);
insert into fitness_menu(fitness_type_id, fitness_menu_name, fitness_menu_image, unit_calorie) 
values(2, '허벅지, Bodyweight Wall Squat', 'https://www.jefit.com/images/exercises/800_600/4837.jpg', 0.15);
insert into fitness_menu(fitness_type_id, fitness_menu_name, fitness_menu_image, unit_calorie) 
values(2, '허벅지, Freehand Jump Squat', 'https://www.jefit.com/images/exercises/800_600/1905.jpg', 0.22);
insert into fitness_menu(fitness_type_id, fitness_menu_name, fitness_menu_image, unit_calorie) 
values(2, '허벅지, One Leg Bodyweight Squat', 'https://www.jefit.com/images/exercises/800_600/4825.jpg', 0.22);
insert into fitness_menu(fitness_type_id, fitness_menu_name, fitness_menu_image, unit_calorie) 
values(2, '허벅지, Prisoner Squat', 'https://www.jefit.com/images/exercises/800_600/3001.jpg', 0.15);
insert into fitness_menu(fitness_type_id, fitness_menu_name, fitness_menu_image, unit_calorie) 
values(2, '허벅지, Rear Bodyweight Lunge', 'https://www.jefit.com/images/exercises/800_600/4877.jpg', 0.1);
insert into fitness_menu(fitness_type_id, fitness_menu_name, fitness_menu_image, unit_calorie) 
values(2, '허벅지, Rocket Jump', 'https://www.jefit.com/images/exercises/800_600/3697.jpg', 0.22);
insert into fitness_menu(fitness_type_id, fitness_menu_name, fitness_menu_image, unit_calorie) 
values(2, '허벅지, Sit Squat', 'https://www.jefit.com/images/exercises/800_600/1973.jpg', 0.15);
insert into fitness_menu(fitness_type_id, fitness_menu_name, fitness_menu_image, unit_calorie) 
values(2, '허벅지, Star Jump', 'https://www.jefit.com/images/exercises/800_600/3813.jpg', 0.131);
insert into fitness_menu(fitness_type_id, fitness_menu_name, fitness_menu_image, unit_calorie) 
values(2, '종아리, Bodyweight Standing Calf Raise', 'https://www.jefit.com/images/exercises/800_600/4909.jpg', 0.094);
insert into fitness_menu(fitness_type_id, fitness_menu_name, fitness_menu_image, unit_calorie) 
values(2, '종아리, One Leg Floor Calf Raise', 'https://www.jefit.com/images/exercises/800_600/4945.jpg', 0.094);
insert into fitness_menu(fitness_type_id, fitness_menu_name, fitness_menu_image, unit_calorie) 
values(2, '종아리, Standing One Leg Bodyweight Calf Raise', 'https://www.jefit.com/images/exercises/800_600/4945.jpg', 0.094);


-- 유산소 운동 table(primary key: fitness_cardio_id / (누가(userid), 언제(fitnessdate), 어떤메뉴운동(예:달리기))
create table fitness_cardio(
	fitness_cardio_id int auto_increment,
	user_id varchar(30) not null,
    fitness_date timestamp default now(),
    fitness_menu_id int not null,
    fitness_seconds int not null,
    distance int not null,
    number_steps int not null,
    used_calorie double not null,
    primary key(fitness_cardio_id),
    foreign key(user_id) references user(user_id),
    foreign key(fitness_menu_id) references fitness_menu(fitness_menu_id)
);


insert into fitness_cardio(user_id, fitness_date, fitness_menu_id, fitness_seconds, distance, number_steps, used_calorie) 
values('spider', '2019/07/01', 1, 1800, 2100, 3500, 90);
insert into fitness_cardio(user_id, fitness_date, fitness_menu_id, fitness_seconds, distance, number_steps, used_calorie) 
values('spider', '2019/07/02', 4, 3600, 8000, 7800, 586.8);
insert into fitness_cardio(user_id, fitness_date, fitness_menu_id, fitness_seconds, distance, number_steps, used_calorie) 
values('spider', '2019/07/03', 2, 3600, 6000, 7200, 216);
insert into fitness_cardio(user_id, fitness_date, fitness_menu_id, fitness_seconds, distance, number_steps, used_calorie) 
values('spider', '2019/07/04', 5, 1800, 5000, 7000, 367.2);
insert into fitness_cardio(user_id, fitness_date, fitness_menu_id, fitness_seconds, distance, number_steps, used_calorie) 
values('spider', '2019/07/05', 12, 1800, 12000, 14400, 367.2);
insert into fitness_cardio(user_id, fitness_date, fitness_menu_id, fitness_seconds, distance, number_steps, used_calorie) 
values('spider', '2019/07/06', 16, 1200, 2500, 4000, 284.4);
insert into fitness_cardio(user_id, fitness_date, fitness_menu_id, fitness_seconds, distance, number_steps, used_calorie) 
values('spider', '2019/07/07', 1, 3600, 4200, 7000, 180);



-- 근력 운동 table(primary key: fitness_weight_id / (누가(userid), 언제(fitnessdate), 어떤메뉴운동(예:달리기))
create table fitness_weight(
	fitness_weight_id int auto_increment,
	user_id varchar(30) not null,
    fitness_date timestamp default now(),
    fitness_menu_id int not null,
    fitness_seconds int not null,
    used_calorie double not null,
    primary key(fitness_weight_id),
    foreign key(user_id) references user(user_id),
    foreign key(fitness_menu_id) references fitness_menu(fitness_menu_id)
);
insert into fitness_weight(user_id, fitness_date, fitness_menu_id, fitness_seconds, used_calorie) 
values('spider', '2019/07/01', 19, 600, 96);
insert into fitness_weight(user_id, fitness_date, fitness_menu_id, fitness_seconds, used_calorie) 
values('spider', '2019/07/01', 20, 600, 90);
insert into fitness_weight(user_id, fitness_date, fitness_menu_id, fitness_seconds, used_calorie) 
values('spider', '2019/07/01', 22, 600, 90);
insert into fitness_weight(user_id, fitness_date, fitness_menu_id, fitness_seconds, used_calorie) 
values('spider', '2019/07/01', 38, 300, 51);
insert into fitness_weight(user_id, fitness_date, fitness_menu_id, fitness_seconds, used_calorie) 
values('spider', '2019/07/01', 43, 600, 90);
insert into fitness_weight(user_id, fitness_date, fitness_menu_id, fitness_seconds, used_calorie) 
values('spider', '2019/07/01', 48, 300, 75);
insert into fitness_weight(user_id, fitness_date, fitness_menu_id, fitness_seconds, used_calorie) 
values('spider', '2019/07/01', 58, 600, 132);
insert into fitness_weight(user_id, fitness_date, fitness_menu_id, fitness_seconds, used_calorie) 
values('spider', '2019/07/01', 62, 600, 56.4);
insert into fitness_weight(user_id, fitness_date, fitness_menu_id, fitness_seconds, used_calorie) 
values('spider', '2019/07/02', 21, 600, 96);
insert into fitness_weight(user_id, fitness_date, fitness_menu_id, fitness_seconds, used_calorie) 
values('spider', '2019/07/02', 31, 600, 90);
insert into fitness_weight(user_id, fitness_date, fitness_menu_id, fitness_seconds, used_calorie) 
values('spider', '2019/07/02', 27, 600, 90);
insert into fitness_weight(user_id, fitness_date, fitness_menu_id, fitness_seconds, used_calorie) 
values('spider', '2019/07/02', 38, 600, 102);
insert into fitness_weight(user_id, fitness_date, fitness_menu_id, fitness_seconds, used_calorie) 
values('spider', '2019/07/02', 42, 600, 90);
insert into fitness_weight(user_id, fitness_date, fitness_menu_id, fitness_seconds, used_calorie) 
values('spider', '2019/07/02', 48, 300, 75);
insert into fitness_weight(user_id, fitness_date, fitness_menu_id, fitness_seconds, used_calorie) 
values('spider', '2019/07/02', 50, 600, 60);
insert into fitness_weight(user_id, fitness_date, fitness_menu_id, fitness_seconds, used_calorie) 
values('spider', '2019/07/02', 61, 600, 56.4);
insert into fitness_weight(user_id, fitness_date, fitness_menu_id, fitness_seconds, used_calorie) 
values('spider', '2019/07/03', 32, 600, 96);
insert into fitness_weight(user_id, fitness_date, fitness_menu_id, fitness_seconds, used_calorie) 
values('spider', '2019/07/03', 35, 600, 31.2);
insert into fitness_weight(user_id, fitness_date, fitness_menu_id, fitness_seconds, used_calorie) 
values('spider', '2019/07/03', 31, 300, 18);
insert into fitness_weight(user_id, fitness_date, fitness_menu_id, fitness_seconds, used_calorie) 
values('spider', '2019/07/03', 38, 600, 102);
insert into fitness_weight(user_id, fitness_date, fitness_menu_id, fitness_seconds, used_calorie) 
values('spider', '2019/07/03', 39, 600, 36);
insert into fitness_weight(user_id, fitness_date, fitness_menu_id, fitness_seconds, used_calorie) 
values('spider', '2019/07/03', 48, 300, 75);
insert into fitness_weight(user_id, fitness_date, fitness_menu_id, fitness_seconds, used_calorie) 
values('spider', '2019/07/03', 50, 600, 60);
insert into fitness_weight(user_id, fitness_date, fitness_menu_id, fitness_seconds, used_calorie) 
values('spider', '2019/07/03', 63, 600, 56.4);
insert into fitness_weight(user_id, fitness_date, fitness_menu_id, fitness_seconds, used_calorie) 
values('spider', '2019/07/04', 41, 600, 96);
insert into fitness_weight(user_id, fitness_date, fitness_menu_id, fitness_seconds, used_calorie) 
values('spider', '2019/07/04', 45, 600, 90);
insert into fitness_weight(user_id, fitness_date, fitness_menu_id, fitness_seconds, used_calorie) 
values('spider', '2019/07/04', 22, 600, 90);
insert into fitness_weight(user_id, fitness_date, fitness_menu_id, fitness_seconds, used_calorie) 
values('spider', '2019/07/04', 38, 300, 51);
insert into fitness_weight(user_id, fitness_date, fitness_menu_id, fitness_seconds, used_calorie) 
values('spider', '2019/07/04', 43, 600, 90);
insert into fitness_weight(user_id, fitness_date, fitness_menu_id, fitness_seconds, used_calorie) 
values('spider', '2019/07/04', 48, 300, 75);
insert into fitness_weight(user_id, fitness_date, fitness_menu_id, fitness_seconds, used_calorie) 
values('spider', '2019/07/04', 58, 600, 132);
insert into fitness_weight(user_id, fitness_date, fitness_menu_id, fitness_seconds, used_calorie) 
values('spider', '2019/07/04', 62, 600, 56.4);
insert into fitness_weight(user_id, fitness_date, fitness_menu_id, fitness_seconds, used_calorie) 
values('spider', '2019/07/05', 19, 600, 96);
insert into fitness_weight(user_id, fitness_date, fitness_menu_id, fitness_seconds, used_calorie) 
values('spider', '2019/07/05', 25, 600, 31.2);
insert into fitness_weight(user_id, fitness_date, fitness_menu_id, fitness_seconds, used_calorie) 
values('spider', '2019/07/05', 31, 300, 18);
insert into fitness_weight(user_id, fitness_date, fitness_menu_id, fitness_seconds, used_calorie) 
values('spider', '2019/07/05', 38, 600, 102);
insert into fitness_weight(user_id, fitness_date, fitness_menu_id, fitness_seconds, used_calorie) 
values('spider', '2019/07/05', 39, 600, 36);
insert into fitness_weight(user_id, fitness_date, fitness_menu_id, fitness_seconds, used_calorie) 
values('spider', '2019/07/05', 48, 300, 75);
insert into fitness_weight(user_id, fitness_date, fitness_menu_id, fitness_seconds, used_calorie) 
values('spider', '2019/07/05', 50, 600, 60);
insert into fitness_weight(user_id, fitness_date, fitness_menu_id, fitness_seconds, used_calorie) 
values('spider', '2019/07/05', 63, 600, 56.4);
insert into fitness_weight(user_id, fitness_date, fitness_menu_id, fitness_seconds, used_calorie) 
values('spider', '2019/07/06', 26, 600, 96);
insert into fitness_weight(user_id, fitness_date, fitness_menu_id, fitness_seconds, used_calorie) 
values('spider', '2019/07/06', 31, 600, 90);
insert into fitness_weight(user_id, fitness_date, fitness_menu_id, fitness_seconds, used_calorie) 
values('spider', '2019/07/06', 27, 600, 90);
insert into fitness_weight(user_id, fitness_date, fitness_menu_id, fitness_seconds, used_calorie) 
values('spider', '2019/07/06', 38, 600, 102);
insert into fitness_weight(user_id, fitness_date, fitness_menu_id, fitness_seconds, used_calorie) 
values('spider', '2019/07/06', 42, 600, 90);
insert into fitness_weight(user_id, fitness_date, fitness_menu_id, fitness_seconds, used_calorie) 
values('spider', '2019/07/06', 48, 300, 75);
insert into fitness_weight(user_id, fitness_date, fitness_menu_id, fitness_seconds, used_calorie) 
values('spider', '2019/07/06', 50, 600, 60);
insert into fitness_weight(user_id, fitness_date, fitness_menu_id, fitness_seconds, used_calorie) 
values('spider', '2019/07/06', 61, 600, 56.4);
insert into fitness_weight(user_id, fitness_date, fitness_menu_id, fitness_seconds, used_calorie) 
values('spider', '2019/07/07', 32, 600, 96);
insert into fitness_weight(user_id, fitness_date, fitness_menu_id, fitness_seconds, used_calorie) 
values('spider', '2019/07/07', 35, 600, 90);
insert into fitness_weight(user_id, fitness_date, fitness_menu_id, fitness_seconds, used_calorie) 
values('spider', '2019/07/07', 22, 600, 90);
insert into fitness_weight(user_id, fitness_date, fitness_menu_id, fitness_seconds, used_calorie) 
values('spider', '2019/07/07', 38, 300, 51);
insert into fitness_weight(user_id, fitness_date, fitness_menu_id, fitness_seconds, used_calorie) 
values('spider', '2019/07/07', 43, 600, 90);
insert into fitness_weight(user_id, fitness_date, fitness_menu_id, fitness_seconds, used_calorie) 
values('spider', '2019/07/07', 48, 300, 75);
insert into fitness_weight(user_id, fitness_date, fitness_menu_id, fitness_seconds, used_calorie) 
values('spider', '2019/07/07', 58, 600, 132);
insert into fitness_weight(user_id, fitness_date, fitness_menu_id, fitness_seconds, used_calorie) 
values('spider', '2019/07/07', 62, 600, 56.4);




-- 수면 table
create table sleeping(
	user_id varchar(30) not null,
	sleeping_date timestamp default now(),
    sleeping_seconds int not null,
    snoring_seconds int not null,
    primary key(sleeping_date),
    foreign key(user_id) references user(user_id)
);

insert into sleeping(user_id, sleeping_date, sleeping_seconds, snoring_seconds) values('spider', '2019/07/01', 28800, 1200);
insert into sleeping(user_id, sleeping_date, sleeping_seconds, snoring_seconds) values('spider', '2019/07/02', 18000, 3600);
insert into sleeping(user_id, sleeping_date, sleeping_seconds, snoring_seconds) values('spider', '2019/07/03', 25200, 2700);
insert into sleeping(user_id, sleeping_date, sleeping_seconds, snoring_seconds) values('spider', '2019/07/04', 21600, 1800);
insert into sleeping(user_id, sleeping_date, sleeping_seconds, snoring_seconds) values('spider', '2019/07/05', 24000, 1500);
insert into sleeping(user_id, sleeping_date, sleeping_seconds, snoring_seconds) values('spider', '2019/07/06', 27000, 1800);
insert into sleeping(user_id, sleeping_date, sleeping_seconds, snoring_seconds) values('spider', '2019/07/07', 28800, 1500);

-- 음주 table
create table drinking(
	user_id varchar(30) not null,
	drinking_date timestamp default now(),
    alcohol_content double not null,
    primary key(drinking_date),
    foreign key(user_id) references user(user_id)
);

insert into drinking(user_id, drinking_date, alcohol_content) values('spider', '2019/07/01', 0.12);
insert into drinking(user_id, drinking_date, alcohol_content) values('spider', '2019/07/02', 0.011);
insert into drinking(user_id, drinking_date, alcohol_content) values('spider', '2019/07/03', 0.098);
insert into drinking(user_id, drinking_date, alcohol_content) values('spider', '2019/07/04', 0.052);
insert into drinking(user_id, drinking_date, alcohol_content) values('spider', '2019/07/05', 0.031);
insert into drinking(user_id, drinking_date, alcohol_content) values('spider', '2019/07/06', 0.122);
insert into drinking(user_id, drinking_date, alcohol_content) values('spider', '2019/07/07', 0.011);

-- =========================================================================================================================================================

DROP PROCEDURE IF EXISTS add_user;
DELIMITER //
CREATE PROCEDURE add_user(param_uid varchar(50))
BEGIN
	DECLARE var_count INT;
	DECLARE cur_user CURSOR FOR SELECT count(*) FROM user where user_id = param_uid;
	OPEN cur_user;

	read_roop:LOOP
		FETCH cur_user INTO var_count;
		IF(var_count = 0) THEN
			INSERT INTO user(user_id, name, password) VALUES(param_uid, param_uid, '1234');
		END IF;
		LEAVE read_roop;
	END LOOP;
	CLOSE cur_user;
END
//
DELIMITER ;


DROP PROCEDURE IF EXISTS user_total;
DELIMITER //
CREATE PROCEDURE user_total(param_uid varchar(50), param_date varchar(20))
BEGIN
	
select sum(fitness_seconds), sum(used_calorie) from fitness_weight where user_id=param_uid and fitness_date=param_date;
	
END
//
DELIMITER ;


call user_total('spider', '2019/07/01');

drop table fitness_streching;
create table fitness_streching(
	user_id varchar(30) not null,
    fitness_date timestamp default now(),
    fitness_menu_id int not null,
    fitness_hours int not null,
    primary key(user_id, fitness_date, fitness_menu_id),
    foreign key(user_id) references user(user_id),
    foreign key(fitness_menu_id) references fitness_menu(fitness_menu_id)
);

select sum(fitness_seconds), sum(used_calorie)
from fitness_weight
where user_id='spider' and fitness_date='2019/07/01';

insert into fitness_streching(user_id, fitness_menu_id, fitness_hours) values('spider', 6, 10);
insert into fitness_streching(user_id, fitness_menu_id, fitness_hours) values('hulk', 7, 30);
insert into fitness_streching(user_id, fitness_menu_id, fitness_hours) values('scarlet', 6, 20);
insert into fitness_streching(user_id, fitness_menu_id, fitness_hours) values('natasha', 7, 15);
insert into fitness_streching(user_id, fitness_menu_id, fitness_hours) values('panther', 7, 20);

-- =======================================================================================================================
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('귀리, 겉귀리, 도정, 생것', 373);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('귀리, 쌀귀리, 도정, 생것', 371);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('귀리, 오트밀', 382);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('기장, 도정, 생것', 360);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('기장, 찰기장, 도정, 생것', 365);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('메밀, 도정, 생것', 363);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('메밀, 도정, 가루', 374);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('메밀, 국수, 생것', 291);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('메밀, 국수, 생것, 삶은것', 124);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('메밀, 국수, 말린것', 372);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('메밀, 국수, 말린것, 삶은것', 114);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('메밀, 냉면, 말린것', 360);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('메밀, 냉면, 말린것, 삶은것', 141);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('메밀묵, 생것', 58);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('메밀묵, 가루', 371);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멥쌀, 배아미, 생것', 357);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멥쌀, 백미, 생것', 363);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멥쌀, 백미, 가루 ', 362);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멥쌀, 칠분도미, 생것', 368);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멥쌀, 고아미2호, 백미, 생것', 379);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멥쌀, 고아미2호, 현미, 생것', 374);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멥쌀, 농림나1호, 칠분도미, 생것', 370);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멥쌀, 농림나1호, 현미, 생것', 371);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멥쌀, 미국산, 백미, 생것', 365);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멥쌀, 발아현미, 현미, 생것', 371);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멥쌀, 밭벼, 백미, 생것', 357);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멥쌀, 밭벼, 칠분도미, 생것', 358);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멥쌀, 새추청벼, 백미, 생것', 366);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멥쌀, 수라벼, 백미, 생것', 346);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멥쌀, 일미벼, 백미, 생것', 372);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멥쌀, 일미벼, 현미, 생것', 354);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멥쌀, 일본산, 백미, 생것', 367);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멥쌀, 일품벼, 백미, 생것', 353);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멥쌀, 일품벼, 현미, 생것', 363);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멥쌀, 중국산, 백미, 생것', 361);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멥쌀, 추청벼, 백미, 생것', 373);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멥쌀, 추청벼, 현미, 생것', 362);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멥쌀, 큰눈벼, 백미, 생것', 375);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멥쌀, 큰눈벼, 현미, 생것', 371);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멥쌀, 태국산, 백미, 생것', 366);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멥쌀, 통일벼, 백미, 생것', 375);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멥쌀, 통일벼, 현미, 생것', 362);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멥쌀, 하이아미, 백미, 생것', 367);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멥쌀, 향미벼, 백미, 생것', 368);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멥쌀, 호주산, 백미, 생것', 371);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멥쌀, 흑미벼, 현미, 생것', 356);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멥쌀, 흑진주벼, 현미, 생것', 369);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멥쌀, 히토메보레, 백미, 생것', 364);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멥쌀, 골든퀸3호, 백미, 생것', 354);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멥쌀, 골든퀸3호, 현미, 생것', 356);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멥쌀, 호품벼, 백미, 생것', 354);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멥쌀, 호품벼, 현미, 생것', 343);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멥쌀, 과자', 469);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멥쌀, 과자, 튀밥, 팽화', 393);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멥쌀, 과자, 쌀엿강정, 팽화', 395);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멥쌀, 국수, 말린것', 340);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멥쌀떡, 가래떡', 213);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멥쌀떡, 가래떡, 흑미', 205);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멥쌀떡, 개피떡', 207);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멥쌀떡, 개피떡, 쑥', 206);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멥쌀떡, 꿀떡', 210);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멥쌀떡, 무지개떡', 229);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멥쌀떡, 백설기', 228);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멥쌀떡, 백설기, 검정콩', 229);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멥쌀떡, 송편, 검정콩', 200);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멥쌀떡, 송편, 팥', 200);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멥쌀떡, 송편, 깨', 224);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멥쌀떡, 모싯잎송편, 동부(국내산)', 190);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멥쌀떡, 모싯잎송편, 동부(수입산)', 190);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멥쌀떡, 시루떡', 183);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멥쌀떡, 절편', 215);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멥쌀떡, 증편', 198);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멥쌀떡, 증편, 건포도, 깨', 191);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멥쌀미음, 백미', 21);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멥쌀미음, 칠분도미', 21);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멥쌀미음, 현미', 20);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멥쌀밥, 쪄서, 말린것', 373);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멥쌀밥, 누룽지', 393);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멥쌀밥, 백미', 152);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멥쌀밥, 칠분도미', 168);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멥쌀밥, 현미', 167);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멥쌀밥, 농림나1호, 백미', 213);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멥쌀밥, 농림나1호, 칠분도미', 205);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멥쌀밥, 농림나1호, 현미', 201);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멥쌀밥, 밭벼, 백미', 168);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멥쌀밥, 밭벼, 칠분도미', 168);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멥쌀밥, 밭벼, 현미', 164);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멥쌀밥, 새추청벼, 백미', 153);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멥쌀밥, 수라벼, 백미', 159);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멥쌀밥, 일품벼, 백미', 156);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멥쌀밥, 추청벼, 백미', 151);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('즉석밥, 누룽지', 415);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('즉석밥, 누룽지, 끓는물, 부음', 69);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('즉석밥, 잡곡밥(멥쌀, 찹쌀, 흑미, 팥, 기장, 찰수수)', 150);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('즉석밥, 백미', 152);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멥쌀죽, 백미', 71);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멥쌀죽, 현미', 70);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멥쌀죽, 칠분도미', 71);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('밀, 통밀, 생것', 342);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('밀, 도정, 생것', 333);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('밀, 강력밀가루', 334);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('밀, 금강밀, 도정, 생것', 329);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('밀, 도우넛가루', 404);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('밀, 박력밀가루', 374);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('밀, 부침가루', 368);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('밀, 빵가루', 392);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('밀, 신미찰밀, 도정, 생것', 334);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('밀, 중력밀가루', 375);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('밀, 통밀가루 ', 365);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('밀, 튀김가루', 367);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('밀, 팬케이크가루', 394);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('밀, 흑밀, 도정, 생것', 328);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('밀, 카무트, 미국산, 말린것', 334);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('과자, 건빵', 419);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('과자, 만주, 밤', 330);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('과자, 모나카', 346);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('과자, 비스킷, 하드', 534);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('과자, 비스킷, 소프트', 489);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('과자, 사과파이', 471);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('과자, 전병', 398);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('과자, 김전병', 420);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('과자, 스넥, 새우', 494);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('과자, 스넥, 옥수수', 520);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('과자, 약과', 422);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('과자, 대추꿀약과', 428);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('과자, 와플 ', 291);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('과자, 잼, 와플', 287);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('과자, 커스터드, 크림, 와플', 252);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('과자, 바닐라, 웨하스', 521);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('과자, 초코볼', 501);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('과자, 초코파이', 428);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('과자, 쿠키, 통밀', 471);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('과자, 쿠키, 땅콩버터', 493);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('과자, 쿠키, 초코칩', 494);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('과자, 쿠키, 버터', 512);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('과자, 크랙커', 513);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('과자, 크랙커, 땅콩샌드', 524);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('과자, 크랙커, 치즈샌드', 497);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('과자, 크랙커, 채소', 506);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('과자, 피칸파이', 360);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('과자, 뻥튀기, 원반, 모양, 팽화', 383);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('과자, 마카로니, 과자, 튀긴것', 457);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('국수, 생것', 291);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('국수, 소면, 말린것', 370);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('국수, 소면, 말린것, 삶은것', 126);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('국수, 우동, 생것', 164);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('국수, 우동, 생것, 삶은것', 139);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('국수, 중국국수, 생면', 281);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('국수, 중국국수, 생면, 삶은것', 149);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('국수, 중국국수, 말린것', 356);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('국수, 중국국수, 말린것, 삶은것', 148);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('국수, 중국국수, 증숙, 생것', 198);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('국수, 중면, 말린것', 366);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('국수, 중면, 말린것, 삶은것', 120);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('국수, 쫄면, 말린것', 348);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('국수, 칼국수, 생것', 303);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('국수, 칼국수, 생것, 삶은것', 140);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('국수, 칼국수, 반건조', 281);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('라면, 말린것', 445);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('라면, 말린것, 삶은것', 175);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('빵, 건포도빵', 269);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('빵, 곰보빵', 415);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('빵, 꽈배기', 404);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('빵, 팥, 도우넛', 347);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('빵, 링, 도우넛', 426);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('빵, 하드, 롤빵', 293);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('빵, 소프트, 롤빵', 316);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('빵, 마늘빵', 424);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('빵, 우유, 머핀', 296);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('빵, 잉글리쉬, 머핀', 235);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('빵, 모닝빵', 316);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('빵, 모카빵', 354);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('빵, 바게트빵', 279);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('빵, 달걀, 베이글', 278);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('빵, 식빵', 279);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('빵, 식빵, 베타카로틴, 첨가', 266);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('빵, 식빵, 옥수수', 270);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('빵, 우유, 식빵', 285);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('빵, 옥수수빵', 321);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('빵, 잼빵', 297);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('빵, 찐빵, 팥', 213);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('빵, 채소, 찐빵', 231);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('빵, 단호박, 찐빵', 239);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('빵, 카스텔라', 299);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('빵, 크로와상', 448);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('빵, 버터, 크로와상', 406);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('빵, 크로켓', 307);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('빵, 채소, 크로켓', 301);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('빵, 크림빵', 275);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('빵, 버터, 크림빵', 383);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('빵, 팥빵', 253);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('빵, 페이스트리', 457);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('빵, 치즈, 페이스트리', 374);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('빵, 과일, 페이스트리', 371);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('빵, 붕어빵, 팥', 254);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('빵, 소시지빵', 323);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('빵, 난', 262);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('케이크, 과일(후르츠)', 324);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('케이크, 롤케이크', 369);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('케이크, 배, 케이크', 296);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('케이크, 생크림, 블루베리', 280);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('케이크, 쇼튼드, 케이크', 327);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('케이크, 스펀지, 케이크', 352);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('케이크, 엔젤푸드, 케이크', 258);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('케이크, 초콜릿, 케이크', 417);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('케이크, 치즈, 케이크', 331);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('케이크, 파운드, 케이크', 408);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('케이크, 팬케이크', 227);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('파스타, 마카로니, 말린것', 380);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('파스타, 마카로니, 말린것, 삶은것', 126);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('파스타, 스파게티, 말린것', 365);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('파스타, 스파게티, 말린것, 삶은것', 129);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('보리, 두산8호, 도정, 생것', 352);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('보리, 서둔찰보리, 도정, 생것', 354);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('보리, 쌀보리, 도정, 생것', 342);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('보리, 겉보리, 압맥', 343);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('보리, 겉보리, 할맥', 354);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('보리, 볶은것', 360);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('보리, 가루', 357);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('보리, 껍질, 포함, 가루', 364);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('보리, 미숫가루', 398);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('보리, 엿기름, 말린것', 358);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('보리, 찰보리, 도정, 생것', 346);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('보리, 늘보리, 도정, 생것', 346);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('보리, 찰보리, 할맥', 362);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('수수, 통수수, 생것', 360);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('수수, 도정, 생것', 338);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('수수, 찰수수, 도정, 생것', 353);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('수수떡, 수수경단', 218);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('시리얼, 옥수수, 아몬드', 426);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('시리얼, 옥수수', 378);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('시리얼, 현미', 394);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('시리얼, 옥수수, 그래놀라, 코코넛 ', 434);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('시리얼, 옥수수, 그래놀라, 건조과일 ', 395);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('시리얼, 쌀', 390);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('시리얼, 코코아', 407);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('아마란스, 노란색, 건조', 383);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('아마란스, 붉은색, 건조', 381);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('옥수수, 단옥수수, 생것', 109);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('옥수수, 단옥수수, 찐것', 135);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('옥수수, 메옥수수, 생것', 178);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('옥수수, 메옥수수, 말린것', 348);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('옥수수, 메옥수수, 찐것', 173);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('옥수수, 메옥수수, 구운것', 372);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('옥수수, 찰옥수수, 생것', 142);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('옥수수, 찰옥수수, 말린것', 371);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('옥수수, 찰옥수수, 찐것', 132);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('옥수수, 가루', 364);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('옥수수, 크림, 통조림', 84);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('옥수수, 홀커넬, 통조림', 82);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('옥수수, 가당, 통조림', 105);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('옥수수, 과자, 강냉이', 401);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('옥수수, 과자, 콘칩', 538);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('옥수수, 과자, 팝콘', 536);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('옥수수, 과자, 팝콘, 전자레인지, 조리', 497);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('옥수수, 과자, 팝콘, 말린것', 373);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('옥수수, 묵', 55);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('옥수수, 샐러드, 콘샐러드', 104);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('율무, 도정, 생것', 377);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('율무, 국수, 말린것', 368);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('율무죽', 44);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('잡곡, 현미, 찹쌀, 현미찹쌀, 보리, 등, 생것', 358);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('조, 메조, 도정, 생것', 372);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('조, 메조, 도정, 찐것', 115);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('조, 차조, 도정, 생것', 360);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('찹쌀, 가루', 375);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('찹쌀, 백미, 생것', 377);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('찹쌀, 현미, 생것', 361);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('찹쌀, 찹쌀미숫가루 ', 386);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('찹쌀, 화선찰벼, 백미, 생것', 375);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('찹쌀, 동진찰벼, 백미, 생것', 363);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('찹쌀, 동진찰벼, 현미, 생것', 357);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('찹쌀, 과자, 검정깨, 다식', 475);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('찹쌀, 과자, 송화, 다식', 343);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('찹쌀, 과자, 산자', 417);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('찹쌀, 과자, 유과', 411);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('찹쌀, 과자, 전병', 446);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('찹쌀, 국수, 흑미찰국수', 334);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('찹쌀떡', 246);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('찹쌀떡, 경단, 카스텔라', 237);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('찹쌀떡, 모듬찰떡', 223);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('찹쌀떡, 약식', 244);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('찹쌀떡, 인절미, 팥고물', 204);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('찹쌀떡, 인절미, 콩고물', 231);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('찹쌀떡, 찰시루떡', 181);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('찹쌀빵, 찹쌀도우넛', 296);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('퀴노아, 쪄서, 말린것', 364);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('피, IEC525(NO.5), 도정, 생것', 376);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('호밀, 가루 ', 351);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('호밀, 통호밀, 생것', 334);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('호밀빵', 264);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('감자, 대지, 생것', 67);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('감자, 대지, 삶은것', 77);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('감자, 대지, 찐것', 80);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('감자, 대지, 구운것', 90);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('감자, 부침가루 ', 355);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('감자, 수미, 생것', 70);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('감자, 수미, 삶은것', 76);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('감자, 수미, 찐것', 75);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('감자, 수미, 구운것', 85);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('감자, 자색, 생것', 82);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('감자, 자색, 찐것', 85);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('감자, 자심, 생것', 64);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('감자, 보라밸리, 생것', 60);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('감자, 보라밸리, 삶은것', 69);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('감자, 로즈, 생것', 68);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('감자, 로즈, 삶은것', 79);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('감자, 과자, 감자칩, 구운것', 469);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('감자, 과자, 감자칩, 튀긴것', 536);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('감자, 튀김, 튀긴것', 293);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('감자, 튀김, 해쉬브라운, 튀긴것', 219);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('감자, 샐러드', 143);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('으깬감자', 83);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고구마, 말린것', 312);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고구마, 찐것', 130);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고구마, 베니하루까, 생것', 147);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고구마, 분질(밤), 고구마, 생것', 154);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고구마, 분질(밤), 고구마, 찐것', 169);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고구마, 분질(밤), 고구마, 구운것', 189);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고구마, 신율미, 생것', 164);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고구마, 신자미, 생것', 107);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고구마, 연황미, 생것', 127);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고구마, 점질(호박), 고구마, 생것', 141);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고구마, 점질(호박), 고구마, 찐것', 157);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고구마, 점질(호박), 고구마, 구운것', 186);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고구마, 주황미, 생것', 105);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고구마, 진홍미, 생것', 140);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('당면, 고구마, 말린것', 358);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('당면, 고구마, 삶은것', 123);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('당면, 고구마, 감자, 말린것', 350);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('곤약(구약나물), 가루 ', 177);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('곤약(구약나물), 국수형, 생것', 6);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('곤약(구약나물), 판형, 생것', 6);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돼지감자, 생것', 35);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돼지감자, 말린것', 172);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돼지감자, 삶은것', 39);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('마, 단마, 생것', 63);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('마, 장마, 생것', 45);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('마, 장마, 삶은것', 49);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('마, 둥근마, 생것', 152);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('아피오스감자, 생것', 175);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('야콘, 뿌리, 생것', 62);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('전분, 감자, 가루', 334);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('전분, 고구마, 가루 ', 342);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('전분, 밀, 가루', 351);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('전분, 쌀, 가루', 366);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('전분, 옥수수, 가루', 366);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('전분, 옥수수, 밀, 가루 ', 379);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('전분, 졸참도토리, 가루 ', 325);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('전분, 종가시도토리, 가루 ', 332);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('전분, 칡뿌리, 가루', 347);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('천마, 생것', 77);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('천마, 찐것', 81);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('칡뿌리, 생것', 137);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('칡즙', 21);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('토란, 생것', 71);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('토란, 삶은것', 73);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('토란, 찐것', 76);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('히카마(얌빈), 생것', 44);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('히카마(얌빈), 삶은것', 45);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('과당', 368);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('껌, 츄잉껌', 388);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('껌, 풍선껌', 387);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('껌, 무설탕', 268);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('꿀', 294);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('꿀, 들깨', 292);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('꿀, 밤', 314);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('꿀, 싸리', 315);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('꿀, 아카시아', 319);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('꿀, 잡화', 318);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('꿀, 토종', 313);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('당밀, 가공당', 265);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('로얄제리', 138);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('엿, 고구마', 263);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('물엿', 321);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('사탕, 드롭스', 379);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('사탕, 마쉬멜로', 326);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('사탕, 박하사탕', 382);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('사탕, 버터', 352);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('사탕, 땅콩', 354);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('설탕, 가루 ', 389);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('설탕, 각설탕', 387);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('설탕, 백설탕', 387);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('설탕, 빙설탕', 387);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('설탕, 황설탕', 386);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('설탕, 흑설탕', 379);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('시럽, 단풍나무', 260);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('시럽, 초코', 268);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('양갱, 팥', 298);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('젤라틴, 디저트용, 가루 ', 381);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('젤리', 327);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('조청, 감 ', 201);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('조청, 고구마', 289);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('조청, 도라지', 323);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('조청, 배', 238);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('조청, 산수유', 299);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('조청, 쌀', 326);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('조청, 오가피', 286);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('초콜릿, 감잎, 초콜릿', 543);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('초콜릿, 다크, 초콜릿', 598);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('초콜릿, 땅콩, 초콜릿', 519);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('초콜릿, 밀크, 라이스, 시리얼, 초콜릿', 511);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('초콜릿, 밀크, 아몬드, 초콜릿', 526);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('초콜릿, 밀크(우유), 초콜릿', 572);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('초콜릿, 스위트, 초콜릿', 507);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('초콜릿, 화이트, 초콜릿', 539);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('카라멜, 밀크(우유)', 423);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('포도당', 335);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('푸딩, 바닐라, 가루, 우유에, 섞은것', 114);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('푸딩, 커스터드', 126);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('강낭콩, 생것', 172);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('강낭콩, 말린것', 350);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('강낭콩, 삶은것', 170);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('녹두, 말린것', 352);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('녹두, 삶은것', 158);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('녹두, 빈대떡, 가루 ', 347);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('녹두, 빈대떡가루, 반죽', 98);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('녹두, 국수, 말린것', 356);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('녹두묵', 36);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('동부, 생것', 163);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('동부, 말린것', 349);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('동부, 삶은것', 147);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('동부, 미얀마산, 말린것', 345);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('동부, 미얀마산, 삶은것', 155);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('리마콩, 말린것', 351);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('리마콩, 삶은것', 152);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('렌즈콩(렌틸콩), 인도산, 빨간색, 말린것', 359);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('렌즈콩(렌틸콩), 인도산, 갈색, 말린것', 359);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('병아리콩, 인도산, 말린것', 373);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('완두, 생것', 114);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('완두, 말린것', 363);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('완두, 삶은것', 122);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('작두(도두), 생것', 125);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('작두(도두), 말린것', 344);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('잠두, 생것', 341);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('잠두, 삶은것', 110);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('쥐눈이콩(검정소립콩), 말린것', 403);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('쥐눈이콩(검정소립콩), 삶은것', 184);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('쥐눈이콩(검정소립콩), 볶은것', 447);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('콩(대두), 갈색콩(밤콩), 말린것', 410);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('콩(대두), 노란콩, 말린것', 409);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('콩(대두), 노란콩, 가루, 볶은것', 427);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('콩(대두), 노란콩, 삶은것', 201);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('콩(대두), 노란콩, 볶은것', 444);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('콩(대두), 대풍, 말린것', 405);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('콩(대두), 대풍, 볶은것', 460);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('콩(대두), 미국산, 말린것', 432);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('콩(대두), 서리태, 말린것', 413);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('콩(대두), 서리태, 삶은것', 196);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('콩(대두), 서리태, 볶은것', 436);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('콩(대두), 중국산, 말린것', 433);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('콩(대두), 청자3호, 말린것', 399);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('콩(대두), 청자3호, 볶은것', 452);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('콩(대두), 흑태, 말린것', 407);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('콩(대두), 흑태, 삶은것', 199);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('콩(대두), 흑태, 볶은것', 446);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('콩조림(콩자반)', 271);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('두부', 97);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('두부, 동두부, 동결건조', 536);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('두부, 순두부', 42);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('두부, 연두부', 62);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('두부, 유부, 튀긴것', 381);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('비지', 74);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('두유, 대두', 70);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('두유, 검은콩', 86);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('두유, 검은콩, 검은참깨', 77);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('두유, 콩국물, 소금, 0.30%', 57);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('팥, 검정팥, 말린것', 347);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('팥, 검정팥, 삶은것', 143);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('팥, 붉은팥, 말린것', 339);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('팥, 붉은팥, 삶은것', 198);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('팥, 붉은팥(중국산), 말린것', 357);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('팥, 회색팥, 말린것', 350);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('팥, 페이스트', 155);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('개암, 헤이즐넛, 말린것', 659);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('개암, 헤이즐넛, 볶은것', 684);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('도토리, 생것', 230);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('도토리, 가루 ', 354);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('도토리, 졸참도토리, 가루 ', 342);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('도토리, 종가시도토리, 가루 ', 348);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('도토리, 국수, 말린것', 343);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('도토리묵', 44);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('들깨, 말린것', 530);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('들깨, 볶은것', 532);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('땅콩, 말린것', 520);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('땅콩, 가루', 560);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('땅콩, 삶은것, 소금첨가', 318);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('땅콩, 볶은것', 567);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('땅콩, 조미, 튀긴것', 558);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('땅콩, 조미, 볶은것', 598);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('땅콩, 검정땅콩, 말린것', 574);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('땅콩, 대립종, 말린것', 571);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('땅콩, 소립종, 말린것', 564);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('땅콩, 중립종, 말린것', 549);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('때죽, 말린것', 551);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('마가목, 열매, 생것', 115);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('마름, 생것', 190);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('마카다미아넛, 조미, 볶은것(기름)', 720);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('머루씨, 생것', 282);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('목화씨, 구운것', 506);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('밤, 생것', 151);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('밤, 말린것', 377);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('밤, 삶은것', 154);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('밤, 통조림', 225);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('밤, 단택, 생것', 150);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('밤, 단택, 삶은것', 150);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('밤, 단택, 구운것', 187);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('밤, 대보, 생것', 146);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('밤, 대보, 삶은것', 155);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('밤, 대보, 구운것', 181);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('밤, 옥광, 생것', 147);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('밤, 옥광, 삶은것', 154);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('밤, 이평, 생것', 157);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('밤, 이평, 삶은것', 155);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('밤, 축파, 생것', 141);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('밤, 축파, 삶은것', 138);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('밤, 축파, 구운것', 185);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('밤, 삼조생, 구운것', 206);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('보리밥, 열매, 말린것', 354);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('브라질너트, 말린것', 659);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('브라질너트, 볶은것', 669);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('삼씨, 말린것', 463);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('수박씨, 말린것', 451);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('수박씨, 조미, 볶은것', 546);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('아마씨, 볶은것', 564);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('아몬드, 말린것', 581);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('아몬드, 볶은것', 594);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('아몬드, 조미, 볶은것', 568);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('연씨, 미숙, 생것', 85);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('은행, 생것', 203);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('은행, 삶은것', 186);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('은행, 볶은것', 221);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('잣, 생것', 617);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('잣, 말린것', 640);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('잣, 볶은것', 708);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('잣두부', 78);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('잣죽', 30);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('참깨, 검정깨, 말린것', 549);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('참깨, 검정깨, 볶은것', 539);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('참깨, 흰깨, 말린것', 556);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('참깨, 흰깨, 볶은것', 557);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('참깨, 과자, 엿강정', 538);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('참깨죽', 38);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('치아씨, 말린것', 486);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('캐슈넛, 조미한, 것 ', 576);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('코코넛, 말린것', 660);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('코코넛, 볶은것', 592);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('코코넛, 코코넛밀크', 230);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('코코넛수, 과즙', 19);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('피스타치오넛, 말린것', 560);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('피스타치오넛, 볶은것', 584);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('피스타치오넛, 조미, 볶은것', 580);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('피칸, 말린것', 691);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('피칸, 조미, 볶은것', 710);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('해바라기씨, 말린것', 607);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('해바라기씨, 볶은것', 611);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('해바라기씨, 조미, 볶은것', 600);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('호두, 말린것', 688);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('호두, 볶은것', 671);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('호박씨, 말린것', 548);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('호박씨, 일본산, 조미, 볶은것', 574);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('가시오갈피, 순, 생것', 76);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('가시오갈피, 순, 데친것', 63);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('가죽나물, 생것', 50);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('가죽나물, 말린것', 287);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('가죽나물, 데친것', 49);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('가지, 생것', 19);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('가지, 말린것', 290);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('가지, 데친것', 19);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('가지, 염절임', 23);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('갓, 생것', 36);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('갓, 돌산갓, 생것', 24);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('강남조나물, 말린것', 223);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('갬추, 말린것', 286);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('갯기름나물, 노지, 생것', 41);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('갯기름나물, 노지, 데친것', 44);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('갯기름나물, 노지, 어린것, 생것', 53);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('갯기름나물, 노지, 어린것, 데친것', 53);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('갯기름나물, 하우스, 생것', 50);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('갯기름나물, 하우스, 데친것', 51);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('갯기름나물, 하우스, 어린것, 생것', 44);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('갯기름나물, 하우스, 어린것, 데친것', 47);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('게걸무, 생것', 59);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('게걸무, 잎, 생것', 23);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('겨자, 적겨자, 생것', 24);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고구마, 잎, 생것', 47);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고구마, 잎, 데친것', 41);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고구마, 줄기, 생것', 18);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고구마, 줄기, 말린것', 332);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고구마, 줄기, 삶아서, 말린것, 삶은것', 23);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고구마, 줄기, 삶은것', 14);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고구마, 줄기, 데친것', 17);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고구마, 줄기(껍질, 포함), 생것', 23);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고구마, 줄기(껍질, 포함), 삶아서, 말린것, 삶은것', 33);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고구마, 줄기(껍질, 포함), 데친것', 22);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고들빼기, 생것', 29);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고들빼기, 이고들빼기, 생것', 39);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고려엉겅퀴(곤드레), 야생, 말린것', 275);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고려엉겅퀴(곤드레), 재배, 말린것', 310);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고려엉겅퀴(곤드레), 재래종, 잎, 생것', 32);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고비, 야생, 생것', 28);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고비, 야생, 말린것, 삶은것', 31);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고비, 야생, 삶아서, 말린것', 299);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고비, 야생, 삶은것', 25);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고비, 재배, 생것', 28);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고사리, 생것', 22);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고사리, 말린것', 261);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고사리, 삶아서, 말린것', 273);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고사리, 데친것', 21);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고수(향채), 생것', 33);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고추, 풋고추, 생것', 29);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고추, 싹, 생것', 21);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고추, 빨간색, 생것', 85);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고추, 빨간색, 말린것', 312);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고추, 꽈리고추, 생것', 33);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고추, 녹광, 빨간색, 생것', 41);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고추, 시레나, 연두색, 생것', 19);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고추, 녹광, 초록색, 생것', 27);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고추, 수비초, 빨간색, 생것', 77);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고추, 시레나, 초록색, 생것', 23);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고추, 오이고추, 생것', 23);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고추, 재래종, 풋고추, 생것', 26);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고추, 청양고추, 생것', 31);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고춧잎, 생것', 45);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고춧잎, 말린것', 266);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고춧잎, 삶아서, 말린것, 삶은것', 41);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고춧잎, 데친것', 51);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고추장아찌', 124);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고추냉이, 뿌리, 생것', 103);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고추냉이, 잎, 생것', 36);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고추냉이, 줄기, 생것', 24);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('곤달비, 생것', 42);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('곤달비, 데친것', 35);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('곰취, 생것', 32);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('곰취, 데친것', 35);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('곰취, 야생, 말린것', 307);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('곰취, 재배, 말린것', 306);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('공심채, 생것', 17);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('공심채, 데친것', 21);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('꾸지뽕, 잎, 생것', 85);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('꾸지뽕, 잎, 말린것', 282);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('꾸지뽕, 잎, 삶은것', 61);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('구기자, 순, 재래종, 생것', 50);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('구기자, 잎, 재래종, 생것', 56);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('국화꽃, 생것', 27);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('국화꽃, 말린것', 292);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('국화꽃, 데친것', 23);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('근대, 생것', 18);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('근대, 데친것', 20);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('김치, 갓, 김치', 37);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('김치, 고들빼기', 88);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('김치, 깍두기', 38);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('김치, 나박, 김치', 7);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('김치, 동치미', 8);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('김치, 배추, 김치', 25);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('김치, 배추, 김치, 봄, 재배 ', 39);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('김치, 배추, 김치, 여름, 재배', 38);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('김치, 배추, 김치, 가을, 재배', 37);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('김치, 백김치', 16);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('김치, 열무, 김치', 32);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('김치, 열무, 물김치', 18);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('김치, 오이, 소박이', 37);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('김치, 유채, 김치', 62);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('김치, 유채, 물김치', 17);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('김치, 총각, 김치', 41);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('김치, 파, 김치', 49);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('김치, 얼갈이배추, 김치', 30);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('꼬깔나물, 말린것', 285);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('꽃양배추, 생것', 22);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('꽃양배추, 데친것', 20);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('꿀풀(하고초), 생것', 48);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('꿀풀(하고초), 말린것', 309);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('날개콩, 미숙, 생것', 36);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('냉이, 생것', 41);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('냉이, 데친것', 49);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('넘취, 생것', 35);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('넘취, 데친것', 29);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('녹색완두, 미숙, 생것', 93);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('녹색완두, 미숙, 데친것', 110);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('녹색완두, 미숙, 통조림', 98);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('누룩치, 말린것', 280);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('누룩치, 삶아서, 말린것', 290);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('누룩치, 잎, 생것', 72);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('누룩치, 잎, 데친것', 38);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('누룩치, 줄기, 생것', 31);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('누룩치, 줄기, 데친것', 25);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('누리장나무잎, 생것', 65);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('는쟁이냉이, 생것', 28);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('달래, 생것', 28);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('당귀, 일당귀, 뿌리, 생것', 70);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('당귀, 일당귀, 잎, 생것', 43);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('당귀, 참당귀, 잎, 생것', 39);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('당근, 뿌리, 생것', 31);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('당근, 뿌리, 데친것', 31);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('당근, 주스, 캔', 40);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('당근, 주스', 38);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('더덕, 뿌리, 생것', 89);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('더덕, 뿌리, 가루', 339);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('도라지, 뿌리, 생것', 56);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('도라지, 뿌리, 말린것', 324);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('도라지, 뿌리, 가루', 339);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('도라지, 뿌리, 데친것', 49);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돌나물, 생것', 15);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('동아, 생것', 12);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('동아, 데친것', 16);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('두릅, 생것', 33);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('두릅, 데친것', 32);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('두릅, 잎, 생것', 46);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('두릅, 잎, 데친것', 41);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('두릅, 줄기, 생것', 33);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('두릅, 줄기, 데친것', 28);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('두릅, 땅두릅, 생것', 25);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('두릅, 땅두릅, 데친것', 24);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('두릅, 땅두릅, 잎, 생것', 43);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('두릅, 땅두릅, 잎, 데친것', 61);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('두릅, 땅두릅, 줄기, 생것', 17);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('두릅, 땅두릅, 줄기, 데친것', 16);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('둥글레, 잎, 생것', 52);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('둥글레, 잎, 말린것', 289);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('들깨, 싹, 생것', 17);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('들깻잎, 생것', 47);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('들깻잎, 데친것', 32);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('들깻잎, 찐것', 37);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('들깻잎장아찌, 통조림', 76);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('들깻잎장아찌', 124);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('로카, 생것', 17);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('루꼴라, 생것', 25);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('리크, 생것', 54);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('리크, 데친것', 28);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('마늘, 구근, 생것', 123);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('마늘, 구근, 말린것', 333);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('마늘, 구근, 냉동', 126);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('마늘, 구근, 동결건조', 330);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('마늘, 구근, 데친것', 133);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('마늘, 구근, 구운것', 141);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('마늘, 난지형, 구근, 생것', 148);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('마늘, 난지형, 구근, 데친것', 47);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('마늘, 중국산, 구근, 생것', 106);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('마늘, 한지형, 구근, 생것', 124);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('마늘, 한지형, 구근, 데친것', 127);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('마늘, 한지형, 구근, 구운것', 184);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('마늘, 한지형, 구근, 볶은것', 159);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('풋마늘, 잎줄기, 생것', 29);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('풋마늘, 잎줄기, 데친것', 30);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('마늘종, 꽃줄기, 생것', 45);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('마늘종, 꽃줄기, 데친것', 50);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('마늘종, 장아찌', 118);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('마늘, 장아찌', 113);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('마타리, 생것', 45);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('머위, 생것', 17);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('머위, 말린것', 281);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('머위, 삶아서, 말린것', 278);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('머위, 삶은것', 28);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('머위, 데친것', 25);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('메밀, 싹, 생것', 24);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('모링가(드럼스틱), 생것', 66);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('모시풀, 잎, 생것', 64);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('모시풀, 잎, 삶은것', 49);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('모시풀, 잎, 서방종, 생것', 51);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('무, 왜무, 생것', 21);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('무, 조선무, 생것', 15);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('무순, 싹, 생것', 22);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('무청, 왜무, 잎, 생것', 22);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('무청, 조선무, 잎, 생것', 31);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('무시래기, 잎, 말린것, 삶은것', 23);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('무, 절임', 22);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('단무지, 염절임', 12);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('무국물', 1);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('무말랭이, 말린것', 318);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('무말랭이, 무침', 136);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('무장아찌, 뿌리', 131);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('쌈무, 초절임', 15);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('물강활, 말린것', 289);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('물냉이, 생것', 23);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('물쑥, 생것', 36);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('물쑥, 데친것', 47);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('미나리, 농축', 120);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('미나리, 돌미나리(야생), 생것', 21);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('미나리, 돌미나리(야생), 데친것', 19);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('미나리, 물미나리, 생것', 22);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('미나리, 물미나리, 데친것', 25);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('미나리, 물미나리, 잎, 생것', 30);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('미나리, 물미나리, 줄기, 생것', 22);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('미니파프리카, 주황색, 생것', 38);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('미니파프리카, 노란색, 생것', 41);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('미니파프리카, 빨간색, 생것', 41);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('민들레, 생것', 29);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('민들레, 데친것', 30);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('바젤라, 생것', 13);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('바젤라, 데친것', 15);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('바질, 개량종, 생것', 46);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('바질, 재래종, 생것', 47);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('박, 과육, 생것', 21);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('박, 씨, 포함, 생것', 32);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('박고지, 말린것', 268);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('박쥐나무, 잎, 생것', 100);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('밥취나물, 말린것', 282);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('방가지똥, 생것', 46);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('방울다다기양배추, 생것', 49);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('방울다다기양배추, 데친것', 49);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('배암차즈기(곰보배추), 잎, 생것', 25);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('배초향, 잎, 생것', 55);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('배추, 생것', 12);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('배추, 데친것', 17);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('배추, 봄, 재배, 생것', 13);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('배추, 봄, 재배, 삶은것', 14);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('배추, 봄, 재배, 염절임', 15);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('배추, 여름, 재배, 생것', 17);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('배추, 여름, 재배, 삶은것', 17);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('배추, 여름, 재배, 염절임', 17);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('배추, 가을, 재배, 생것', 15);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('배추, 가을, 재배, 삶은것', 14);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('배추, 가을, 재배, 염절임', 18);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('배추, 싹, 생것', 63);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('배추, 노랑봄배추(노지), 생것', 13);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('배추, 노랑봄배추(노지), 데친것', 17);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('배추, 노랑봄배추(노지), 염절임', 16);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('배추, 노랑봄배추(하우스), 생것', 12);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('배추, 노랑봄배추(하우스), 데친것', 15);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('배추, 노랑봄배추(하우스), 염절임', 15);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('배추, 봄동, 생것', 23);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('배추, 봄동, 데친것', 22);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('배추, 불암, 3호(노지), 생것', 23);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('배추, 불암, 3호(노지), 데친것', 33);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('배추, 불암, 3호(노지), 염절임', 30);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('배추, 불암, 3호(하우스), 생것', 13);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('배추, 불암, 3호(하우스), 데친것', 18);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('배추, 불암, 3호(하우스), 염절임', 18);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('배추, 여름배추, 생것', 10);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('배추, 여름배추, 데친것', 12);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('배추, 여름배추, 염절임', 11);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('배추, 우거지, 말린것', 278);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('배추, 우거지, 말린것, 삶은것', 23);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('배추, 유기재배, 생것', 14);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('백모근, 생것', 138);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('백모근, 뿌리, 말린것', 337);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('백모근, 잎, 말린것', 314);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('백합, 뿌리, 생것', 118);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('버드장이, 생것', 38);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('보리, 순, 가루 ', 314);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('보리, 쌀보리, 순, 생것', 24);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('보리, 올보리, 순, 생것', 66);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('보리, 큰알보리, 순, 생것', 24);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('보리, 큰알보리, 순, 동결건조', 283);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('뽕잎, 삶아서, 말린것', 279);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('뽕잎, 삶아서, 말린것, 삶은것', 51);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('뽕잎, 삶은것', 48);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('뽕잎, 생것', 65);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('부지갱이(섬쑥부쟁이), 생것', 30);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('부지갱이(섬쑥부쟁이), 말린것', 258);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('부지갱이(섬쑥부쟁이), 삶아서, 말린것', 296);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('부지갱이(섬쑥부쟁이), 삶아서, 말린것, 삶은것', 48);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('부지갱이(섬쑥부쟁이), 데친것', 33);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('부추, 두메부추, 생것', 46);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('부추, 산부추, 생것', 41);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('부추, 재래종, 생것', 22);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('부추, 재래종, 데친것', 20);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('부추, 호부추, 생것', 30);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('부추, 호부추, 데친것', 32);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('브로콜리, 생것', 32);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('브로콜리, 가루 ', 284);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('브로콜리, 삶은것', 27);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('브로콜리, 데친것', 28);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('브로콜리, 싹, 생것', 31);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('브로콜리, 잎, 생것', 38);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('브로콜리, 잎, 말린것', 258);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('브로콜리, 잎, 삶아서, 말린것', 271);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('비름, 생것', 23);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('비름, 데친것', 27);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('비타민채(다채), 생것', 14);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('비타민채, 싹, 생것', 54);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('비트, 뿌리, 생것', 37);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('비트, 뿌리, 데친것', 26);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('비트, 잎, 생것', 16);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('비트, 잎, 데친것', 15);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('비트, 적비트(홍무), 뿌리, 생것', 34);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('비트, 피클, 뿌리, 통조림', 65);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('사탕무, 생것', 77);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('사탕수수, 생것', 77);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('산마늘, 생것', 36);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('산마늘, 데친것', 37);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('산마늘, 장아찌, 초절임', 51);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('삼나물, 말린것', 293);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('삼붕냐와, 생것', 27);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('삼채, 생것', 23);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('삼채, 데친것', 28);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('삼채, 뿌리, 생것', 49);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('삼채, 잎, 생것', 24);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('삼채, 줄기, 생것', 19);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('삽주나물, 생것', 52);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('상추, 뚝섬적출면, 생것', 14);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('상추, 로메인, 생것', 29);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('상추, 로메인, 청상추, 생것', 23);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('상추, 로메인, 적상추, 생것', 17);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('상추, 롤로로사, 생것', 20);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('상추, 아담, 생것', 9);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('상추, 아시아아이스퀸(청코스), 생것', 24);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('상추, 유레이크, 생것', 16);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('상추, 적상추, 생것', 18);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('상추, 적하계, 생것', 19);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('상추, 천상, 생것', 17);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('상추, 풍성, 생것', 10);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('상추, 반결구상추, 청상추, 생것', 16);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('상추, 완전결구상추, 청상추, 생것', 14);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('상추, 축면상추, 적상추, 생것', 15);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('상추, 치마상추, 청상추, 생것', 20);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('상추, 치마상추, 적상추, 생것', 23);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('생강, 뿌리줄기, 생것', 42);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('생강, 중국산, 뿌리줄기, 생것', 38);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('생강, 피클, 초절임', 19);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('선인장, 보검선인장, 꽃, 생것', 51);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('선인장, 보검선인장, 열매, 생것', 83);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('선인장, 보검선인장, 줄기, 생것', 34);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('선인장, 저단선인장, 열매, 생것', 91);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('선인장, 저단선인장, 줄기, 생것', 75);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('섬초롱, 생것', 41);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('섬초롱, 데친것', 34);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('세발나물, 생것', 18);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('세발나물, 데친것', 23);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('셀러리, 생것', 17);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('셀러리, 데친것', 17);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소리쟁이, 뿌리, 말린것', 317);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소리쟁이, 잎, 말린것', 259);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('솔장다리, 생것', 31);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('쇠귀나물, 뿌리, 생것', 126);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('쇠귀나물, 뿌리, 데친것', 128);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('수리취(떡취), 생것', 64);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('숙주나물, 생것', 13);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('숙주나물, 데친것', 12);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('숙주나물, 찐것', 16);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('순무, 전체, 생것', 27);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('순무, 전체, 데친것', 28);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('순무, 뿌리, 생것', 30);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('순무, 뿌리, 데친것', 33);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('순무, 염절임', 23);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('순무, 잎, 생것', 21);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('순무, 잎, 데친것', 20);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('순무, 잎, 염절임', 29);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('스테비아, 생것', 40);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('스테비아, 말린것', 303);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('시금치, 생것', 33);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('시금치, 데친것', 23);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('시금치, 노지, 생것', 29);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('시금치, 노지, 데친것', 37);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('시금치, 포항초, 생것', 35);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('시금치, 포항초, 데친것', 34);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('시금치, 하우스, 생것', 27);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('시금치, 하우스, 데친것', 32);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('시금치, 섬초, 생것', 24);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('시금치, 섬초, 데친것', 32);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('신선초(명일엽), 생것', 24);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('쌈추, 생것', 25);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('쌈추, 싸미나, 생것', 20);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('쌈추, 홍쌈추, 생것', 24);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('쑥, 생것', 37);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('쑥, 말린것', 272);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('쑥, 데친것', 39);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('쑥, 사자발쑥, 생것', 56);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('쑥, 사자발쑥, 데친것', 55);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('쑥갓, 생것', 15);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('쑥갓, 데친것', 21);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('쑥부쟁이, 생것', 26);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('씀바귀, 생것', 43);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('씀바귀, 데친것', 31);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('씀바귀, 뿌리, 생것', 71);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('아스파라거스, 생것', 15);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('아스파라거스, 데친것', 23);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('아스파라거스, 통조림', 14);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('아스파라거스, 그린아스파라거스, 생것', 15);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('아스파라거스, 하얀색, 생것', 21);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('아욱, 생것', 37);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('아욱, 데친것', 31);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('아이비카, 닥풀, 말린것', 260);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('아주까리, 순, 말린것', 287);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('아주까리, 잎, 생것', 82);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('아티초크, 생것', 47);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('아티초크, 삶은것', 53);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('아티초크, 냉동', 38);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('아티초크, 냉동, 삶은것', 45);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('알로에, 과육, 생것', 3);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('알로에, 음료', 40);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('알팔파, 싹, 생것', 21);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('양배추, 생것', 33);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('양배추, 데친것', 32);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('양배추, 찐것', 32);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('양배추, 적양배추, 생것', 41);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('양배추, 적양배추, 싹, 생것', 39);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('양배추, 샐러드, 코울슬로', 153);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('양상추, 생것', 18);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('양상추, 적양상추, 생것', 18);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('양파, 생것', 27);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('양파, 말린것', 340);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('양파, 데친것', 27);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('양파, 중국산, 생것', 30);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('양파, 자색, 양파, 생것', 30);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('양파, 레드프라임, 생것', 37);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('양파, 썬파워, 생것', 32);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('양파, 샬롯, 생것', 80);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('양파링, 튀김옷, 냉동', 258);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('양파링, 튀김옷, 튀긴것(튀김옷)', 411);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('양파, 장아찌', 79);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('양하, 생것', 13);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('어수리, 생것', 31);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('어수리, 잎, 생것', 45);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('얼갈이배추, 생것', 14);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('얼갈이배추, 데친것', 14);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('얼갈이배추, 염절임', 15);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('얼레지, 뿌리, 말린것', 339);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('음나무(엄나무, 개두릅), 잎, 생것', 41);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('음나무(엄나무, 개두릅), 잎, 데친것', 37);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('엉겅퀴, 말린것', 267);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('엉겅퀴, 삶아서, 말린것', 279);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('여주(고야), 생것', 22);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('연근, 생것', 75);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('연근, 데친것', 62);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('연근, 조림', 261);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('열대비름(아마란스), 잎, 생것', 45);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('열무, 생것', 14);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('열무, 데친것', 19);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('염교(락교), 뿌리줄기, 생것', 118);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('염교(락교), 장아찌, 초절임', 85);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('영아자, 생것', 34);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('영아자, 말린것', 278);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('영아자, 데친것', 36);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('오이, 개량종, 생것', 14);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('오이, 겨울살이청장, 생것', 13);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('오이, 늙은오이, 생것', 9);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('오이, 취청, 생것', 13);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('오이, 피클, 초절임', 91);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('오이지, 염절임', 10);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('오크라, 생것', 30);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('오크라, 데친것', 33);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('옥수수, 순, 생것', 40);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('왕호장잎, 생것', 79);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('우엉, 생것', 69);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('우엉, 데친것', 52);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('우엉조림, 장조림', 149);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('울금, 뿌리줄기, 생것', 87);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('울외장아찌, 염절임', 67);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('원추리, 생것', 35);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('원추리, 데친것', 28);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('유채, 싹, 생것', 78);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('유채, 잎, 생것', 31);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('유채, 잎, 데친것', 27);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('유채, 동채, 생것', 29);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('유채, 동채, 데친것', 30);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('유채, 서양종, 잎줄기, 생것', 35);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('유채, 서양종, 잎줄기, 데친것', 31);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('잇꽃(홍화), 잎, 생것', 45);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('비비추(이밥추), 생것', 48);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('자운영, 생것', 40);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('잔대, 뿌리, 생것', 79);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('잔대, 순, 생것', 55);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('적하수오잎, 잎, 생것', 35);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('전호, 생것', 23);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('제비쑥, 생것', 35);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('조뱅이, 생것', 47);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('좀홍당무, 뿌리, 생것', 18);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('죽순, 순, 생것', 24);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('죽순, 순, 삶아서, 말린것', 314);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('죽순, 순, 삶은것', 19);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('죽순, 순, 데친것', 30);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('죽순, 순, 통조림', 16);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('줄나물, 말린것', 236);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('진달래꽃, 생것', 26);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('질경이, 생것', 48);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('질경이, 데친것', 45);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('참나물, 야생, 생것', 39);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('참나물, 야생, 말린것', 309);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('참나물, 재배, 생것', 20);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('참나물, 재배, 말린것', 308);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('참나물, 재배, 데친것', 22);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('참반디, 말린것', 288);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('참빗살나무, 잎, 생것', 61);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('참죽나물, 생것', 46);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('참죽나물, 말린것', 280);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('참죽나물, 삶아서, 말린것', 269);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('참죽나물, 삶아서, 말린것, 삶은것', 52);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('참죽나물, 데친것', 44);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('청경채, 생것', 10);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('청경채, 데친것', 11);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('초석잠, 뿌리, 생것', 76);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('총각무, 생것', 22);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('총각무, 뿌리, 생것', 30);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('총각무, 잎, 생것', 24);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('취나물, 개미취, 생것', 53);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('취나물, 미역취, 생것', 48);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('취나물, 참취, 생것', 51);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('취나물, 참취, 말린것', 265);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('취나물, 참취, 말린것, 삶은것', 55);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('취나물, 참취, 삶아서, 말린것', 299);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('취나물, 참취, 삶아서, 말린것, 데친것', 49);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('취나물, 참취, 데친것', 49);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('치커리, 치콘, 생것', 14);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('치커리, 뿌리, 생것', 72);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('치커리, 잎, 생것', 16);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('치커리, 적치커리, 잎, 생것', 25);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('칠면초, 생것', 27);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('케일, 생것', 26);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('케일, 꽃케일, 생것', 33);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('케일, 로얄채, 생것', 49);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('케일, 쌈채소, 생것', 27);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('케일, 적꽃케일, 생것', 31);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('케일, 하우스, 생것', 22);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('콜라비, 생것', 22);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('콜라비, 데친것', 21);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('콩나물, 생것', 36);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('콩나물, 말린것', 406);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('콩나물, 가루 ', 409);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('콩나물, 삶은것', 33);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('콩나물, 녹색콩나물, 생것', 27);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('콩잎, 잎, 생것', 94);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('털머위, 잎, 생것', 51);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('털머위, 줄기, 생것', 62);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('토란대, 줄기, 생것', 16);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('토란대, 줄기, 말린것', 261);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('토란대, 줄기, 말린것, 삶은것', 20);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('토란대, 줄기, 데친것', 20);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('토마토, 생것', 19);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('토마토, 데친것', 17);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('토마토, 통조림', 20);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('토마토, 방울토마토, 생것', 25);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('토마토, 유기재배, 생것', 17);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('토마토, 흑토마토, 생것', 21);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('토마토, 흑토마토, 데친것', 19);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('토마토, 대저, 생것', 23);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('토마토, 대저, 데친것', 26);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('토마토, 과채, 음료', 41);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('토마토, 페이스트', 98);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('토마토, 퓨레, 통조림', 41);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('토스카노(잎브로콜리), 생것', 40);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('퉁퉁마디(함초), 노지, 생것', 19);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('퉁퉁마디(함초), 하우스, 생것', 19);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('퉁퉁마디환(함초환)', 262);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('파, 생것', 29);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('파, 골파, 생것', 29);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('파, 실파, 생것', 16);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('파, 쪽파, 생것', 21);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('파, 대파, 생것', 23);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('파드득나물(삼엽채), 생것', 25);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('파슬리, 생것', 36);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('파프리카, 노란색, 데친것', 25);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('파프리카, 노란색, 생것', 24);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('파프리카, 빨간색, 데친것', 28);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('파프리카, 빨간색, 생것', 26);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('파프리카, 주황색, 데친것', 27);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('파프리카, 주황색, 생것', 24);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('파프리카, 초록색, 생것', 14);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('파프리카, 외국산, 노란색, 생것', 23);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('파프리카, 외국산, 빨간색, 생것', 23);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('파프리카, 외국산, 주황색, 생것', 31);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('편강, 당조림', 376);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('피망, 빨간색, 생것', 28);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('피망, 빨간색, 데친것', 33);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('피망, 초록색, 생것', 22);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('피망, 초록색, 데친것', 23);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('할라피뇨, 통조림', 27);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('해바라기, 싹, 생것', 9);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('호박, 싹, 생것', 38);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('호박, 잎, 생것', 45);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('호박, 잎, 데친것', 32);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('호박, 잎, 찐것', 49);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('호박, 국수호박, 생것', 18);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('호박, 국수호박, 데친것', 16);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('호박, 늙은호박, 생것', 34);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('호박, 늙은호박, 데친것', 30);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('호박, 늙은호박, 찐것', 37);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('호박, 단호박, 생것', 57);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('호박, 단호박, 데친것', 30);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('호박, 단호박, 찐것', 66);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('호박, 애호박, 생것', 22);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('호박, 애호박, 말린것', 284);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('호박, 애호박, 말린것, 데친것', 31);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('호박, 애호박, 데친것', 21);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('호박, 쥬키니, 생것', 31);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('호박, 쥬키니, 데친것', 11);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('호박, 차요테, 초록색, 생것', 21);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('호박, 차요테, 하얀색, 생것', 19);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('호박고지, 늙은호박, 말린것', 275);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('호박고지, 애호박, 말린것', 277);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('호박즙, 천연과즙', 21);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('홑잎나물, 생것', 96);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('홑잎나물, 데친것', 78);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('검은비닐버섯, 생것', 13);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('검은비닐버섯, 말린것', 177);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('나도팽나무버섯, 생것', 16);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('나도팽나무버섯, 말린것', 182);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('노루궁뎅이버섯, 생것', 17);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('노루궁뎅이버섯, 말린것', 179);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('느타리버섯, 생것', 18);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('느타리버섯, 데친것', 23);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('느타리버섯, 노랑느타리버섯, 생것', 16);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('느타리버섯, 분홍느타리버섯, 생것', 24);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('느타리버섯, 여름느타리버섯, 생것', 21);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('느타리버섯, 참타리버섯, 생것', 16);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('느타리버섯, 참타리버섯, 데친것', 20);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('느타리버섯, 청느타리버섯, 생것', 18);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('느티만가닥버섯, 생것', 21);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('느티만가닥버섯, 데친것', 21);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('능이버섯(향버섯), 생것', 17);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('동충하초, 누에동충하초, 말린것', 133);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('만가닥버섯, 생것', 23);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('목이버섯, 생것', 11);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('목이버섯, 말린것', 167);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('목이버섯, 데친것', 13);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('밤버섯, 생것', 17);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('버들송이버섯, 생것', 20);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('버들송이버섯, 갓, 말린것', 191);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('버들송이버섯, 줄기, 말린것', 183);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('뽕나무버섯, 야생, 갓, 말린것', 195);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('뽕나무버섯, 야생, 줄기, 말린것', 180);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('뽕나무버섯, 재배, 갓, 말린것', 192);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('뽕나무버섯, 재배, 줄기, 말린것', 182);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('상황버섯, 말린것', 179);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('석이버섯, 말린것', 165);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('송이버섯, 생것', 21);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('송이버섯, 데친것', 22);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('싸리버섯, 생것', 20);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('싸리버섯, 말린것', 179);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('아위버섯, 생것', 20);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('애느타리버섯, 생것', 16);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('양송이버섯, 생것', 15);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('양송이버섯, 가루', 176);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('양송이버섯, 데친것', 15);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('양송이버섯, 통조림', 17);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('영지버섯, 말린것', 187);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('율무느타리버섯, 생것', 21);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('잎새버섯, 생것', 23);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('잣버섯, 말린것', 184);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('큰느타리버섯(새송이버섯), 생것', 21);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('큰느타리버섯(새송이버섯), 가루', 184);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('큰느타리버섯(새송이버섯), 데친것', 19);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('큰양송이버섯, 생것', 18);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('팽이버섯, 갈뫼, 생것', 18);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('팽이버섯, 백로, 생것', 22);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('팽이버섯, 야생, 생것', 18);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('팽이버섯, 재배, 생것', 20);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('팽이버섯, 재배, 데친것', 18);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('포타벨라, 생것', 16);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('표고버섯, 가루', 186);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('표고버섯, 배지재배, 갓, 생것', 26);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('표고버섯, 배지재배, 갓, 말린것', 183);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('표고버섯, 배지재배, 갓, 말린것, 삶은것', 24);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('표고버섯, 배지재배, 갓, 데친것', 21);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('표고버섯, 배지재배, 대, 생것', 39);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('표고버섯, 배지재배, 대, 말린것', 180);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('표고버섯, 배지재배, 대, 말린것, 삶은것', 31);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('표고버섯, 배지재배, 대, 데친것', 32);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('표고버섯, 배지재배, 생것', 36);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('표고버섯, 배지재배, 말린것', 181);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('표고버섯, 배지재배, 말린것, 삶은것', 29);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('표고버섯, 배지재배, 데친것', 29);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('표고버섯, 참나무재배, 생것', 18);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('표고버섯, 참나무재배, 데친것', 18);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('표고버섯, 참나무재배, 말린것', 178);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('표고버섯, 참나무재배, 말린것, 삶은것', 35);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('풀버섯, 생것', 15);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('흰깔때기버섯, 생것', 19);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('감, 탈삽, 생것', 63);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('감, 단감, 생것', 51);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('감, 대봉(갑주백묵), 생것', 70);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('감, 둥시, 생것', 71);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('감, 둥시, 말린것', 223);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('감, 연시, 생것', 65);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('감, 연시, 냉동', 66);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('감, 잼, 단감', 225);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('감, 주스', 41);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('감말랭이, 말린것', 255);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('곶감, 말린것', 214);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('구기자, 열매, 재래종, 생것', 69);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('구아바, 생것', 38);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('구아바, 넥타, 과육, 20%', 51);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('구아바, 주스, 과즙, 음료(10%)', 51);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('구즈베리, 생것', 52);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('귤, 통조림', 64);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('귤, 부지화(한라봉), 생것', 52);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('귤, 온주밀감, 생것', 36);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('귤, 임온주, 생것', 43);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('귤, 조생, 생것', 39);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('귤, 천혜향, 생것', 44);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('귤, 잼', 309);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('귤, 주스, 천연과즙', 39);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('귤, 주스, 무가당', 44);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('귤, 주스, 무가당, 캔', 47);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('금귤, 생것', 73);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('꾸지뽕, 열매, 생것', 74);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('다래, 생것', 67);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('대추, 생것', 105);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('대추, 말린것', 276);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('대추야자, 말린것', 266);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('두리안, 생것', 133);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('딸기, 개량종, 생것', 36);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('딸기, 말린것', 302);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('딸기, 설향, 생것', 34);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('딸기, 재래종, 생것', 29);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('딸기, 잼', 303);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('라임, 생것', 30);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('라임, 주스, 캔', 21);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('라임, 주스, 천연과즙', 25);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('라즈베리, 냉동', 52);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('라즈베리, 생것', 52);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('람부탄, 통조림', 82);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('레몬, 생것', 28);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('레몬, 과즙', 26);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('롱안, 생것', 60);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('롱안, 말린것', 286);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('리치, 생것', 63);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('리치, 냉동', 56);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('망고, 생것', 61);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('망고, 애플망고, 생것', 49);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('망고, 음료', 28);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('망고스틴, 생것', 67);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('매실, 생것', 41);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('매실, 선암매, 생것', 39);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('매실, 천매, 생것', 37);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('매실, 농축액, 당절임', 181);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('매실, 절임, 염절임', 33);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('머루, 과육, 생것', 44);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('머루, 껍질, 생것', 81);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('머루, 개량종, 생것', 62);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('머루, 머스켓베일리에이, 생것 ', 81);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('머루, 주스', 81);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멜론, 감로, 생것', 21);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멜론, 머스크, 생것', 40);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멜론, 화이트, 생것', 38);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('모과, 생것', 78);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('무화과, 생것', 54);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('무화과, 수입산, 말린것', 319);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('무화과, 통조림', 81);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('무화과, 승정도후인, 생것', 52);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('무화과, 승정도후인, 말린것', 254);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('무화과, 봉래시, 생것', 45);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('바나나, 생것', 84);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('바나나, 말린것', 299);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('바나나칩, 튀긴것', 517);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('배, 돌배, 생것', 46);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('배, 돌배, 껍질, 포함, 생것', 48);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('배, 백운배, 생것', 39);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('배, 신고, 생것', 46);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('배, 장심랑, 생것', 35);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('배, 중국산, 생것', 47);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('배, 만풍, 생것', 44);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('배, 원황, 생것', 46);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('배즙', 52);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('배, 음료, 캔', 42);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('버찌, 생것', 60);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('버찌, 통조림', 74);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('버찌, 미국산, 생것', 66);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('버찌, 일본산, 생것', 60);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('복분자, 생것', 60);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('복숭아, 당절임', 311);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('복숭아, 미숙, 생것', 48);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('복숭아, 백도, 생것', 49);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('복숭아, 백도, 고형물, 통조림', 68);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('복숭아, 백도, 액즙, 통조림', 63);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('복숭아, 백도, 통조림', 65);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('복숭아, 천도, 생것', 32);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('복숭아, 황도, 생것', 49);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('복숭아, 황도, 통조림', 81);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('복숭아, 황도, 고형물, 통조림', 83);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('복숭아, 황도, 액즙, 통조림', 79);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('복숭아, 천중도, 생것', 49);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('복숭아, 넥타', 54);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('복숭아, 잼', 211);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('블랙베리, 생것', 43);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('블랙커런트, 생것', 63);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('블루베리, 생것', 48);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('블루베리, 말린것', 325);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('블루베리, 냉동', 41);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('블루베리, 통조림', 88);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('블루베리, 잼', 283);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('비파, 생것', 45);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('비파, 통조림', 81);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('사과, 말린것', 275);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('사과, 통조림', 66);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('사과, 부사(후지), 생것', 53);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('사과, 아오리, 껍질제거, 생것', 52);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('사과, 아오리, 껍질, 포함, 생것', 49);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('사과, 홍옥, 생것', 56);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('사과, 넥타', 53);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('사과, 잼', 267);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('사과, 음료, 캔', 46);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('사과, 주스, 농축, 과즙', 43);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('사과, 음료, 팩', 29);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('사과, 주스, 무가당', 43);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('산딸기, 생것', 55);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('산수유, 과육, 말린것', 292);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('산수유, 열매, 생것', 112);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('살구, 생것', 30);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('살구, 말린것', 258);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('살구, 통조림', 48);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('살구, 넥타', 41);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('살구, 잼', 304);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('석류, 생것', 77);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소귀나무, 열매, 생것', 24);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('수박, 적육질, 생것', 31);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('수박, 황육질, 생것', 36);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('산자나무, 열매(씨벅톤), 생것', 70);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('아떼모야, 생것', 73);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('아로니아, 네로, 생것', 60);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('아로니아, 바이킹, 냉동', 68);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('아보카도, 생것', 187);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('아세로라, 감미종, 생것', 36);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('아세로라, 주스, 과즙, 음료(10%)', 42);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('애플수박, S-비너스, 생것', 40);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('앵두, 생것', 61);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('엘더베리, 생것', 73);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('오디, 생것', 56);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('오디, 재래종, 생것', 54);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('오렌지, 생것', 44);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('오렌지, 마멀레이드', 223);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('오렌지, 주스', 42);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('오렌지, 음료, 캔', 41);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('오렌지, 주스, 가당', 34);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('오렌지, 주스, 가당, 칼슘강화', 48);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('오렌지, 주스, 무가당', 39);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('오렴자(카람볼라), 생것', 30);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('오미자, 생것', 81);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('오미자, 말린것', 362);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('오미자, 농축액, 당절임', 259);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('올리브, 피클, 검정색(완숙)', 118);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('올리브, 피클, 초록색(미숙)', 137);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('용과, 백육종, 생것', 44);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('용과, 적육종, 생것', 45);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('용과, 황색종, 생것', 54);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('유자, 과육, 생것', 40);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('유자, 전체, 생것', 49);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('유자, 껍질, 생것', 55);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('유자, 농축액, 당절임', 243);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('으름, 생것', 158);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('자두, 생것', 26);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('자두, 말린것', 221);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('자두, 대석, 생것', 32);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('자두, 솔담, 생것', 0);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('자두, 후무사, 생것', 44);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('자몽(그레이프프루트), 생것', 32);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('자몽(그레이프프루트), 주스, 천연과즙', 40);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('자몽(그레이프프루트), 주스, 과즙, 음료(50%)', 46);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('자몽(그레이프프루트), 주스, 과즙, 음료(20%)', 39);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('자몽(그레이프프루트), 주스, 가당, 캔', 46);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('자몽(그레이프프루트), 주스, 무가당, 캔', 34);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('잭프루트, 생것', 95);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('잭프루트, 통조림', 92);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('참외, 씨, 포함, 생것', 47);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('참외, 씨, 제거, 생것', 45);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('참외, 금싸라기, 씨, 제거, 흰색과육, 생것', 27);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('체리, 생것', 67);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('체리, 고형물, 통조림', 134);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('체리, 액즙, 통조림', 137);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('칼슘나무, 열매, 생것', 50);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('크랜베리, 생것', 46);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('크랜베리, 말린것', 314);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('크랜베리, 주스, 칵테일', 54);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('키위, 생것', 64);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('키위, 골드, 생것', 54);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('키위, 그린, 생것', 66);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('키위, 주스, 퓨레, 40%', 180);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('탱자, 생것', 84);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('파인애플, 생것', 53);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('파인애플, 고형물, 통조림', 78);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('파인애플, 액즙, 통조림', 76);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('파인애플, 넥타', 71);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('파인애플, 주스, 캔', 53);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('파인애플, 주스', 43);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('파파야, 생것', 38);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('파파야, 미숙, 생것', 27);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('파파야, 적숙, 생것', 40);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('파파야, 완숙, 생것', 39);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('파파야, 그린파파야, 생것', 20);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('백향과(패션프루트), 씨, 포함, 생것', 100);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('패션프루트, 주스, 천연과즙', 64);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('패션프루트, 주스, 황색과육', 60);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('패션프루트, 주스, 자색과육', 51);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('포도, 건포도', 297);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('포도, 통조림', 69);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('포도, 거봉, 생것', 61);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('포도, 거봉, 껍질, 포함, 생것', 68);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('포도, 델라웨어, 생것', 67);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('포도, 마스캇함브르그, 생것', 66);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('포도, 세레단, 생것', 58);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('포도, 청포도, 생것', 48);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('포도, 캠벨얼리, 생것', 60);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('포도, 캠벨얼리, 껍질, 포함, 생것', 51);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('포도, 캠벨얼리, 껍질, 씨, 포함, 생것', 58);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('포도, 청포도(힘로드시드레스), 생것', 47);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('포도, 청포도(힘로드시드레스), 껍질, 포함, 생것', 45);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('포도, 청포도(샤인머스켓), 껍질, 포함, 생것', 69);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('포도, 넥타', 66);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('포도, 잼', 292);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('포도, 주스', 47);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('포도, 주스, 캔', 60);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('포도, 주스, 농축, 과즙', 47);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('포도, 주스, 천연과즙', 55);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('포도, 주스, 과즙, 음료', 51);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('포도즙, 천연과즙, 레토르트 ', 48);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('플럼코트, 생것', 47);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('프루트샐러드, 통조림', 82);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('프루트칵테일, 통조림', 75);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('프루트펀치, 통조림', 48);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('개구리고기, 생것', 75);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('거위고기, 살코기, 생것', 161);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('거위고기, 살코기, 구운것', 238);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('거위, 부산물, 간, 생것', 133);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고래고기, 생것', 111);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고래고기, 복부정육, 생것', 298);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고래고기, 복부지육, 생것', 449);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고래고기, 붉은살, 냉동', 132);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고래고기, 붉은살, 염절임', 160);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고래, 부산물, 꼬리, 생것', 284);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고래, 부산물, 꼬리, 냉동', 246);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('꿩고기, 숫꿩, 생것', 125);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('꿩고기, 암꿩, 생것', 122);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('닭고기, 구운것', 243);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('닭고기, 전체, 튀긴것', 280);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('닭고기, 가슴(껍질, 제거), 생것', 107);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('닭고기, 가슴(껍질, 제거), 삶은것', 128);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('닭고기, 가슴(껍질, 제거), 구운것(팬)', 165);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('닭고기, 가슴(껍질, 제거), 튀긴것(튀김옷)', 255);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('닭고기, 날개, 생것', 175);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('닭고기, 날개, 삶은것', 229);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('닭고기, 날개, 구운것(오븐)', 240);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('닭고기, 날개, 튀긴것(튀김옷)', 324);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('닭고기, 날개, 튀긴것(밀가루옷)', 321);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('닭고기, 넓적다리(껍질, 제거), 생것', 186);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('닭고기, 넓적다리(껍질, 제거), 삶은것', 226);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('닭고기, 넓적다리(껍질, 제거), 구운것(팬)', 234);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('닭고기, 넓적다리(껍질, 제거), 튀긴것', 218);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('닭고기, 다리, 생것', 152);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('닭고기, 다리, 삶은것', 187);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('닭고기, 다리, 구운것(오븐)', 213);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('닭고기, 다리, 튀긴것(튀김옷)', 317);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('닭고기, 다리(껍질, 제거), 튀긴것', 208);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('닭고기, 목, 생것', 331);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('닭고기, 목, 튀긴것(튀김옷)', 330);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('닭고기, 살코기, 생것', 115);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('닭고기, 살코기, 삶은것', 143);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('닭고기, 살코기, 튀긴것(튀김옷)', 289);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('닭고기, 성계, 생것', 177);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('닭고기, 영계, 삶은것', 247);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('닭고기, 오골계, 생것', 137);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('닭고기, 토종, 생것', 118);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('닭고기, 토종, 껍질', 339);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('닭고기, 토종, 가슴', 107);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('닭고기, 토종, 날개', 122);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('닭고기, 토종, 다리', 128);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('닭고기, 토종, 살코기', 108);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('닭, 부산물, 간, 생것', 116);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('닭, 부산물, 간, 삶은것', 167);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('닭, 부산물, 모래주머니, 생것', 85);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('닭, 부산물, 모래주머니, 구운것(오븐)', 132);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('닭, 부산물, 심장, 생것', 207);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('닭, 부산물, 심장, 삶은것', 185);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('닭, 부산물, 닭발, 삶은것', 215);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('닭뼈, 육수', 7);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('닭, 육수', 12);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('닭꼬치', 254);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돼지고기, 갈비, 생것', 230);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돼지고기, 갈비, 삶은것', 289);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돼지고기, 갈비, 구운것(팬)', 265);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돼지고기, 갈비(갈비살), 생것', 202);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돼지고기, 뒷다리, 생것', 121);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돼지고기, 뒷다리, 삶은것', 209);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돼지고기, 뒷다리, 구운것(팬)', 210);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돼지고기, 뒷다리(도가니살), 생것', 129);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돼지고기, 뒷다리(뒷사태살), 생것', 134);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돼지고기, 뒷다리(보섭살), 생것', 137);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돼지고기, 뒷다리(볼기살), 생것', 132);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돼지고기, 뒷다리(설깃살), 생것', 138);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돼지고기, 뒷다리(홍두깨살), 생것', 135);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돼지고기, 등심, 생것', 135);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돼지고기, 등심, 삶은것', 203);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돼지고기, 등심, 구운것(팬)', 184);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돼지고기, 등심(등심덧살), 생것', 199);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돼지고기, 등심(알등심살), 생것', 144);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돼지고기, 목심(목심살), 생것', 221);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돼지고기, 목심(목심살), 삶은것', 276);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돼지고기, 목심(목심살), 구운것(팬)', 258);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돼지고기, 사태, 생것', 154);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돼지고기, 사태, 삶은것', 201);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돼지고기, 사태, 구운것(팬)', 209);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돼지고기, 살코기, 생것', 186);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돼지고기, 삼겹살(갈매기살), 생것', 186);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돼지고기, 삼겹살(등갈비), 생것', 231);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돼지고기, 삼겹살(삼겹살), 생것', 379);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돼지고기, 삼겹살(삼겹살), 삶은것', 414);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돼지고기, 삼겹살(삼겹살), 구운것(팬)', 469);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돼지고기, 삼겹살(오돌삼겹), 생것', 316);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돼지고기, 삼겹살(토시살), 생것', 140);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돼지고기, 안심(안심살), 생것', 123);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돼지고기, 안심(안심살), 삶은것', 177);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돼지고기, 안심(안심살), 구운것(팬)', 172);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돼지고기, 앞다리(꾸리살), 생것', 134);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돼지고기, 앞다리(부채살), 생것', 151);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돼지고기, 앞다리(앞다리살), 생것', 159);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돼지고기, 앞다리(앞사태살), 생것', 131);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돼지고기, 앞다리(주걱살), 생것', 143);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돼지고기, 앞다리(항정살), 생것', 298);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돼지, 부산물, 간, 생것', 125);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돼지, 부산물, 간, 삶은것', 165);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돼지, 부산물, 대장, 생것', 219);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돼지, 부산물, 대장, 삶은것', 179);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돼지, 부산물, 맹장, 생것', 358);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돼지, 부산물, 머리고기, 생것', 272);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돼지, 부산물, 비장, 생것', 86);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돼지, 부산물, 소장(곱창), 생것', 71);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돼지, 부산물, 소장(곱창), 삶은것', 171);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돼지, 부산물, 신장, 생것', 109);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돼지, 부산물, 신장, 삶은것', 151);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돼지, 부산물, 심장, 생것', 113);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돼지, 부산물, 심장, 삶은것', 148);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돼지, 부산물, 위, 생것', 111);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돼지, 부산물, 자궁, 생것', 73);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돼지, 부산물, 족발, 생것', 212);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돼지, 부산물, 족발, 삶은것', 238);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돼지, 부산물, 족발, 조미, 삶은것', 220);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돼지, 부산물, 직장, 생것', 332);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돼지, 부산물, 췌장, 생것', 152);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돼지, 부산물, 허파, 생것', 85);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돼지, 부산물, 허파, 삶은것', 99);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소시지, 말린것', 497);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소시지, 리용소시지', 192);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소시지, 볼로냐소시지', 251);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소시지, 위너(비엔나)소시지', 254);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소시지, 이탈리안소시지', 346);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소시지, 프랑크푸르트소시지', 244);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('햄, 등심햄', 126);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('햄, 런천미트햄', 201);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('햄, 로스햄', 128);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('햄, 본레스햄, 구운것', 145);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('햄, 본인햄', 219);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('햄, 슬라이스햄', 163);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('햄, 어깨살햄', 231);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('포크커틀릿, 냉동', 286);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('포크커틀릿, 냉동, 튀긴것', 367);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돼지불고기, 생것', 132);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('베이컨', 245);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('베이컨, 구운것', 548);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('순대', 116);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('순대, 찐것', 180);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('메추리고기, 생것', 208);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멧돼지고기, 생것', 268);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멧돼지고기, 앞다리, 생것', 188);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 미국산, 갈비, 구운것(오븐)', 400);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 미국산, 목심(목심살), 생것', 265);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 미국산, 목심(목심살), 삶은것', 359);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 미국산, 사태, 끓인것', 201);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 미국산, 설도, 구운것(석쇠)', 164);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 미국산, 안심(안심살), 구운것', 267);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우, 갈비, 생것', 298);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우, 등심, 생것', 304);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우, 등심, 삶은것', 348);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우, 등심, 구운것(팬)', 387);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우, 양지, 생것', 247);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우, 양지, 삶은것', 268);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우, 양지, 구운것(팬)', 302);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우, 채끝(채끝살), 생것', 124);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1++등급), 등심, 생것', 278);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1++등급), 목심(목심살), 생것', 218);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1++등급), 설도(보섭살), 생것', 204);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1++등급), 설도(설깃살), 생것', 196);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1++등급), 앞다리(꾸리살), 생것', 167);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1++등급), 우둔(우둔살), 생것', 171);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1++등급), 우둔(홍두깨살), 생것', 161);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1++등급), 양지(양지머리), 생것', 198);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1++등급), 양지(업진살), 생것', 253);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1++등급), 채끝(채끝살), 생것', 265);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(3등급), 등심, 생것', 117);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(3등급), 목심(목심살), 생것', 102);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(3등급), 설도(보섭살), 생것', 108);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(3등급), 설도(설깃살), 생것', 104);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(3등급), 앞다리(꾸리살), 생것', 103);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(3등급), 우둔(우둔살), 생것', 107);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(3등급), 우둔(홍두깨살), 생것', 105);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(3등급), 양지(양지머리), 생것', 105);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(3등급), 양지(업진살), 생것', 112);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(3등급), 채끝(채끝살), 생것', 114);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1등급), 갈비(꽃갈비), 생것', 383);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1등급), 갈비(본갈비), 생것', 303);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1등급), 갈비(안창살), 생것', 284);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1등급), 갈비(제비추리), 생것', 175);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1등급), 갈비(참갈비), 생것', 390);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1등급), 갈비(토시살), 생것', 264);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1등급), 등심(꽃등심살), 생것', 326);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1등급), 등심(살치살), 생것', 309);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1등급), 등심(아래등심살), 생것', 256);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1등급), 등심(윗등심살), 생것', 301);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1등급), 목심(목심살), 생것', 189);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1등급), 사태(뒷사태), 생것', 151);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1등급), 사태(뭉치사태), 생것', 146);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1등급), 사태(상박살), 생것', 165);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1등급), 사태(아롱사태), 생것', 256);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1등급), 사태(앞사태), 생것', 146);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1등급), 살코기, 생것', 207);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1등급), 설도(도가니살), 생것', 160);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1등급), 설도(보섭살), 생것', 161);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1등급), 설도(삼각살), 생것', 221);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1등급), 설도(설깃머리살), 생것', 193);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1등급), 설도(설깃살), 생것', 200);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1등급), 안심(안심살), 생것', 200);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1등급), 앞다리(갈비덧살), 생것', 184);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1등급), 앞다리(꾸리살), 생것', 155);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1등급), 앞다리(부채덮개살), 생것', 149);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1등급), 앞다리(부채살), 생것', 261);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1등급), 앞다리(앞다리살), 생것', 177);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1등급), 양지(앞치마살), 생것', 284);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1등급), 양지(양지머리), 생것', 185);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1등급), 양지(업진살), 생것', 251);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1등급), 양지(업진안살), 생것', 221);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1등급), 양지(차돌박이), 생것', 394);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1등급), 양지(치마살), 생것', 217);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1등급), 양지(치마양지), 생것', 179);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1등급), 우둔(우둔살), 생것', 164);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1등급), 우둔(홍두깨살), 생것', 145);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1등급), 채끝(채끝살), 생것', 218);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1+등급), 갈비(꽃갈비), 생것', 391);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1+등급), 갈비(본갈비), 생것', 375);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1+등급), 갈비(안창살), 생것', 310);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1+등급), 갈비(제비추리), 생것', 184);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1+등급), 갈비(참갈비), 생것', 361);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1+등급), 갈비(토시살), 생것', 261);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1+등급), 등심(꽃등심살), 생것', 332);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1+등급), 등심(살치살), 생것', 390);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1+등급), 등심(아래등심살), 생것', 288);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1+등급), 등심(윗등심살), 생것', 329);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1+등급), 목심(목심살), 생것', 222);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1+등급), 사태(뒷사태), 생것', 151);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1+등급), 사태(뭉치사태), 생것', 137);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1+등급), 사태(상박살), 생것', 207);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1+등급), 사태(아롱사태), 생것', 236);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1+등급), 사태(앞사태), 생것', 152);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1+등급), 살코기, 생것', 223);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1+등급), 설도(도가니살), 생것', 168);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1+등급), 설도(보섭살), 생것', 176);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1+등급), 설도(삼각살), 생것', 207);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1+등급), 설도(설깃머리살), 생것', 207);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1+등급), 설도(설깃살), 생것', 188);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1+등급), 안심(안심살), 생것', 206);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1+등급), 앞다리(갈비덧살), 생것', 210);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1+등급), 앞다리(꾸리살), 생것', 185);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1+등급), 앞다리(부채덮개살), 생것', 159);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1+등급), 앞다리(부채살), 생것', 244);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1+등급), 앞다리(앞다리살), 생것', 185);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1+등급), 양지(앞치마살), 생것', 289);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1+등급), 양지(양지머리), 생것', 194);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1+등급), 양지(업진살), 생것', 325);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1+등급), 양지(업진안살), 생것', 297);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1+등급), 양지(차돌박이), 생것', 467);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1+등급), 양지(치마살), 생것', 235);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1+등급), 양지(치마양지), 생것', 212);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1+등급), 우둔(우둔살), 생것', 163);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1+등급), 우둔(홍두깨살), 생것', 158);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기, 한우(1+등급), 채끝(채끝살), 생것', 305);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소, 부산물, 간, 생것', 131);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소, 부산물, 골, 생것', 120);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소, 부산물, 꼬리, 생것', 246);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소, 부산물, 선지(피), 생것', 52);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소, 부산물, 소장(곱창), 생것', 141);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소, 부산물, 신장, 생것', 90);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소, 부산물, 심장, 생것', 105);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소, 부산물, 양(위), 생것', 61);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소, 부산물, 천엽, 생것', 51);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소, 부산물, 허파, 생것', 82);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소, 부산물, 혀, 생것', 186);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소, 부산물, 미국산, 간, 삶은것', 191);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소, 부산물, 미국산, 골, 끓인것', 151);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소, 부산물, 미국산, 신장, 끓인것', 157);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소, 부산물, 미국산, 심장, 끓인것', 165);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소, 부산물, 미국산, 허파, 삶은것', 120);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소, 부산물, 미국산, 혀, 끓인것', 284);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소, 부산물, 외국산, 대장, 생것', 162);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소불고기, 생것', 136);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('양지국물', 4);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('우족국물, 중량3배물', 2);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('육포', 361);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('잡뼈국물', 27);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('송아지고기, 미국산, 갈비, 생것', 162);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('송아지고기, 미국산, 갈비, 삶은것', 251);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('송아지고기, 미국산, 갈비, 구운것', 228);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('송아지고기, 미국산, 등심, 생것', 177);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('송아지고기, 미국산, 등심, 삶은것', 284);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('송아지고기, 미국산, 등심, 구운것', 217);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('송아지고기, 미국산, 살코기, 생것', 105);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('송아지고기, 미국산, 살코기, 삶은것', 201);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('송아지고기, 미국산, 어깨, 생것', 132);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('송아지고기, 미국산, 어깨, 삶은것', 236);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('송아지고기, 미국산, 어깨, 구운것', 183);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('송아지고기, 미국산, 채끝(채끝살), 생것', 152);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('송아지고기, 미국산, 채끝(채끝살), 삶은것', 252);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('송아지고기, 미국산, 채끝(채끝살), 구운것(오븐)', 202);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('송아지, 부산물, 미국산, 간, 생것', 140);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('송아지, 부산물, 미국산, 간, 삶은것', 192);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('송아지, 부산물, 미국산, 골, 생것', 118);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('송아지, 부산물, 미국산, 골, 삶은것', 136);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('송아지, 부산물, 미국산, 신장, 생것', 99);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('송아지, 부산물, 미국산, 신장, 삶은것', 163);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('송아지, 부산물, 미국산, 심장, 생것', 110);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('송아지, 부산물, 미국산, 심장, 삶은것', 186);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('송아지, 부산물, 미국산, 허파, 생것', 90);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('송아지, 부산물, 미국산, 허파, 삶은것', 104);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('송아지, 부산물, 미국산, 혀, 생것', 131);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('송아지, 부산물, 미국산, 혀, 삶은것', 202);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('양고기, 외국산, 다리, 생것', 224);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('어린양고기, 미국산, 갈비, 생것', 372);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('어린양고기, 미국산, 갈비, 구운것(오븐)', 359);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('어린양고기, 미국산, 다리, 생것', 201);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('어린양고기, 미국산, 다리, 구운것(오븐)', 225);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('어린양고기, 미국산, 살코기, 생것', 143);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('어린양고기, 미국산, 어깨, 생것', 264);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('어린양고기, 미국산, 어깨, 삶은것', 344);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('어린양고기, 미국산, 어깨, 구운것(오븐)', 276);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('어린양, 부산물, 미국산, 간, 생것', 139);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('어린양, 부산물, 미국산, 간, 삶은것', 220);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('염소고기, 생것', 178);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('염소고기, 삶은것', 247);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('염소고기, 외국산, 생것', 107);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('오리고기, 껍질, 포함, 생것', 242);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('오리고기, 살코기, 생것', 117);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('오리고기, 산오리, 생것', 257);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('오리고기, 집오리, 생것', 318);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('오리고기, 집오리, 살코기, 생것', 149);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('자라고기, 외국산, 생것', 197);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('칠면조고기, 미국산, 생것', 143);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('칠면조고기, 미국산, 끓인것', 203);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('칠면조고기, 미국산, 구운것', 189);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('토끼고기, 집토끼, 생것', 135);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('토끼고기, 집토끼, 끓인것', 173);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('말고기, 생것', 110);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('거위알, 생것', 193);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('거위알, 삶은것', 187);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('기러기알, 생것', 193);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('기러기알, 삶은것', 212);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('달걀, 생것', 136);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('달걀, 가루 ', 376);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('달걀, 삶은것', 143);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('달걀, 난백, 생것', 51);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('달걀, 난백, 삶은것', 48);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('달걀, 난황, 생것', 318);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('달걀, 난황, 삶은것', 362);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('달걀, 유정란, 생것', 156);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('달걀, 유정란, 난백, 생것', 50);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('달걀, 유정란, 난황, 생것', 333);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('달걀부침, 부친것', 206);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('수란, 중탕', 164);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('스크램블에그, 볶은것', 149);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('메추리알, 생것', 157);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('메추리알, 삶은것', 156);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('오리알, 생것', 193);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('피단, 오리알', 175);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('청둥오리알, 생것', 178);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('가다랑어, 생것', 128);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('가다랑어, 유지통조림', 168);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('가다랑어, 육수', 0);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('가라지, 생것', 78);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('가물치, 생것', 86);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('가시망독, 생것', 102);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('가오리, 조미하여, 말린것', 312);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('가오리, 나비가오리, 생것', 80);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('가오리, 노랑가오리, 생것', 98);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('가오리, 목탁가오리, 생것', 99);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('가오리, 전기가오리, 생것', 65);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('가자미, 생것', 129);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('가자미, 각시가자미, 생것', 84);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('가자미, 갈가자미, 생것', 91);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('가자미, 기름가자미, 생것', 84);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('가자미, 눈가자미, 생것', 94);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('가자미, 돌가자미, 생것', 91);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('가자미, 문치가자미, 생것', 93);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('가자미, 범가자미, 생것', 83);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('가자미, 술봉가자미, 생것', 84);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('가자미, 용가자미, 생것', 83);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('가자미, 줄가자미, 생것', 77);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('가자미, 참가자미, 생것', 86);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('갈치, 생것', 147);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('갈치, 염장', 186);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('갈치, 동갈치, 생것', 98);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('갈치, 동동갈치, 생것', 121);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('갈치젓, 염절임', 179);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('강달이, 눈강달이, 생것', 108);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('강달이젓, 눈강달이젓, 염절임', 106);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('게르치, 생것', 156);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('게르치, 삶은것', 173);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고등어, 생것', 180);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고등어, 반건조', 348);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고등어, 삶은것', 309);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고등어, 구운것', 318);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고등어, 통조림', 159);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고등어, 자반고등어, 염장', 251);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고등어, 남해, 생것', 210);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고등어, 서해, 생것', 278);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('괴도라치, 생것', 74);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('군평선이, 생것', 103);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('기름종개, 생것', 106);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('까나리, 생것', 113);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('까나리, 삶아서, 말린것', 245);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('꺽저기, 생것', 93);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('꼬치고기, 생것', 97);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('꼼치, 생것', 71);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('꽁치, 생것', 141);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('꽁치, 말린것', 175);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('꽁치, 구운것', 270);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('꽁치, 염장', 175);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('꽁치, 조미통조림', 183);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('날치, 생것', 100);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('날치, 염장', 124);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('날치, 부산물, 알, 생것', 96);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('납지리, 생것', 86);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('넙치(광어), 생것', 125);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('넙치(광어), 부산물, 껍질, 생것', 168);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('네동가리, 생것', 83);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('노랑촉수, 생것', 238);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('노래미, 생것', 90);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('노래미, 줄노래미, 생것', 86);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('노래미, 쥐노래미, 생것', 119);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('놀래기, 생것', 107);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('놀래기, 사랑놀래기, 생것', 104);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('놀래기, 용치놀래기, 생것', 86);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('놀래기, 황놀래기, 생것', 98);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('농어, 생것', 96);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('농어, 구운것', 124);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('농어, 점농어, 생것', 127);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('누치, 생것', 104);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('눈볼대, 생것', 143);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('눈퉁멸, 생것', 136);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('눈퉁멸, 포, 말린것', 342);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('능성어, 생것', 93);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('다금바리, 생것', 100);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('다랑어, 참다랑어, 생것', 175);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('다랑어, 참다랑어, 냉동', 114);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('다랑어, 참다랑어, 구운것', 184);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('다랑어, 참다랑어, 유지통조림', 191);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('다랑어, 참다랑어, 붉은살, 생것', 125);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('다랑어, 참다랑어, 지방육, 생것', 344);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('다랑어, 황다랑어, 생것', 115);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('참다랑어, 샐러드', 187);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('달강어, 생것', 121);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('달고기, 생것', 97);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('대구, 생것', 87);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('대구, 말린것', 258);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('대구, 냉동', 82);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('대구, 구운것', 109);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('대구, 소금에, 절여, 반건조', 202);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('대구, 염장', 92);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('대구, 수컷, 생것', 82);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('대구, 암컷, 생것', 69);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('대구, 포, 말린것', 313);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('대구, 빨간대구, 생것', 95);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('대구, 은대구, 생것', 127);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('대구, 부산물, 내장, 생것', 85);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('대구, 부산물, 알, 생것', 115);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('대구, 튀김, 냉동', 109);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('대구젓, 염절임', 66);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('대구젓, 아가미젓, 염절임', 76);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('대구횟대, 생것', 93);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('대두어(흑연), 생것', 96);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('도다리, 생것', 79);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('도도바리, 생것', 96);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('도루묵, 생것', 112);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('도루묵, 소금에, 절여, 말린것', 280);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('도치, 생것', 61);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('독가시치, 생것', 98);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돔, 각시돔, 생것', 91);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돔, 감성돔, 생것', 101);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돔, 강담돔, 생것', 93);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돔, 구갈돔, 생것', 90);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돔, 금눈돔, 생것', 121);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돔, 꼽새돔, 생것', 102);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돔, 도화돔, 생것', 130);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돔, 독돔, 생것', 98);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돔, 돌돔, 생것', 87);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돔, 백미돔, 생것', 102);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돔, 범돔, 생것', 95);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돔, 벵에돔, 생것', 99);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돔, 뿔돔, 생것', 97);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돔, 샛돔, 생것', 120);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돔, 실꼬리돔, 생것', 107);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돔, 실붉돔, 생것', 100);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돔, 어름돔, 생것', 94);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돔, 옥돔, 생것', 83);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돔, 옥돔, 반건조', 104);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돔, 옥돔, 삶은것', 125);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돔, 옥돔, 구운것', 119);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돔, 육동가리돔, 생것', 103);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돔, 자리돔, 생것', 88);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돔, 참돔, 생것', 83);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돔, 참돔, 삶은것', 206);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돔, 참돔, 구운것', 210);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돔, 호박돔, 생것', 91);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돔, 혹돔, 생것', 96);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돔, 황돔, 생것', 103);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돔, 황줄돔, 생것', 97);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돔, 부산물, 껍질, 생것', 184);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('동사리, 생것', 81);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('동자개(빠가사리), 생것', 146);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('둑중개, 생것', 103);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('둑중개, 삶은것', 122);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('둑중개, 조린것', 302);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('드렁허리, 생것', 92);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('등가시치, 생것', 80);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('만새기, 생것', 108);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('망둥어(풀망둑), 생것', 78);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('매퉁이, 생것', 94);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('메기, 생것', 113);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('메기, 물메기, 생것', 79);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('메기, 붉은메기, 생것', 84);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멸치, 생것', 125);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멸치, 유지통조림', 173);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멸치, 대멸치, 삶아서, 말린것', 302);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멸치, 중멸치, 삶아서, 말린것', 246);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멸치, 잔멸치, 삶아서, 말린것', 226);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멸치, 볶음, 멸치풋고추볶음', 266);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멸치, 볶음, 잔멸치볶음', 347);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멸치, 육수', 0);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멸치젓, 염절임', 164);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멸치젓, 액젓, 염절임', 29);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('명태, 생것', 81);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('명태, 구운것', 111);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('명태, 북어, 말린것', 291);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('명태, 노가리, 말린것', 357);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('명태, 황태, 말린것', 377);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('명태, 황태포, 말린것', 352);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('명태, 코다리, 반건조', 108);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('명태, 코다리, 반건조, 구운것', 112);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('명태, 동태, 냉동', 73);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('명태, 조미포, 조미하여, 말린것', 314);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('명태, 포, 말린것', 375);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('명태, 부산물, 알, 생것', 125);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('명태젓, 명란젓, 염절임', 125);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('명태젓, 창난젓, 염절임', 116);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('모래무지, 생것', 77);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('몽치다래, 생것', 158);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('문절망둑, 생것', 91);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('문절망둑, 장조림', 252);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('물치다래, 생것', 166);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('미꾸라지, 생것', 95);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('미꾸라지, 삶은것', 83);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('민달고기, 생것', 96);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('민어, 생것', 86);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('민어, 구운것', 106);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('민어, 튀긴것(튀김옷)', 221);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('민어, 암치, 조미하여, 말린것', 320);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('민어, 부산물, 알, 염장', 293);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('민태, 생것', 87);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('박대, 생것', 91);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('박대, 말린것', 133);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('박대, 반건조', 104);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('방어, 생것', 87);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('방어, 구운것', 304);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('방어, 훈제통조림', 320);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('방어, 양식, 어린것, 생것', 251);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('방어, 자연산, 어린것, 생것', 163);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('백연, 생것', 90);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('밴댕이, 생것', 219);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('밴댕이, 삶아서, 말린것', 301);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('밴댕이젓, 염절임', 114);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('뱅어, 생것', 68);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('뱅어, 말린것', 311);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('뱅어, 포, 말린것', 362);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('베도라치, 생것', 106);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('베도라치, 그물베도라치, 생것', 107);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('베도라치, 장어베도라치, 생것', 134);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('베로치, 생것', 87);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('베스, 생것', 82);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('벤자리, 생것', 122);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('벤자리, 노랑벤자리, 생것', 94);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('병어, 생것', 128);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('보구치, 생것', 119);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('보리멸, 생것', 93);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('보리멸, 냉동', 98);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('복어, 검복, 생것', 95);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('복어, 검복, 조미하여, 말린것', 293);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('복어, 국매리복, 생것', 92);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('복어, 까치복, 생것', 86);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('복어, 까칠복, 생것', 86);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('복어, 매리복, 생것', 89);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('복어, 밀복, 생것', 81);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('복어, 자주복, 생것', 84);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('복어, 졸복, 생것', 84);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('복어, 흰점복, 생것', 72);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('볼락, 생것', 94);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('볼락, 구운것', 109);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('볼락, 개볼락, 생것', 88);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('볼락, 누루시볼락, 생것', 148);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('볼락, 불볼락, 생것', 124);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('볼락, 우럭볼락, 생것', 88);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('볼락, 조피볼락(우럭), 생것', 99);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('볼락, 탁자볼락, 생것', 86);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('볼락, 황점볼락, 생것', 103);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('부세, 생것', 104);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('부시리, 생것', 109);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('부치, 빨강부치, 생것', 72);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('붉바리, 생것', 100);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('붕어, 생것', 94);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('붕어, 삶은것', 217);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('붕어, 구운것', 172);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('붕어, 참붕어, 생것', 116);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('블루길, 생것', 84);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('빙어, 생것', 86);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('빙어, 삶아서, 말린것', 188);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('빙어, 장조림', 265);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('빙어, 바다빙어, 생것', 92);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('빙어, 바다빙어, 구운것(오븐)', 124);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('산천어, 생것', 117);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('살살치, 생것', 70);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('삼세기, 생것', 98);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('삼치, 생것', 112);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('삼치, 구운것', 202);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('삼치, 줄삼치, 생것', 134);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('삼치, 평삼치, 생것', 120);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('삼치젓, 염절임', 107);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('상어, 가래상어, 생것', 100);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('상어, 곱상어, 생것', 161);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('상어, 까치상어, 생것', 113);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('상어, 돔발상어, 생것', 293);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('상어, 두툽상어, 생것', 95);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('상어, 망상어, 생것', 90);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('상어, 모조리상어, 생것', 108);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('상어, 별상어, 생것', 104);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('상어, 악상어, 생것', 276);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('상어, 은상어, 생것', 102);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('상어, 청새리상어, 생것', 101);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('상어, 흉상어, 생것', 113);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('상어, 지느러미, 생것', 345);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('상어, 부산물, 알, 생것', 321);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('새다래, 생것', 104);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('샛멸, 생것', 88);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('서대, 각시서대, 생것', 96);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('서대, 궁제기서대, 생것', 92);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('서대, 참서대, 생것', 85);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('성대, 생것', 95);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('성대, 별성대, 생것', 91);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('성대, 별쭉지성대, 생것', 128);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('송어, 생것', 121);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('송어, 염장', 233);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('송어, 통조림', 157);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('송어, 무지개송어, 생것', 126);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('송어, 무지개송어, 냉동', 159);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('송어, 무지개송어, 구운것', 150);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('송어젓, 염절임', 163);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('숭어, 생것', 108);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('숭어, 구운것', 150);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('숭어, 부산물, 알, 소금에, 절여, 말린것', 423);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('쌍동가리, 생것', 101);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('쌍뿔달재, 생것', 76);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('쏘가리, 생것', 110);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('쏘가리, 냉동', 124);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('쏨뱅이, 생것', 91);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('쑤기미, 생것', 85);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('쑥감펭, 생것', 84);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('아귀, 생것', 64);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('아귀, 황아귀, 생것', 72);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('아귀, 부산물, 간, 생것', 416);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('아홉동가리, 생것', 106);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('애꼬치, 생것', 148);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('애꼬치, 구운것', 145);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('양미리, 생것', 122);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('양미리, 말린것', 209);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('양태, 생것', 88);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('양태, 꽁지양태, 생것', 78);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('양태, 눈양태, 생것', 91);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('양태, 도화양태, 생것', 78);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('양태, 돛양태, 생것', 82);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('얼룩통구멍, 생것', 82);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('여덟동가리, 생것', 110);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('연어, 생것', 106);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('연어, 훈제', 169);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('연어, 염장', 146);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('연어, 통조림', 135);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('연어, 소금첨가, 생것', 154);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('연어, 소금첨가, 구운것', 198);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('연어, 은연어, 생것', 106);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('연어, 홍연어, 생것', 138);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('연어, 홍연어, 구운것', 177);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('연어, 홍연어, 훈제', 161);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('연어, 부산물, 알, 생것', 245);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('연어, 부산물, 알, 염장', 252);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('열쌍동가리, 생것', 87);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('우각바리, 생것', 92);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('볼기우럭, 생것', 128);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('웅어, 생것', 165);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('은어, 생것', 113);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('은어, 구운것', 177);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('은어, 양식, 생것', 152);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('은어, 양식, 구운것', 241);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('은어, 부산물, 내장, 생것', 206);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('은어, 부산물, 내장, 구운것', 194);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('은어, 부산물, 양식, 내장, 생것', 550);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('은어, 부산물, 양식, 내장, 구운것', 558);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('은어젓, 내장젓, 염절임', 128);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('인상어, 생것', 133);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('임연수어, 생것', 150);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('임연수어, 반건조', 176);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('임연수어, 염장', 194);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('잉어, 생것', 112);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('잉어, 삶은것', 208);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('잉어, 부산물, 내장, 생것', 287);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('장갱이, 생것', 91);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('장문볼락, 생것', 87);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('장문볼락, 구운것', 96);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('장어, 양념, 구운것', 294);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('장어, 갯장어, 생것', 167);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('장어, 먹장어, 생것', 128);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('장어, 뱀장어, 생것', 217);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('장어, 뱀장어, 구운것', 236);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('장어, 뱀장어, 조미, 구운것', 258);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('장어, 붕장어, 생것', 133);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('장어, 붕장어, 냉동', 155);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('장어, 칠성장어, 생것', 253);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('장어, 칠성장어, 말린것', 406);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('장어, 부산물, 뱀장어, 간, 생것', 195);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('장어, 부산물, 붕장어, 뼈, 튀긴것', 556);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('전갱이, 생것', 132);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('전갱이, 냉동', 118);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('전갱이, 삶은것', 151);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('전갱이, 구운것', 170);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('전갱이, 소금에, 절여, 말린것', 261);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('전갱이, 조미반건조 ', 168);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('전갱이, 조미반건조, 구운것', 220);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('전갱이, 조미통조림', 133);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('전갱이, 어린것, 생것', 100);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('전갱이, 갈전갱이, 생것', 111);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('전갱이, 줄전갱이, 생것', 113);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('전갱이, 튀김, 냉동', 147);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('전어, 생것', 107);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('전어젓, 염절임', 128);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('점감펭, 생것', 90);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('점줄우럭, 생것', 100);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('점줄우럭, 구운것(오븐)', 118);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('정어리, 생것', 168);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('정어리, 말린것', 331);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('정어리, 삶아서, 말린것', 113);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('정어리, 삶은것', 178);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('정어리, 구운것', 196);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('정어리, 소금에, 절여, 말린것', 187);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('정어리, 염장', 152);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('정어리, 통조림', 127);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('정어리, 유지통조림', 274);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('정어리, 조미통조림', 125);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('조기(참조기), 생것', 118);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('조기(참조기), 굴비, 소금에, 절여, 말린것', 328);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('조기(참조기)젓, 염절임', 81);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('준치, 생것', 128);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('준치, 강준치, 생것', 91);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('쥐치, 생것', 84);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('쥐치, 포, 말린것', 332);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('쥐치, 포, 냉동', 114);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('쥐치, 포, 조미하여, 말린것', 314);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('쥐치, 말쥐치, 생것', 143);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('쥐치, 말쥐치, 조미하여, 말린것', 318);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('참마자, 생것', 90);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('청새치, 생것', 115);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('청어, 생것', 207);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('청어, 말린것', 410);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('청어, 삶아서, 말린것', 122);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('청어, 훈제', 305);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('청어, 염장', 157);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('청어, 부산물, 알, 생것', 107);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('청어, 부산물, 알, 말린것', 385);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('청어, 부산물, 알, 염장', 89);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('초어, 생것', 89);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('통치, 생것', 137);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('투라치, 생것', 80);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('틸라피아, 생것', 126);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('푸렁통구멍, 생것', 77);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('풀반지, 생것', 164);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('피라미, 생것', 105);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('학공치, 생것', 94);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('학공치, 조미하여, 말린것', 339);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('향어, 생것', 174);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('홍감펭, 생것', 107);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('홍어, 생것', 88);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('홍치, 생것', 94);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('황매퉁이, 생것', 98);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('황새치, 생것', 82);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('황새치, 구운것', 172);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('황새치젓, 염절임', 121);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('황어, 생것', 95);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('횟대, 빨간횟대, 생것', 75);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('히메치, 생것', 99);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('가리비, 생것', 80);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('가리비, 말린것', 352);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('가리비, 삶은것', 100);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('가리비, 튀긴것', 216);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('가리비, 통조림', 112);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('가리비, 관자, 생것', 105);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('가리비, 관자, 삶아서, 말린것', 322);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('가리비, 관자, 냉동', 105);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('가리비, 국자가리비, 생것', 59);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('가리비, 비단가리비, 생것', 76);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('가리비, 큰가리비, 생것', 60);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('각시수랑, 생것', 70);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고둥, 갈색고리돼지고둥, 생것', 92);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고둥, 갈색띠매물고둥, 생것', 78);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고둥, 관절매물고둥(보라골뱅이), 생것', 103);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고둥, 긴고둥(긴뿔고둥), 생것', 116);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고둥, 나팔고둥, 생것', 110);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고둥, 두드럭고둥, 생것', 88);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고둥, 매끈이고둥, 생것', 109);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고둥, 물레고둥, 생것', 88);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고둥, 민허리돼지고둥, 생것', 104);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고둥, 보말고둥, 생것', 92);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고둥, 보말고둥, 삶은것', 105);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고둥, 비단고둥, 생것', 94);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고둥, 세고리물레고둥, 생것', 74);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고둥, 위고둥, 생것', 66);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고둥, 조각매물고둥, 생것', 125);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고둥, 콩깍지고둥, 생것', 100);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고둥, 털탑고둥, 생것', 143);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고둥, 피뿔고둥, 생것', 109);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('굴, 냉동', 95);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('굴, 튀긴것(튀김옷)', 199);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('굴, 통조림', 87);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('굴, 훈제통조림', 301);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('굴, 석굴, 생것', 63);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('굴, 참굴, 생것', 81);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('굴, 참굴(양식), 생것', 86);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('굴, 토굴, 생것', 80);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('굴젓, 어리굴젓, 염절임', 92);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('꼬막, 생것', 63);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('꼬막, 새꼬막, 생것', 74);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('다슬기, 생것', 77);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('다슬기, 곳체다슬기, 생것', 77);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('다슬기, 띠구슬다슬기, 생것', 116);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('다슬기, 염주알다슬기, 생것', 110);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('다슬기, 좀주름다슬기, 생것', 88);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('다슬기, 참다슬기, 생것', 75);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('다슬기, 주름다슬기, 생것', 97);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('담치, 지중해담치, 생것', 54);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('담치, 진주담치, 생것', 74);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('담치, 진주담치, 구운것', 172);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('담치, 진주담치(양식), 생것', 83);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('대수리, 생것', 111);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('대합, 북방대합, 생것', 62);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('동죽, 생것', 68);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('맛, 붉은맛(큰죽합), 생것', 95);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('바지락, 생것', 73);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('바지락, 말린것', 349);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('바지락, 장조림', 237);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('바지락, 통조림', 95);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('바지락, 조미통조림', 110);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('바지락, 양식, 생것', 68);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('바지락젓, 염절임', 51);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('백합, 생것', 73);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('백합, 삶은것', 89);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('백합, 구운것', 77);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('백합, 조미통조림', 127);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('백합, 말백합, 생것', 57);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소라, 생것', 107);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소라, 통조림', 127);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('수랑, 생것', 85);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('오분자기, 생것', 94);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('우렁이, 논우렁이, 생것', 72);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('우렁이, 왕우렁, 생것', 65);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('우렁이, 큰구슬우렁이(골뱅이), 생것', 70);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('우렁이, 큰구슬우렁이(골뱅이), 통조림', 86);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('우렁이, 큰논우렁이, 생것', 76);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('큰우슬우렁이(골뱅이), 무침', 109);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('재첩, 생것', 93);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('전복, 말린것', 256);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('전복, 튀긴것', 189);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('전복, 통조림, 삶은것', 100);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('전복, 조미통조림', 133);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('전복, 까막전복, 생것', 85);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('전복, 말전복, 생것', 77);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('전복, 참전복, 생것', 90);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('전복, 부산물, 내장, 생것', 148);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('전복젓, 염절임', 99);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('조개, 가무락조개, 생것', 76);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('조개, 개량조개, 생것', 62);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('조개, 개량조개, 말린것', 277);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('조개, 개조개, 생것', 64);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('조개, 떡조개, 생것', 85);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('조개, 맛조개, 생것', 55);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('조개, 맛조개, 말린것', 346);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('조개, 살조개, 생것', 88);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('조개, 새조개, 생것', 114);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('조개, 새조개, 말린것', 295);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('조개, 새조개, 조미하여, 말린것', 315);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('조개, 왕우럭조개, 생것', 100);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('조개, 우럭, 생것', 98);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('조개, 접시조개, 생것', 68);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('조개, 진주조개, 생것', 56);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('조개, 키조개, 생것', 57);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('조개, 키조개, 패주, 생것', 70);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('조개, 키조개, 근육, 생것', 92);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('조개, 펄조개, 생것', 72);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('조개, 피조개, 생것', 65);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('조개, 피조개, 조미통조림', 119);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('조개, 피조개(양식), 생것', 82);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('홍합, 생것', 82);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('홍합, 삶아서, 말린것', 386);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('홍합, 통조림', 93);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('가재, 갯가재, 생것', 87);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('가재, 갯가재, 삶은것', 93);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('가재, 바닷가재, 생것', 124);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('가재, 바닷가재, 찐것', 82);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('개불, 생것', 53);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('게, 꽃게, 생것', 77);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('게, 꽃게, 찐것', 83);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('게, 닭게, 생것', 70);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('게, 닭게, 삶은것', 74);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('게, 대게, 생것', 85);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('게, 대게, 삶아서, 말린것', 316);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('게, 대게, 삶은것', 69);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('게, 대게, 통조림', 73);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('게, 대게, 영덕, 생것', 60);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('게, 민꽃게, 생것', 85);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('게, 반게, 생것', 70);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('게, 방게, 생것', 66);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('게, 왕게, 생것', 67);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('게, 왕게, 삶은것', 80);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('게, 주름송편게, 생것', 87);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('게, 참게, 생것', 171);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('대게, 붉은대게, 생것', 49);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('게맛살', 118);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('게젓, 닭게젓, 염절임', 61);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('군소, 생것', 36);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('군소, 풍선군소, 생것', 43);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('꼴뚜기, 생것', 78);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('꼴뚜기, 삶아서, 말린것', 285);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('꼴뚜기, 불똥꼴뚜기, 생것', 91);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('꼴뚜기, 불똥꼴뚜기, 삶은것', 104);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('꼴뚜기, 불똥꼴뚜기, 조린것', 260);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('꼴뚜기, 불똥꼴뚜기, 조미훈제', 325);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('꼴뚜기, 창꼴뚜기, 생것', 70);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('꼴뚜기젓, 염절임', 88);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('꼴뚜기젓, 양념, 염절임', 115);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('낙지, 생것', 59);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('낙지, 세발낙지, 생것', 55);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멍게, 생것', 79);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멍게, 끈멍게, 생것', 64);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멍게, 붉은멍게, 생것', 77);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멍게, 양식, 생것', 75);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('문어, 생것', 74);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('문어, 말린것', 349);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('문어, 삶은것', 99);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('문어, 대문어, 생것', 59);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('문어, 참문어, 생것', 56);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('미더덕, 생것', 45);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('미더덕, 주름미더덕, 생것', 54);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('새우, 가시발새우, 생것', 72);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('새우, 각시흰새우, 생것', 85);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('새우, 긴뿔천길새우, 생것', 93);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('새우, 꽃새우, 생것', 114);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('새우, 꽃새우, 삶아서, 말린것', 306);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('새우, 꽃새우, 냉동', 114);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('새우, 꽃새우, 찐것', 119);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('새우, 꽃새우, 튀긴것(튀김옷)', 242);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('새우, 꽃새우, 장조림', 234);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('새우, 닭새우, 생것', 88);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('새우, 대하, 생것', 83);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('새우, 대하, 말린것', 358);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('새우, 물렁가시붉은새우, 생것', 84);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('새우, 보리새우, 생것', 71);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('새우, 보리새우, 삶은것', 124);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('새우, 부채새우, 생것', 66);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('새우, 시바새우, 생것', 94);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('새우, 시바새우, 삶아서, 말린것', 299);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('새우, 시바새우, 조미하여, 말린것', 320);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('새우, 시바새우, 통조림', 100);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('새우, 젓새우, 생것', 62);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('새우, 젓새우, 조린것', 233);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('새우, 징거미새우, 생것', 91);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('새우, 철모새우, 생것', 91);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('새우, 펄닭새우, 생것', 62);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('새우, 흰다리새우, 생것', 98);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('새우, 볶음, 말린것, 볶은것', 331);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('새우, 부산물, 껍질, 생것', 319);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('새우, 튀김용, 냉동', 139);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('새우, 튀김용, 튀긴것', 263);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('새우젓, 대때기젓, 토굴, 염절임', 55);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('새우젓, 동백하젓, 토굴, 염절임', 51);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('새우젓, 시바새우젓, 염절임', 92);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('새우젓, 염절임', 131);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('새우젓, 육젓, 토굴, 염절임', 59);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('새우젓, 젓새우젓, 염절임', 55);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('새우젓, 추젓, 염절임', 49);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('새우젓, 추젓, 토굴, 염절임', 48);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('새우젓, 오젓, 토굴, 염절임', 59);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('성게, 생것', 152);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('성게, 통조림', 140);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('성게, 보라성게, 생것', 177);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('성게, 부산물, 보라성게, 알', 177);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('성게젓, 염절임', 134);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('성게젓, 보라성게알젓, 염절임', 147);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('성게젓, 알젓, 염절임', 105);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('오징어, 생것', 94);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('오징어, 말린것', 353);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('오징어, 냉동', 88);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('오징어, 구운것', 109);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('오징어, 튀긴것', 175);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('오징어, 조미, 구운것', 308);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('오징어, 조미훈제', 213);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('오징어, 포, 조미하여, 말린것', 297);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('오징어, 갑오징어, 생것', 76);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('오징어, 갑오징어, 말린것', 340);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('오징어, 살오징어, 생것', 72);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('오징어, 쇠갑오징어, 생것', 79);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('오징어, 참갑오징어, 생것', 76);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('오징어, 튀김, 튀긴것', 308);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('오징어젓, 염절임', 77);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('오징어젓, 양념, 염절임', 125);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('오징어젓, 내장젓, 염절임', 101);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('오징어채, 볶음, 볶은것', 278);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('주꾸미, 생것', 53);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('크릴, 생것', 76);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('크릴, 삶은것', 104);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('크릴, 페이스트', 128);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('한치, 생것', 81);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('해삼, 생것', 24);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('해삼, 말린것', 351);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('해삼, 염장', 35);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('해삼젓, 염절임', 33);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('해삼젓, 내장젓, 염절임', 45);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('해파리, 생것', 6);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('어묵, 찐어묵', 115);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('어묵, 구운것', 141);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('어묵, 튀긴것', 167);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('어묵, 게맛살, 첨가', 112);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('어묵, 국물', 3);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('어묵국', 43);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('어육소시지', 175);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('낙지젓, 염절임', 160);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('멍게젓, 염절임', 139);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('갈래곰보, 생것', 12);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('곰피, 말린것', 141);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('곰피, 가루 ', 129);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('김, 김밥용김, 말린것', 179);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('김, 돌김, 말린것', 165);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('김, 맛김, 조미, 구운것', 307);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('김, 조선김, 말린것', 163);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('김, 참김, 생것', 12);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('김, 참김, 말린것', 165);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('김, 참김, 구운것', 174);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('김, 초밥김, 말린것', 151);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('꼬시래기, 생것', 17);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('다시마, 생것', 12);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('다시마, 말린것', 110);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('다시마, 염장', 16);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('다시마, 육수', 1);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('다시마튀각, 튀긴것', 228);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('대황, 말린것', 145);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('뜸부기, 말린것', 128);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('매생이, 생것', 39);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('매생이, 말린것', 125);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('모자반, 생것', 15);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('모자반, 말린것', 129);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('모자반, 가루 ', 127);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('모자반, 염장', 18);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('미역, 생것', 18);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('미역, 말린것', 149);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('미역, 가루 ', 134);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('미역, 염장', 34);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('미역, 염장, 데친것', 35);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('미역, 줄기, 생것', 14);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('미역, 줄기, 염장, 후, 탈염, 삶은것', 15);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('미역, 양식, 생것', 15);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('미역, 자연산, 생것', 12);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('미역튀각, 튀긴것', 283);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('불등풀가사리, 말린것', 147);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('비단풀, 말린것', 153);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('석묵, 말린것', 38);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('순채, 생것', 22);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('우뭇가사리, 생것', 46);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('우뭇가사리묵', 2);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('한천', 154);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('진두발, 말린것', 119);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('청각, 생것', 8);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('청각, 말린것', 156);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('청태, 말린것', 180);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('클로렐라, 말린것', 174);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('톳, 생것', 14);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('톳, 말린것', 81);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('톳, 삶아서, 말린것', 135);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('파래, 생것', 11);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('파래, 말린것', 144);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('파래, 가시파래, 말린것', 136);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('파래, 갈파래, 말린것', 129);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('파래, 납작파래, 생것', 17);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('파래, 창자파래, 말린것', 142);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('파래, 홑파래, 말린것', 146);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('모유', 65);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('분유, 1단계', 508);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('분유, 2단계', 506);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('분유, 3단계', 477);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('분유, 전지', 509);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('분유, 탈지', 358);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('산양유', 62);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('샤베트', 127);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('아이스밀크', 167);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('아이스크림, 딸기맛', 192);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('아이스크림, 바닐라맛', 179);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('아이스크림, 초콜릿맛', 216);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('아이스크림, 유지방, 8%', 180);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('아이스크림, 유지방, 12%', 212);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('아이스크림, 소프트, 아이스크림, 바닐라맛', 137);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('연유, 점성이, 높은것', 361);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('연유', 127);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('요구르트, 액상', 65);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('요구르트, 액상, 저당', 45);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('요구르트, 액상(농후), 딸기맛', 85);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('요구르트, 액상(농후), 플레인', 85);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('요구르트, 액상(농후), 식이섬유, 첨가', 97);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('요구르트, 액상(농후), 저지방, 식이섬유, 첨가', 74);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('요구르트, 액상(농후), 사과맛, 식이섬유, 첨가', 109);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('요구르트, 액상(농후), 플레인, 식이섬유, 첨가', 87);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('요구르트, 호상, 딸기맛', 95);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('요구르트, 호상, 플레인', 70);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('요구르트, 호상, 망고맛', 92);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('우유', 65);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('우유, 가공우유, 딸기맛', 68);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('우유, 가공우유, 초코맛', 71);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('우유, 가공우유, 커피맛', 61);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('우유, 가공우유, 바나나맛', 90);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('우유, 강화우유, 고칼슘', 63);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('우유, 저지방우유', 42);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('치즈, 모짜렐라', 294);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('치즈, 체다', 298);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('치즈, 카테지', 105);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('치즈, 크림', 350);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('치즈, 파마산', 420);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('치즈, 블루', 353);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('치즈, 브리', 334);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('치즈, 까망베르', 300);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('치즈, 고다', 356);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('치즈, 브릭', 371);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('치즈, 리코타', 162);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('커피크리머, 가루', 514);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('커피크리머, 액상, 식물성지방', 248);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('커피크리머, 액상, 유지방', 211);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('크림, 유지방, 45%', 433);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('크림, 유지방, 38%', 380);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('크림, 경휘핑', 292);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('크림, 중휘핑', 340);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('크림, 하프앤하프', 123);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('크림, 휘핑', 399);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고추기름', 919);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('닭기름', 900);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돼지기름', 941);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('들기름', 920);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('땅콩, 버터', 658);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('땅콩, 버터, 청크', 589);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('땅콩, 버터, 크림', 598);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('땅콩기름', 884);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('마가린', 714);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('면실유', 921);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('버터', 761);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('복숭아씨기름', 911);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('쇠기름', 940);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('쇼트닝', 941);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('쌀겨기름(미강유)', 921);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('아마씨유', 884);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('아몬드유', 884);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('아보카도유', 884);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('양기름', 902);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('연어기름', 902);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('옥수수기름', 919);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('올리브유', 921);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('유채씨기름', 920);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('잇꽃씨기름', 921);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('지방, 오리', 882);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('참기름', 917);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('코코넛유', 921);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('콩기름', 915);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('팜유', 921);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('포도씨유', 920);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('해바라기유', 921);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('호두유', 884);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('혼합식물성유', 921);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('감잎차, 가루 ', 335);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('결명자차, 말린것', 391);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('계피차, 가루 ', 357);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('구기자차, 말린것', 384);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('구절초차, 말린것', 345);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('국화차, 말린것', 358);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('녹차, 가루', 379);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('녹차, 인동녹차, 말린것', 329);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('녹차, 잎, 말린것', 388);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('녹차, 장군차, 말린것', 361);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('녹차, 추출', 2);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('녹차, 현미, 추출', 1);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('녹차, 현미, 티백', 377);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('다래나무순차, 추출', 1);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('대추차, 추출', 75);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('도라지차, 추출', 22);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('두충차, 가루 ', 354);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('둥글레차, 추출', 1);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('둥글레차, 티백', 372);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('민들레차', 0);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('보리차, 볶은것', 406);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('보리차, 추출', 0);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('보이차', 0);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('사과차, 추출', 167);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('상지차, 말린것', 360);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('생강차, 가루 ', 353);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('쌍화차, 가루 ', 360);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('쑥차, 말린것', 338);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('야콘차, 추출', 98);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('오미자차, 말린것', 371);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('우롱차, 추출', 0);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('우롱차, 캔', 0);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('유자차, 고형물, 포함, 용액', 72);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('유자차, 당절임', 246);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('율무차, 가루 ', 393);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('인삼차, 과립차, 가루 ', 381);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('치커리차, 말린것', 369);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('카모마일차, 추출', 1);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('커피, 무카페인, 가루 ', 351);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('커피, 원두, 볶은것', 431);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('커피, 원두, 추출', 4);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('커피, 에스프레소', 22);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('커피, 캔', 38);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('커피, 커피가루, 인스턴트', 348);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('커피, 커피가루, 물에, 탄것(커피가루, 1g)', 3);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('커피, 커피믹스, 가루', 426);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('커피, 커피믹스, 물에, 탄것(커피믹스, 12g)', 46);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('컴프리차, 가루 ', 347);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('코코아, 밀크코코아, 가루 ', 423);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('헛개차', 1);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('홍삼차, 가루 ', 382);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('홍차, 레몬, 추출', 33);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('홍차, 복숭아, 캔', 30);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('홍차, 추출', 2);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('홍차, 캔', 30);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('홍차, 티백', 311);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('과일채소, 음료', 39);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('과일채소, 음료, 녹즙, 케일, 신선초, 당근, 돌미나리', 28);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('기능성음료', 56);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('레모네이드', 38);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('매실, 음료', 55);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('쉐이크, 딸기맛', 113);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('쉐이크, 바닐라맛', 148);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('쉐이크, 초콜릿맛', 119);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('식혜, 캔', 32);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('쌀, 음료', 54);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('젖산음료, 복숭아맛', 36);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('이온, 음료, 레몬향', 37);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('탄산, 음료, 레몬소다', 44);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('탄산, 음료, 보리소다', 47);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('탄산, 음료, 사이다', 40);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('탄산, 음료, 소다수', 0);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('탄산, 음료, 오렌지소다', 48);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('탄산, 음료, 요구르트소다', 47);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('탄산, 음료, 저칼로리콜라', 2);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('탄산, 음료, 진저에일', 34);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('탄산, 음료, 콜라', 38);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('탄산, 음료, 크림소다', 51);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('탄산, 음료, 파인애플소다', 45);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('탄산, 음료, 포도소다', 52);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('토닉워터', 34);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고량주, 알코올, 50%', 355);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돌복숭아주', 35);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('드라이진', 284);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('럼', 240);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('막걸리, 알코올, 6%', 54);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('매실주', 156);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('맥주, 알코올, 4.50%', 46);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('맥주, 흑맥주, 알코올, 4.20%', 46);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('보드카, 알코올, 40%', 240);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('복분자주, 알코올, 15%', 137);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('브랜디, 알코올, 43%', 237);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('샴페인, 알코올, 6%', 45);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소주, 알코올, 17.80%', 127);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소주, 알코올, 25%', 178);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('오가피주, 알코올, 13%', 107);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('위스키, 알코올, 40%', 284);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('청주, 알코올, 16%', 132);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('칵테일, 다이키리', 125);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('칵테일, 테킬라썬라이즈', 110);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('칵테일, 위스키사우어, 알코올, 16.80%', 149);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('칵테일, 페퍼민트, 알코올, 20% ', 302);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('칵테일, 피냐콜라다, 알코올, 9.90%', 237);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('포도주, 백포도주, 알코올, 12%', 96);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('포도주, 적포도주, 알코올, 12%', 105);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('포도주, 적포도주, 알코올, 13%', 101);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('간장, 개량, 양조', 103);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('간장, 개량, 산분해', 54);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('간장, 재래', 83);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('겨자, 페이스트', 315);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('겨자, 페이스트, 연겨자, 겨자, 가루, 21%', 296);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('겨자, 가루', 413);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('계피, 가루', 343);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고기, 소스, 통조림', 101);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고기, 소스, 소불고기양념', 181);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고추냉이, 가루', 299);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고추냉이, 페이스트', 148);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고추장, 개량', 205);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고추장, 재래', 178);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고춧가루, 가루', 319);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('골든세이지, 말린것', 385);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('굴, 소스', 219);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('깨소금, 가루, 볶은것', 638);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('나토', 200);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('데리야끼, 소스', 89);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돈까스, 소스', 133);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('된장, 개량, 찌개용', 173);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('된장, 보리', 164);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('된장, 개량', 137);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('된장, 일식(미소)', 187);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('된장, 재래', 193);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('라면, 스프', 246);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('라벤다, 말린것', 330);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('레몬그라스(시트로넬라), 생것', 99);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('로즈마리, 말린것', 373);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('마늘, 페이스트', 171);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('마늘, 가루 ', 333);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('마요네즈, 난황', 702);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('마요네즈, 전란', 711);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('맛술', 146);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('민트, 말린것', 294);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('바비큐, 소스', 169);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('발사믹식초', 88);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('뽕잎, 가루 ', 275);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('사프란', 310);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('산초, 가루', 302);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('샐러드, 드레싱, 사우전드아일랜드', 484);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('샐러드, 드레싱, 이탈리안', 240);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('샐러드, 드레싱, 프렌치', 457);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('생강, 페이스트', 43);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('생강, 가루 ', 347);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소금', 0);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소금, 가공염, 죽염', 0);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소금, 가공염, 퉁퉁마디(함초)', 21);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소금, 굵은소금', 0);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소금, 정제염', 2);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소금, 천일염', 20);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소금, 천일염, 가는소금', 24);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소금, 천일염, 굵은소금', 15);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소금, 천일염, 소금꽃', 21);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소금, 천일염, 토판염', 16);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소금, 프랑스, 소금꽃', 11);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소금, 프랑스, 토판염', 16);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('스파게티, 소스, 병조림', 81);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('식초, 감식초', 14);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('식초, 배식초', 43);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('식초, 사과식초', 11);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('식초, 쌀식초', 46);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('식초, 알로에식초', 12);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('식초, 양조', 1);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('식초, 포도식초', 22);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('식초, 포도주', 19);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('식초, 현미식초', 19);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('쌈장', 240);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('양파, 가루 ', 364);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('오레가노, 말린것', 265);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('올스파이스, 가루 ', 374);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('우스터, 소스', 74);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('월계수, 잎, 말린것', 313);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('육두구', 559);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('정향, 가루 ', 417);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('조미료', 257);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('조미료, 멸치맛, 가루 ', 234);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('조미료, 쇠고기맛, 가루 ', 225);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('조미료, 액상', 77);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('조미소, 가루 ', 174);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('짜장, 소스', 189);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('짜장, 소스, 가루', 351);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('짜장, 소스, 레토르트', 93);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('청국장', 108);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('청국장, 가루 ', 411);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('청국장, 찌개용', 136);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('초고추장', 211);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('춘장', 206);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('칠리, 소스', 115);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('칠리, 가루 ', 374);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('카레, 가루 ', 356);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('카레, 레토르트', 72);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('코리아타임, 말린것', 378);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('타라곤, 말린것', 295);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('타임, 가루 ', 352);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('템페', 192);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('토마토, 소스', 44);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('토마토, 소스, 케첩', 135);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('파슬리, 말린것', 292);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('파프리카, 가루 ', 389);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('페퍼민트, 생것', 70);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('핫, 소스', 55);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('후추, 검은후추, 가루 ', 347);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('후추, 흰색후추, 가루 ', 378);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('간짜장', 127);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('갈비탕', 40);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('게살죽, 끓인것', 71);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고추잡채', 128);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('곰탕', 83);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('김밥', 158);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('김밥, 김치, 김밥', 138);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('김밥, 샐러드, 김밥', 162);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('김밥, 소고기, 김밥', 161);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('김밥, 참치, 김밥', 167);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('김치찌개', 61);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('깐풍기', 295);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('깨죽, 끓인것', 64);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('꼬리곰탕', 110);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('난자완스', 173);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('내장탕', 78);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('냉면, 물냉면', 69);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('냉면, 비빔냉면', 114);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('냉면, 열무냉면', 66);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('냉면, 회냉면', 114);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('덮밥, 불고기, 덮밥', 134);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('덮밥, 오징어, 덮밥', 136);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('덮밥, 제육, 덮밥', 156);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('덮밥, 참치, 덮밥', 135);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('덮밥, 회, 덮밥', 137);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('도가니탕', 72);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돈저냐(동그랑땡), 냉동', 225);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('동태찌개', 46);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('돼지고기, 볶음', 175);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('된장찌개', 37);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('떡만둣국', 89);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('떡볶이', 151);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('라면, 국물, 조리후', 19);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('라면, 면, 조리후', 174);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('라면, 조리전', 369);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('라면, 조리후', 101);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('라면, 비빔라면, 끓인것', 189);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('라조기', 199);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('마파두부', 114);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('막국수', 109);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('만두, 고기, 만두, 냉동', 208);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('만두, 군만두, 튀긴것', 274);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('만두, 김치, 만두, 냉동', 187);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('만두, 물만두', 131);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('만둣국', 62);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('메밀, 냉면, 육수, 인스턴트', 174);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('미역국, 인스턴트, 말린것', 323);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('미트볼, 냉동', 244);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('볶음밥, 김치, 볶음밥', 151);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('볶음밥, 새우, 볶음밥', 175);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('볶음밥, 오므라이스', 162);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('북어국, 인스턴트, 말린것', 360);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('비빔, 국수', 113);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('비빔밥', 141);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('사골국, 인스턴트', 10);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('삼각김밥, 고추장, 불고기', 166);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('삼각김밥, 숯불갈비', 161);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('삼각김밥, 참치, 마요네즈', 172);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('삼계탕', 92);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('샌드위치, 닭고기 ', 250);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('샌드위치, 생선 ', 257);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('샌드위치, 소고기 ', 244);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('샌드위치, 햄, 치즈 ', 218);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('샌드위치, 햄, 치즈, 채소', 214);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('선짓국', 42);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기버섯죽, 끓인것', 72);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소고기육개장', 49);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('소머리국밥', 79);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('순대국', 67);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('순두부찌개', 50);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('스튜, 레토르트', 118);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('스튜, 크림, 스튜, 레토르트', 119);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('스파게티, 미트소스, 스파게티, 냉동', 90);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('스프, 소고기, 스프, 가루 ', 406);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('스프, 소고기, 스프, 가루, 끓인것', 7);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('스프, 소고기, 채소, 스프, 가루, 끓인것', 48);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('스프, 양송이, 스프, 가루 ', 418);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('스프, 양송이, 스프, 가루, 끓인것', 39);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('스프, 양파, 스프, 가루 ', 293);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('스프, 양파, 스프, 가루, 끓인것', 12);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('스프, 콘소메, 스프, 가루, 끓인것', 11);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('스프, 크림, 스프, 가루 ', 443);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('스프, 크림, 스프, 가루, 끓인것', 30);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('알밥', 155);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('알탕', 61);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('양장피, 생것', 92);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('연잎밥', 207);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('옥수수죽, 레토르트', 86);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('우동, 일식, 우동, 끓인것', 60);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('우동, 중식, 우동, 끓인것', 65);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('육회', 153);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('잡채밥', 136);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('잡탕밥', 104);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('전복죽, 끓인것', 74);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('짜장면', 122);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('짜장면, 인스턴트, 끓인것', 177);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('짜장밥', 149);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('짬뽕', 69);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('쫄면', 133);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('청국장, 찌개', 68);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('초밥, 광어, 초밥', 151);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('초밥, 모듬, 초밥', 154);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('초밥, 유부초밥', 165);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('추어탕', 49);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('카레라이스', 134);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('칼국수, 해물', 70);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('컵라면, 국물, 조리후', 28);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('컵라면, 면, 조리후', 192);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('컵라면, 볶음라면, 조리전', 392);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('컵라면, 볶음라면, 조리후', 202);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('콩국수', 83);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('콩나물해장국', 32);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('크로켓, 감자, 크로켓, 냉동', 164);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('크로켓, 채소, 크로켓, 냉동', 264);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('크로켓, 크림, 크로켓, 냉동', 159);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('탕수육', 228);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('튀김, 김말이튀김', 251);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('튀김, 채소튀김', 321);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('팔보채', 81);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('팥죽, 끓인것', 83);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('팥죽, 레토르트', 117);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('피자, 슈퍼슈프림, 피자, 냉동', 233);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('피자, 치킨슈프림, 피자, 냉동', 250);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('핫도그, 냉동', 267);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('햄버거, 소고기패티', 271);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('햄버거, 스테이크, 냉동', 223);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('햄버거, 소고기패티, 토마토, 양상추, 양파', 229);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('호박죽, 끓인것', 74);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('갈색, 거저리, 유충, 말린것', 537);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('갈색, 거저리, 유충, 생것', 195);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('고로쇠나무, 수액', 5);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('누에, 가루 ', 391);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('단백질, 보충제, 가루', 411);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('단백질, 보충제, 저지방, 가루', 396);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('달팽이, 통조림', 82);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('달팽이, 생것', 90);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('대나무, 추출', 2);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('메뚜기, 말린것', 278);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('번데기, 통조림', 99);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('번데기, 말린것', 224);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('삼백초, 말린것', 301);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('삼백초, 잎, 말린것', 278);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('삼백초, 줄기, 말린것', 278);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('솔잎, 생것', 161);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('솔잎, 추출', 8);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('송화, 가루 ', 340);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('수세미, 수액', 4);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('인삼, 백삼, 말린것', 316);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('인삼, 수삼, 생것', 98);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('인삼, 홍삼, 말린것', 311);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('인삼, 홍삼, 추출', 15);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('치자꽃, 생것', 66);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('팽창제, 베이킹파우더', 51);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('팽창제, 효모, 말린것', 313);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('프로폴리스', 642);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('흰점박이, 꽃무지, 유충, 말린것', 463);
INSERT INTO diet_menu(diet_menu_name, calorie) VALUES('흰점박이, 꽃무지, 유충, 생것', 122);






















