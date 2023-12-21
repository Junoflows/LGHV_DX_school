-- 샘플 데이터 확인
SELECT * FROM EMP;
DESC EMP; -- 오라클은 외부에서 DESC 명령어를 수행할 수 없도록 함

SELECT MAX(LEVEL)
FROM EMP
START WITH MGR IS NULL
CONNECT BY PRIOR EMPNO = MGR;

SELECT *
FROM EMP;

SELECT LEVEL, ENAME, EMPNO, MGR
FROM EMP
START WITH UPPER(JOB) = 'PRESIDENT'
CONNECT BY PRIOR EMPNO = MGR;

-- 출발점으로 JONES로 설정
-- JONES의 부하 직원 레벨을 조회
SELECT LEVEL, ENAME, EMPNO, MGR
FROM EMP
START WITH ENAME = 'JONES'
CONNECT BY PRIOR EMPNO = MGR;

-- JONES부터 상관을 조회
SELECT LEVEL, ENAME, EMPNO, MGR
FROM EMP
START WITH ENAME = 'JONES'
CONNECT BY PRIOR MGR = EMPNO AND LEVEL <= 2;

-- ROWID 조회
SELECT ROWID, ENAME
FROM EMP;

-- EMP 테이블에서 DEPTNO 별로 한 명의 DEPTNO와 ENAME을 조회
SELECT ENAME, DEPTNO
FROM EMP;

-- DISTINCT는 여러 개의 컬럼이 작성되면 모든 컬럼이 같아야 제거가 됨
SELECT DISTINCT ENAME, DEPTNO
FROM EMP;

-- group BY는 그룹화하지 않은 컬럼을 SELECT 절에 출력할 수 없음
SELECT DEPTNO, ENAME
FROM EMP
GROUP BY DEPTNO;

-- 다른 컬럼을 사용하지 않고 그룹화 한 후 ID가 가장 큰 데이터를 추출
SELECT DEPTNO, ENAME
FROM EMP
WHERE ROWID IN (SELECT MAX(ROWID) FROM EMP GROUP BY DEPTNO) 

-- 행번호 조회
SELECT ROWNUM, ENAME
FROM EMP;

-- ROWNUM을 이용한 조회 조건을 만들 때 주의
SELECT ROWNUM, ENAME
FROM EMP
WHERE ROWNUM < 3;

SELECT ROWNUM, ENAME
FROM EMP
WHERE ROWNUM > 3;

-- 급여의 내림차순으로 정렬해서 조회
SELECT *
FROM EMP
ORDER BY SAL DESC;

-- 급여의 내림차순으로 정렬해서 5개 데이터만 조회
SELECT *
FROM EMP
ORDER BY SAL DESC
OFFSET 0
ROWS FETCH NEXT 5 ROWS ONLY;

-- EMP 테이블에 사원이라는 SYNONYM 생성
CREATE SYNONYM 사원
FOR EMP;

SELECT *
FROM 사원;

SELECT *
FROM EMP;

-- SEQUENCE 삭제
DROP SEQUENCE DEPT_SEQ;

-- SEQUENCE 생성
CREATE SEQUENCE DEPT_SEQ
	START WITH 50
	INCREMENT BY 3;

-- 값 확인
SELECT DEPT_SEQ.NEXTVAL
FROM DUAL;

-- 시퀀스를 이용한 데이터 삽입
INSERT INTO DEPT(DEPTNO, DNAME, LOC) VALUES(DEPT_SEQ.NEXTVAL, '기획','팡주');

-- 확인
SELECT *
FROM DEPT;

-- EMP 테이블에서 JOB 별로 SAL의 평균을 조회
SELECT JOB, AVG(SAL) 급여평균
FROM EMP
GROUP BY JOB;

SELECT NVL(JOB, '전체')JOB, AVG(SAL) 급여평균
FROM EMP
GROUP BY ROLLUP(JOB);

-- DEPTNO 별로 SAL의 합계 조회
-- 숫자 컬럼은 조회할 때 DECODE로 감싸야 함
-- DECODE 값이 NULL이면 전체 그렇지 않으면 DEPTNO를 변환해서 조회
SELECT DECODE(DEPTNO, NULL, '전체', DEPTNO)DEPTNO, SUM(SAL) 급여합계
FROM EMP
GROUP BY ROLLUP(DEPTNO);

