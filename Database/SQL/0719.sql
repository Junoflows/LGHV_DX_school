-- 데이터베이스 사용 설정
use junoflow;

-- 테이블 생성
-- 테이블 이름은 contact
-- 속성
	-- num은 정수이고 일련번호, 기본키
	-- name은 한글 7자까지 저장하고 글자 수는 변경되지 않는다고 가정
	-- address는 한글 100자까지 저장하고 글자 수의 변경이 자주 발생
	-- tel은 숫자로 된 문자열 11자리이고 글자 수의 변경은 발생하지 않음
	-- email은 영문 100자 이내이고 글자 수의 변경이 자주 발생
	-- birthday는 날짜만 저장
	-- 주로 조회를 하고 일련번호는 1부터 시작하고 인코딩은 utf8

CREATE TABLE contact(
	num INTEGER AUTO_INCREMENT PRIMARY KEY,
	name varchar(21),
	address Text,
	tel varchar(11),
	email char(100),
	birthday DATE	
)ENGINE = MyISAM AUTO_INCREMENT = 1 DEFAULT CHARSET = utf8;

-- contact 테이블에 age 컬럼을 정수 자료형으로 추가
ALTER TABLE contact
ADD age INTEGER;

-- contact 테이블 구조 확인
DESC contact

-- contact 테이블에서 age 컬럼 삭제
ALTER TABLE contact
DROP age;

DESC contact;

-- contact 테이블에서 tel 컬럼의 이름을 phone 으로 자료형은 정수로 수정
ALTER TABLE contact
CHANGE tel phone INTEGER;

DESC contact;

-- contact 테이블에서 num 컬럼의 자료형을 실수로 수정
ALTER TABLE contact
modify num float;

-- contact 테이블 삭제
DROP TABLE contact;
SHOW TABLES;

-- DEPT 테이블은 EMP 테이블에서 DEPTNO 컬럼을 참조하므로 삭제가 안됨
DROP TABLE DEPT;

-- NOT NULL 제약조건 설정
CREATE TABLE tnullable(
	name char(10) NOT NULL,
	age INTEGER
);

INSERT INTO tnullable(name, age) VALUES('junho', 23);
-- 에러
INSERT INTO tnullable(age) VALUES(25);

DROP TABLE tnullable;

-- 기본값 설정
CREATE TABLE tDefault(
	name CHAR(10) NOT NULL,
	age INTEGER DEFAULT 0
);

INSERT INTO tDefault(name, age) values('junho', '25');
-- 기본값이 설정된 컬럼을 제외하고 입력하면 그 컬럼에는 기본값이 삽입됨
INSERT INTO tDefault(name) values('jungeol');

-- 데이터 확인
SELECT * 
from tDefault

-- name, gender(성별 - 남 또는 여), age(나이는 양수)를 속성으로 갖는
-- 테이블을 생성
CREATE TABLE tcheck(
	name CHAR(10) NOT NULL,
	gender CHAR(3) CHECK(gender in ('남','여')),
	age INTEGER CHECK(age >= 0)
);

INSERT INTO tcheck(name, gender, age) values ('송준호','남','25');
-- age 음수라서 에러
INSERT INTO tcheck(name, gender, age) values ('송준걸','남','-22');
-- gender 여자라서 에러 (남 또는 여)
INSERT INTO tcheck(name, gender, age) values ('김정은','여자','24');

SELECT *
FROM tcheck

-- 기본키 설정
CREATE TABLE tPK1(
	name CHAR(10) PRIMARY KEY,
	age INT
);
-- 기본키 설정 : 제약조건 이름과 함께 생성 - 컬럼 제약 조건
CREATE TABLE tPK2(
	name CHAR(10) CONSTRAINT tPK2_PK PRIMARY KEY,
	age INT
);

-- 기본키 설정 : 제약조건 이름과 함께 생성 - 테이블 제약 조건
CREATE TABLE tPK3(
	name CHAR(10),
	age INT,
	CONSTRAINT PK_tPK2 PRIMARY KEY(name)
);

-- 2개의 컬럼으로 기본키 설정 : 테이블을 설정할 때 PRIMARY KEY는 한 번만 사용 가능
CREATE TABLE tPK4(
	name CHAR(10) PRIMARY KEY,
	age INT PRIMARY KEY
);

CREATE TABLE tPK4(
	name CHAR(10),
	age INT,
	CONSTRAINT PK_tPK4 PRIMARY KEY(name, age)
);

