-- 임시 데이터 삽입 SQL

-- Countries 테이블
INSERT INTO countries (id, name, code) VALUES
(1, '대한민국', 'KR'),
(2, '미국', 'US'),
(3, '일본', 'JP'),
(4, '중국', 'CN'),
(5, '독일', 'DE');

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
