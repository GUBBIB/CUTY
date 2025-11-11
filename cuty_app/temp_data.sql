-- 임시 데이터 삽입 SQL

-- Countries 테이블
INSERT INTO countries (id, name, code) VALUES
(1, '대한민국', 'KR'),
(2, '미국', 'US'),
(3, '일본', 'JP'),
(4, '중국', 'CN'),
(5, '독일', 'DE');

-- Schools 테이블
INSERT INTO schools (id, name, country_id) VALUES
-- 한국 학교들
(1, '서울대학교', 1),
(2, '연세대학교', 1),
(3, '고려대학교', 1),
(4, 'KAIST', 1),
-- 미국 학교들
(5, 'MIT', 2),
(6, 'Stanford University', 2),
(7, 'Harvard University', 2),
-- 일본 학교들
(8, '도쿄대학교', 3),
(9, '와세다대학교', 3),
-- 중국 학교들
(10, '베이징대학교', 4),
-- 독일 학교들
(11, '뮌헨공과대학교', 5);

-- Colleges 테이블
INSERT INTO colleges (id, name, school_id) VALUES
-- 서울대학교
(1, '공과대학', 1),
(2, '경영대학', 1),
(3, '인문대학', 1),
-- 연세대학교
(4, '공과대학', 2),
(5, '경영대학', 2),
-- 고려대학교
(6, '공과대학', 3),
(7, '경영대학', 3),
-- KAIST
(8, '전산학부', 4),
(9, '공과대학', 4),
-- MIT
(10, 'School of Engineering', 5),
(11, 'Sloan School of Management', 5),
-- Stanford
(12, 'School of Engineering', 6),
(13, 'Graduate School of Business', 6);

-- Departments 테이블
INSERT INTO departments (id, name, college_id) VALUES
-- 서울대 공과대학
(1, '컴퓨터공학부', 1),
(2, '전자정보공학부', 1),
(3, '기계공학부', 1),
-- 서울대 경영대학
(4, '경영학과', 2),
-- 서울대 인문대학
(5, '국어국문학과', 3),
(6, '영어영문학과', 3),
-- 연세대 공과대학
(7, '컴퓨터과학과', 4),
(8, '전기전자공학과', 4),
-- 연세대 경영대학
(9, '경영학과', 5),
-- 고려대 공과대학
(10, '컴퓨터학과', 6),
(11, '전기전자공학부', 6),
-- 고려대 경영대학
(12, '경영학과', 7),
-- KAIST
(13, '전산학과', 8),
(14, '기계공학과', 9),
(15, '전기및전자공학부', 9),
-- MIT
(16, 'Computer Science', 10),
(17, 'Electrical Engineering', 10),
(18, 'Management', 11),
-- Stanford
(19, 'Computer Science', 12),
(20, 'Electrical Engineering', 12),
(21, 'MBA', 13);

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
