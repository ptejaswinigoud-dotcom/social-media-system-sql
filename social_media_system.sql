-- ============================================
--   Social Media System - SQL Project
--   Author: Likhith
-- ============================================

CREATE DATABASE SocialMediaSystem;
USE SocialMediaSystem;

-- ============================================
--   TABLE CREATION
-- ============================================

CREATE TABLE Users (
    user_id   INT PRIMARY KEY,
    username  VARCHAR(100),
    followers INT,
    join_date DATE
);

CREATE TABLE Posts (
    post_id    INT PRIMARY KEY,
    user_id    INT,
    content    TEXT,
    created_at DATE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE Likes (
    like_id INT PRIMARY KEY,
    post_id INT,
    user_id INT,
    FOREIGN KEY (post_id) REFERENCES Posts(post_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE Comments (
    comment_id   INT PRIMARY KEY,
    post_id      INT,
    user_id      INT,
    comment_text TEXT,
    FOREIGN KEY (post_id) REFERENCES Posts(post_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- ============================================
--   INSERT DATA
-- ============================================

INSERT INTO Users (user_id, username, followers, join_date)
VALUES
(1, 'Likhith',    350, '2024-01-10'),
(2, 'Bharath',    300, '2024-02-15'),
(3, 'Tejaswini',  500, '2024-03-20'),
(4, 'Jashwanth',  150, '2024-04-01'),
(5, 'Rudra sai',  280, '2024-05-05');

INSERT INTO Posts (post_id, user_id, content, created_at)
VALUES
(101, 1, 'Learning SQL is fun!',      '2025-01-01'),
(102, 2, 'React projects are awesome','2025-01-05'),
(103, 3, 'AI is changing the world',  '2025-01-10'),
(104, 1, 'Cloud computing basics',    '2025-01-12'),
(105, 4, 'Enjoying Tailwind CSS',     '2025-01-15');

INSERT INTO Likes (like_id, post_id, user_id)
VALUES
(1,  101, 2),
(2,  101, 3),
(3,  101, 4),
(4,  102, 1),
(5,  102, 3),
(6,  103, 1),
(7,  103, 2),
(8,  103, 4),
(9,  103, 5),
(10, 104, 3),
(11, 105, 1);

INSERT INTO Comments (comment_id, post_id, user_id, comment_text)
VALUES
(1, 101, 2, 'Great post!'),
(2, 101, 3, 'Very useful'),
(3, 102, 1, 'Nice content'),
(4, 103, 4, 'Amazing AI info'),
(5, 103, 5, 'Loved this'),
(6, 103, 2, 'Excellent'),
(7, 104, 1, 'Helpful');

-- ============================================
--   VIEW ALL TABLES
-- ============================================

SELECT * FROM Users;
SELECT * FROM Posts;
SELECT * FROM Likes;
SELECT * FROM Comments;

-- ============================================
--   QUERY 1: Posts with above-average likes
--   Concept: Subquery, AVG, GROUP BY, HAVING
-- ============================================

SELECT
    post_id,
    COUNT(*) AS total_likes
FROM Likes
GROUP BY post_id
HAVING COUNT(*) > (
    SELECT AVG(like_count)
    FROM (
        SELECT COUNT(*) AS like_count
        FROM Likes
        GROUP BY post_id
    ) AS avg_table
);

-- ============================================
--   QUERY 2: Top 5 most liked posts
--   Concept: ORDER BY, LIMIT
-- ============================================

SELECT
    post_id,
    COUNT(*) AS total_likes
FROM Likes
GROUP BY post_id
ORDER BY total_likes DESC
LIMIT 5;

-- ============================================
--   QUERY 3: Users who never posted
--   Concept: NOT IN, Subquery
-- ============================================

SELECT username
FROM Users
WHERE user_id NOT IN (
    SELECT user_id
    FROM Posts
);

-- ============================================
--   QUERY 4: User type classification
--   Concept: CASE Statement
-- ============================================

SELECT
    username,
    followers,
    CASE
        WHEN followers > 1000 THEN 'Influencer'
        ELSE 'Normal'
    END AS user_type
FROM Users;

-- ============================================
--   QUERY 5: Search posts by keyword
--   Concept: LIKE
-- ============================================

SELECT *
FROM Posts
WHERE content LIKE '%SQL%';

-- ============================================
--   QUERY 6: Posts within a date range
--   Concept: BETWEEN
-- ============================================

SELECT *
FROM Posts
WHERE created_at BETWEEN '2025-01-01' AND '2025-01-10';

-- ============================================
--   QUERY 7: Posts with 2 to 4 likes
--   Concept: HAVING, BETWEEN
-- ============================================

SELECT
    post_id,
    COUNT(*) AS total_likes
FROM Likes
GROUP BY post_id
HAVING COUNT(*) BETWEEN 2 AND 4;

-- ============================================
--   QUERY 8: High-engagement posts
--   Concept: LEFT JOIN, COUNT DISTINCT, HAVING
-- ============================================

SELECT
    p.post_id,
    p.content,
    COUNT(DISTINCT l.like_id)    AS total_likes,
    COUNT(DISTINCT c.comment_id) AS total_comments
FROM Posts p
LEFT JOIN Likes    l ON p.post_id = l.post_id
LEFT JOIN Comments c ON p.post_id = c.post_id
GROUP BY p.post_id, p.content
HAVING total_likes >= 3
   AND total_comments >= 2;

-- ============================================
--   QUERY 9: Engagement summary view
--   Concept: CREATE VIEW, JOIN, COUNT DISTINCT
-- ============================================

CREATE VIEW EngagementSummary AS
SELECT
    p.post_id,
    p.content,
    u.username,
    COUNT(DISTINCT l.like_id)    AS total_likes,
    COUNT(DISTINCT c.comment_id) AS total_comments
FROM Posts p
JOIN Users u ON p.user_id = u.user_id
LEFT JOIN Likes    l ON p.post_id = l.post_id
LEFT JOIN Comments c ON p.post_id = c.post_id
GROUP BY p.post_id, p.content, u.username;

SELECT * FROM EngagementSummary;
