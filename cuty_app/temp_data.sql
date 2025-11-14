-- 임시 데이터 삽입 SQL

-- Countries 테이블
INSERT INTO countries (id, name, code) VALUES
(1, 'ADMIN', 'AD'),
(2, '대한민국', 'KR'),
(3, '미국', 'US'),
(4, '일본', 'JP'),
(5, '중국', 'CN'),
(6, '독일', 'DE');

-- Schools 테이블
INSERT INTO schools (id, name, country_id) VALUES
-- ADMIN
(1, 'ADMIN', 1),
-- 한국 학교들
(2, '서울대학교', 2),
(3, '연세대학교', 2),
(4, '고려대학교', 2),
(5, 'KAIST', 2),
-- 미국 학교들
(6, 'MIT', 3),
(7, 'Stanford University', 3),
(8, 'Harvard University', 3),
-- 일본 학교들
(9, '도쿄대학교', 4),
(10, '와세다대학교', 4),
-- 중국 학교들
(11, '베이징대학교', 5),
-- 독일 학교들
(12, '뮌헨공과대학교', 6);

-- Colleges 테이블
INSERT INTO colleges (id, name, school_id) VALUES
(1, 'ADMIN', 1),
-- 서울대학교
(2, '공과대학', 2),
(3, '경영대학', 2),
(4, '인문대학', 2),
-- 연세대학교
(5, '공과대학', 3),
(6, '경영대학', 3),
-- 고려대학교
(7, '공과대학', 4),
(8, '경영대학', 4),
-- KAIST
(9, '전산학부', 5),
(10, '공과대학', 5),
-- MIT
(11, 'School of Engineering', 6),
(12, 'Sloan School of Management', 6),
-- Stanford
(13, 'School of Engineering', 7),
(14, 'Graduate School of Business', 7);

-- Departments 테이블
INSERT INTO departments (id, name, college_id) VALUES
(1, 'ADMIN', 1),

-- 서울대 공과대학  
(2, '컴퓨터공학부', 2),
(3, '전자정보공학부', 2),
(4, '기계공학부', 2),

-- 서울대 경영대학 
(5, '경영학과', 3),

-- 서울대 인문대학 
(6, '국어국문학과', 4),
(7, '영어영문학과', 4),

-- 연세대 공과대학 
(8, '컴퓨터과학과', 5),
(9, '전기전자공학과', 5),

-- 연세대 경영대학 
(10, '경영학과', 6),

-- 고려대 공과대학 
(11, '컴퓨터학과', 7),
(12, '전기전자공학부', 7),

-- 고려대 경영대학 
(13, '경영학과', 8),

-- KAIST
-- KAIST 전산학부 
(14, '전산학과', 9),
-- KAIST 공과대학 
(15, '기계공학과', 10),
(16, '전기및전자공학부', 10),

-- MIT
-- MIT School of Engineering 
(17, 'Computer Science', 11),
(18, 'Electrical Engineering', 11),
-- MIT Sloan School of Management
(19, 'Management', 12),

-- Stanford
-- Stanford School of Engineering 
(20, 'Computer Science', 13),
(21, 'Electrical Engineering', 13),
-- Stanford Graduate School of Business 
(22, 'MBA', 14);

-- nicknames 랜덤 값
INSERT INTO nicknames (id, nickname, created_at, updated_at, deleted_at) VALUES
(1, '푸른고래', NOW(), NOW(), NULL),
(2, '은하여우', NOW(), NOW(), NULL),
(3, '달빛수달', NOW(), NOW(), NULL),
(4, '바람너구리', NOW(), NOW(), NULL),
(5, '별빛너울', NOW(), NOW(), NULL),
(6, '초코펭귄', NOW(), NOW(), NULL),
(7, '해달곰', NOW(), NOW(), NULL),
(8, '모래여우', NOW(), NOW(), NULL),
(9, '바다냥이', NOW(), NOW(), NULL),
(10, '산책두더지', NOW(), NOW(), NULL),
(11, '라떼토끼', NOW(), NOW(), NULL),
(12, '밤하늘참새', NOW(), NOW(), NULL),
(13, '소금사막', NOW(), NOW(), NULL),
(14, '버블돌고래', NOW(), NOW(), NULL),
(15, '자몽여신', NOW(), NOW(), NULL),
(16, '코딩도치', NOW(), NOW(), NULL),
(17, '안개수리', NOW(), NOW(), NULL),
(18, '별빵고양', NOW(), NOW(), NULL),
(19, '무지개너울', NOW(), NOW(), NULL),
(20, '보라문조', NOW(), NOW(), NULL);
