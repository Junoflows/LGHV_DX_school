use junoflow;

-- SELECT 구문 실행 : 트랜잭션과 아무런 연관성이 없음
SELECT * FROM DEPT

-- DEPT 테이블에 데이터 1개 삽입 : 이전 트랜잭션이 없어서 트랜잭션이 생성
INSERT INTO DEPT(DEPTNO, DNAME, LOC) VALUES(50,'회계','서울');

SELECT * FROM DEPT;

-- 철회 : SAVEPOINT를 입력하지 않으면 트랜잭션 시작 전으로 복구
ROLLBACK;

SELECT * FROM DEPT;

-- 삽입 - 트랜잭션이 생성
INSERT INTO DEPT(DEPTNO, DNAME, LOC) VALUES(50,'회계','서울');

-- DEPT 테이블의 모든 내용을 가진 DEPTCOPY 테이블을 생성
-- DDL(CREATE, DROP, ALTER, TRUNCATE, RENAME), DCL(GRANT, REVOKE) 를 수행하면 AUTO_COMMIT
-- COMMIT 수행 : 트랜잭션은 변경 내용을 반영하고 종료
CREATE TABLE DEPTCOPY
AS
SELECT *
FROM DEPT;

-- 철회
ROLLBACK;

SELECT * FROM DEPT


INSERT INTO DEPT(DEPTNO, DNAME, LOC) VALUES(60,'회계','서울');

SAVEPOINT SV1;

INSERT INTO DEPT(DEPTNO, DNAME, LOC) VALUES(70,'회계','서울');

SAVEPOINT SV2;

INSERT INTO DEPT(DEPTNO, DNAME, LOC) VALUES(80,'회계','서울');

SELECT * FROM DEPT;

-- SV1 을 생성한 지점으로 이동
ROLLBACK TO SV1;

SELECT * FROM DEPT;

-- COMMIT
COMMIT;

-- 일반적은 JOIN 방법으로 JOB이 CLERK인 데이터의 정보를 조회
SELECT *
FROM EMP, DEPT
WHERE EMP.DEPTNO = DEPT.DEPTNO AND JOB = 'CLERK';

-- INLINE VIEW 를 이용한 JOIN
SELECT *
FROM (SELECT * FROM EMP WHERE JOB = 'CLERK') TEMP, DEPT
WHERE TEMP.DEPTNO = DEPT.DEPTNO

-- EMP 테이블에서 EMPNO, ENAME, SAL, COMM 만으로 구성된 뷰를 생성
CREATE VIEW KIM
AS
SELECT EMPNO, ENAME, SAL, COMM
FROM EMP;

-- VIEW는 테이블 처럼 사용
SELECT *
FROM KIM;

-- VIEW에 DML(삽입, 삭제, 갱신) 작업은 가능한 경우도 있고 불가능할 수도 있음
DESC EMP;

-- VIEW에 데이터 삽입 : 뷰를 만들 때 사용한 EMP 테이블에 데이터가 삽입됨
INSERT INTO KIM(EMPNO, ENAME, SAL, COMM) VALUES(9999, 'JUNHO', 10000, 9000);

SELECT *
FROM KIM;

SELECT *
FROM EMP;

-- 뷰의 구조 확인
DESC KIM;

-- 뷰 삭제
DROP VIEW KIM;

-- 임시 테이블 생성
-- 연결을 끊고 다시 들어가면 TEMP 테이블은 없음
CREATE TEMPORARY TABLE TEMP(
	NAME CHAR(20)
);

SELECT *
FROM TEMP;

-- CTE : SQL 수행 중에만 일시적으로 메모리 공간을 할당받아서 사용하는 테이블
-- 서브쿼리가 인라인 뷰 보다 먼저 실행돼서 인라인뷰를 서브 쿼리에 쓸 수 없음
SELECT *
FROM (SELECT NAME, SALARY, SCORE FROM tStaff DEPART = '영업부', AND GENDER = '남') TEMP
WHERE SALARY >= (SELECT AVG(SALARY) FROM TEMP);

WITH TEMP AS
(SELECT NAME, SALARY, SCORE FROM tStaff WHERE DEPART = '영업부' AND GENDER = '남')
SELECT * FROM TEMP WHERE SALARY >= (SELECT AVG(salary) FROM TEMP);

-- usertbl 테이블 존재 확인
show tables;

DESC usertbl;

SELECT * from usertbl;

-- DELIMITER는 프로시저 종료를 알리기 위한 기호를 설정하는 것
-- 하나로 만들면 데이터로 사용되는 것과 혼동이 올 수 있으니 2개로 사용
-- Dbeaver 에서 수행할 땐 SQL 스크립트 실행으로 실행해야 함
DELIMITER //
CREATE PROCEDURE myproc(vuserid char(15), vname varchar(20), vbirthday int, 
	vaddr char(100), vmobile char(11), vmdate date)
		Begin
			INSERT INTO usertbl
			values(vuserid, vname, vbirthday, vaddr, vmobile, vmdate);
		END // 
DELIMITER;

call myproc('junoflow', '송준호','1999','서울','01078787878', '1999-10-12')

select *
from usertbl;

-- 트리거를 수행하기 위한 샘플 테이블 생성
CREATE TABLE EMP01(
	EMPNO INT PRIMARY KEY,
	ENAME VARCHAR(30) NOT NULL,
	JOB VARCHAR(100)
);

CREATE TABLE SAL01(
	SALNO INT PRIMARY KEY AUTO_INCREMENT,
	SAL FLOAT(7, 2),
	EMPNO INT REFERENCES EMP01(EMPNO) ON DELETE CASCADE
);

-- EMP01 테이블에 데이터를 추가하면 SAL01 테이블에 데이터가 자동으로 추가되는 트리거
DELIMITER //
CREATE TRIGGER trg_01
AFTER INSERT ON EMP01
FOR EACH ROW 
BEGIN 
	INSERT INTO SAL01(SAL, EMPNO) VALUES(100, NEW.EMPNO);
END//
DELIMITER

INSERT INTO EMP01 VALUES(1, 'JUNHO','STUDENT');

SELECT *
FROM EMP01;

SELECT *
FROM SAL01;

-- 데이터베이스 사용 설정
use junoflow;

show tables;

-- 테이블 구조 확ㅇ니
DESC DEPT;

SELECT *
FROM DEPT;

-- 파일을 저장할 수 있는 테이블
CREATE TABLE BLOBTABLE(
	filename VARCHAR(100),
	filecontent LONGBLOB
);

DESC BLOBTABLE;

SELECT * FROM BLOBTABLE;