-- 부서별 합계와 전체 합계 조회
SELECT DEPTNO, JOB, SUM(SAL) 급여합계
FROM EMP
GROUP BY ROLLUP(DEPTNO, JOB)
ORDER BY DEPTNO;

-- 전체 합계는 제외
SELECT DEPTNO, NVL(JOB, '합계'), SUM(SAL) 급여합계
FROM EMP
GROUP BY DEPTNO, ROLLUP(JOB)
ORDER BY DEPTNO;

-- CUBE는 모든 중간 집계를 조회
SELECT DEPTNO, JOB, SUM(SAL) 급여합계
FROM EMP
GROUP BY ROLLUP(DEPTNO, JOB)
ORDER BY DEPTNO;

SELECT DEPTNO, JOB, SUM(SAL) 급여합계
FROM EMP
GROUP BY CUBE(DEPTNO, JOB)
ORDER BY DEPTNO;

-- GROUPING : 중간 집계이면 1, 아니면 0 리턴
SELECT DEPTNO, GROUPING(DEPTNO), JOB, GROUPING(JOB), SUM(SAL) AS 급여합계
FROM EMP
GROUP BY ROLLUP(DEPTNO, JOB)
ORDER BY DEPTNO;

SELECT DEPTNO, DECODE(GROUPING(DEPTNO), 1, '전체 합계') AS ALLTOT, 
	JOB, DECODE(GROUPING(JOB), 1, '부서 합계') AS DEPTTOT, SUM(SAL) AS 급여합계
FROM EMP
GROUP BY ROLLUP(DEPTNO, JOB)
ORDER BY DEPTNO;

-- GROUPING SETS는 개별 그룹화를 수행
SELECT DEPTNO, JOB, SUM(SAL) 급여합계
FROM EMP
GROUP BY ROLLUP(DEPTNO, JOB);

SELECT DEPTNO, JOB, SUM(SAL) 급여합계
FROM EMP
GROUP BY GROUPING SETS(DEPTNO, JOB);

-- EMP 테이블에서 전체 SAL에서 자신의 SAL 비율
-- 이 구문은 SAL과 SUM(SAL)의 행 개수가 달라서 에러
SELECT ENAME, SAL, SAL / SUM(SAL)
FROM EMP;

-- SUM(SAL)을 전부 복사해서 14개의 행으로 만들어서 조회
-- 컬럼 이름에 벌명 부여 가능
-- AS 생략가능
-- 별명에 영문 대문자나 공백이 있으면 ""로 감싸야 함
SELECT ENAME, SAL, SAL * 100 / SUM(SAL) OVER() AS "급여 비율"
FROM EMP;

-- EMP 테이블에서 EMPNO, ENAME, SAL, 현재행까지의 SAL 합계를 조회
SELECT EMPNO, ENAME, SAL, SUM(SAL) OVER(ORDER BY SAL 
	ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) "현재까지의 급여 합계"
FROM EMP;

-- EMP 테이블에서 EMPNO, ENAME, SAL, 현재행부터 마지막까지의 SAL 합계를 조회
SELECT EMPNO, ENAME, SAL, SUM(SAL) OVER(ORDER BY SAL 
	ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) "현재까지의 급여 합계"
FROM EMP;

-- 부서별 급여 평균
SELECT EMPNO, ENAME, SAL, AVG(SAL) OVER(PARTITION BY DEPTNO) "부서별 평균 급여"
FROM EMP;

-- 부서별 급여 순위
SELECT ENAME, SAL, DEPTNO,
	RANK () OVER(PARTITION BY DEPTNO ORDER BY SAL DESC) "급여 순위",
	DENSE_RANK () OVER(PARTITION BY DEPTNO ORDER BY SAL DESC) "급여 순위",
	ROW_NUMBER () OVER(PARTITION BY DEPTNO ORDER BY SAL DESC) "급여 순위"
FROM EMP;

-- pivot
SELECT * FROM EMP
PIVOT(MAX(SAL) FOR DEPTNO IN (10, 20, 30));