INSERT INTO tPK1(name, age) values('junho', 24);
-- 기본키인 name 이 값아서 에러
INSERT INTO tPK1(name, age) values('junho', 25);
-- 기본키인 name의 값이 NULL 삽입 실패 에러
INSERT INTO tPK1(age) values(20);

show tables


CREATE TABLE tUnique(
	name CHAR(10),
	age INT UNIQUE,
	CONSTRAINT tUnique PRIMARY KEY(name)
);

INSERT INTO tUnique(name, age) values('junho', 25)
-- age가 중복되어 삽입 실패
INSERT INTO tUnique(name, age) values('jungeol', 25);
-- unique는 null 삽입 가능
-- null은 중복 체크 대상이 아니라서 삽입이 가능
INSERT INTO tUnique(name) values('jungeol');
INSERT INTO tUnique(name) values('jjongni');

-- 외래키를 지정하지 않는 2개의 테이블
-- 직원 테이블
CREATE TABLE tEmployee(
	name CHAR(10) PRIMARY KEY,
	salary INT NOT NULL,
	addr VARCHAR(30) NOT NULL
);

INSERT INTO tEmployee VALUES('아이린',650,'대구');
INSERT INTO tEmployee VALUES('슬기',600,'서울');
INSERT INTO tEmployee VALUES('예리',1000,'인천');

SELECT *
From tEmployee

-- 프로젝트 테이블
-- employee 는 프로젝트에 참여한 직원
CREATE TABLE tProject(
	projectid INT PRIMARY KEY,
	employee CHAR(10) NOT NULL,
	project VARCHAR(30) NOT NULL,
	cost INT
);

INSERT INTO tProject VALUES(1, '아이린','웹서비스', 3000);
-- 조이는 tEmployee 테이블에 없는 이름인데 삽입이 가능
INSERT INTO tProject VALUES(2, '조이','마이크로서비스 구축', 10000);

select *
from tProject

-- 기존 테이블 삭제
DROP TABLE tEmployee;
DROP TABLE tProject;

-- 테이블 존재 확인
show tables

-- 외래키 설정 - 직원과 프로젝트 관계는 1:N
-- 직원 테이블
CREATE TABLE tEmployee(
	name CHAR(10) PRIMARY KEY,
	salary INT NOT NULL,
	addr VARCHAR(30) NOT NULL
);

INSERT INTO tEmployee VALUES('아이린',650,'대구');
INSERT INTO tEmployee VALUES('슬기',600,'서울');
INSERT INTO tEmployee VALUES('예리',1000,'인천');

-- 프로젝트 테이블
-- employee 는 프로젝트에 참여한 직원
CREATE TABLE tProject(
	projectid INT PRIMARY KEY,
	employee CHAR(10) NOT NULL REFERENCES tEmployee(name),
	project VARCHAR(30) NOT NULL,
	cost INT
);

-- 위 방법과 결과가 같음. 편한 것으로 사용
CREATE TABLE tProject(
	projectid INT PRIMARY KEY,
	employee CHAR(10) NOT NULL,
	project VARCHAR(30) NOT NULL,
	cost INT,
	CONSTRAINT FK_emp FOREIGN KEY(employee) REFERENCES tEmployee(name)
);

INSERT INTO tProject VALUES(1, '아이린','웹서비스', 3000);

-- 조이는 tEmployee 테이블에 없는 이름이므로 삽입 불가
INSERT INTO tProject VALUES(2, '조이','마이크로서비스 구축', 10000);
-- tEmployee 테이블에서 데이터를 삭제
DELETE FROM tEmployee WHERE name = '예리';
-- 아이린은 tProject 테이블에서 참조하고 있기 때문에 삭제 불가능
DELETE FROM tEmployee WHERE name = '아이린';
-- tEmployee 테이블 삭제 불가능
DROP TABLE tEmployee

-- 실습을 위해 기존 테이블 삭제
DROP TABLE tProject;
DROP TABLE tEmployee;
SHOW TABLES;

-- 옵션과 함께 외래키 설정 - 직원과 프로젝트 관계는 1:N
-- 직원 테이블
CREATE TABLE tEmployee(
	name CHAR(10) PRIMARY KEY,
	salary INT NOT NULL,
	addr VARCHAR(30) NOT NULL
);

INSERT INTO tEmployee VALUES('아이린',650,'대구');
INSERT INTO tEmployee VALUES('슬기',600,'서울');
INSERT INTO tEmployee VALUES('예리',1000,'인천');

SELECT *
FROM tEmployee

-- tEmployee 테이블에 name 이 삭제 및 수정될 때 같이 삭제 및 수정이 됨
CREATE TABLE tProject(
	projectid INT PRIMARY KEY,
	employee CHAR(10) NOT NULL,
	project VARCHAR(30) NOT NULL,
	cost INT,
	CONSTRAINT FK_emp FOREIGN KEY(employee) REFERENCES tEmployee(name) 
		ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO tProject VALUES(1, '아이린','웹서비스', 3000);

SELECT *
FROM tProject;

-- tEmployee 테이블에서 아이린을 배주현으로 수정 - tProject에서도 수정됨
UPDATE tEmployee SET name = '배주현' where name = '아이린';

SELECT *
FROM tEmployee

SELECT *
FROM tProject;

-- tEmployee 테이블에서 배주현을 삭제 - tProject에서도 삭제됨
DELETE FROM tEmployee where name = '배주현'

SELECT *
FROM tEmployee;

SELECT *
FROM tProject;

-- tEmployee 테이블의 name이 수정되거나 삭제될 때 NULL로 수정됨
DROP TABLE tProject;
DROP TABLE tEmployee;

CREATE TABLE tEmployee(
	name CHAR(10) PRIMARY KEY,
	salary INT NOT NULL,
	addr VARCHAR(30) NOT NULL
);

CREATE TABLE tProject(
	projectid INT PRIMARY KEY,
	employee CHAR(10),
	project VARCHAR(30) NOT NULL,
	cost INT,
	CONSTRAINT FK_emp FOREIGN KEY(employee) REFERENCES tEmployee(name) 
		ON DELETE SET NULL ON UPDATE SET NULL
);

INSERT INTO tEmployee VALUES('아이린',650,'대구');
INSERT INTO tProject VALUES(1, '아이린','웹서비스', 3000);

SELECT *
FROM tProject;

-- tEmployee 테이블에서 아이린을 배주현으로 수정 - employee 값이 NULL로 설정
UPDATE tEmployee SET name = '배주현' where name = '아이린';

SELECT*
FROM tEmployee

-- 일련번호 사용
CREATE TABLE BOARD(
	num INT AUTO_INCREMENT PRIMARY KEY,
	title CHAR(100),
	content TEXT
)

INSERT INTO BOARD(title, content) Values('제목1','내용1');
INSERT INTO BOARD(title, content) Values('제목2','내용2');
-- 자동으로 1, 2 순서대로 삽입
SELECT * FROM BOARD;

-- 2번 데이터 삭제
DELETE FROM BOARD WHERE num = 2;
INSERT INTO BOARD(title, content) Values('제목3','내용3');
-- 3번으로 삽입
SELECT * FROM BOARD;

-- AUTO_INCREMENT 값도 직접 삽입 가능
INSERT INTO BOARD(num, title, content) Values(200,'제목1','내용1');
INSERT INTO BOARD(title, content) Values('제목?','내용?');
SELECT * FROM BOARD;

-- 일련번호 초기화
ALTER TABLE BOARD AUTO_INCREMENT = 1000;
INSERT INTO BOARD(title, content) VALUES('제목?',"내용?");
SELECT * FROM BOARD;

-- 제약조건 조회
SELECT *
FROM information_schema.table_constraints;

-- 데이터 삽입을 위해 테이블 구조 확인
DESC tCity

-- 컬럼 이름을 나열해서 데이터 삽입
INSERT INTO tCity(name, area, popu, metro, region)
values ('평택',200, 130, 'n','경기');

-- 모든 컬럼의 값을 순서대로 입력할 때는 컬럼 이름 생략가능
INSERT INTO tCity
values ('목포',23, 53, 'n','전라');

-- NOT NULL이 설정된 컬럼을 제외하고는 생략하고 삽입 가능
INSERT INTO tCity(name, area, metro, region)
values ('여수',25,'n','전라');

SELECT *
from tCity

-- 한꺼번에 삽입
INSERT INTO tCity(name, area, metro, region)
values ('창원',30,'n','경상'), ('논산',28,'n','충청'), ('통영',104,'n','전라');

SELECT *
FROM tCity

-- tCity 테이블에서 name이 대전인 데이터 삭제
DELETE FROM tCity WHERE name = '대전'

-- tCity 테이블에서 name이 창원인 데이터의 popu를 40으로 수정
UPDATE tCity SET popu = 40 WHERE name = '창원' ;



