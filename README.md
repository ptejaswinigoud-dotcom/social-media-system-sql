# 📱 Social Media System — SQL Project

A relational database project built with MySQL to simulate the backend data layer of a social media platform. Covers user management, post creation, likes, comments, and engagement analytics using core SQL concepts.

---

## 🗄️ Database Schema

The system uses four interrelated tables:

| Table | Description |
|---|---|
| `Users` | Stores user profiles with followers count and join date |
| `Posts` | Stores user-created posts with content and timestamps |
| `Likes` | Tracks which users liked which posts |
| `Comments` | Stores comments made by users on posts |

### Entity Relationships
- A **User** can create many **Posts**
- A **Post** can receive many **Likes** and **Comments**
- **Likes** and **Comments** reference both `Users` and `Posts` via foreign keys

---

## 🧱 Tables Overview

### Users
CREATE TABLE Users (
    user_id   INT PRIMARY KEY,
    username  VARCHAR(100),
    followers INT,
    join_date DATE
);

### Posts
CREATE TABLE Posts (
    post_id    INT PRIMARY KEY,
    user_id    INT,
    content    TEXT,
    created_at DATE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

### Likes
CREATE TABLE Likes (
    like_id INT PRIMARY KEY,
    post_id INT,
    user_id INT,
    FOREIGN KEY (post_id) REFERENCES Posts(post_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

### Comments
CREATE TABLE Comments (
    comment_id   INT PRIMARY KEY,
    post_id      INT,
    user_id      INT,
    comment_text TEXT,
    FOREIGN KEY (post_id) REFERENCES Posts(post_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

---

## 🔍 SQL Queries

### Query 1 — Posts with above-average likes (Subquery)
Finds posts that received more likes than the average across all posts.

SELECT post_id, COUNT(*) AS total_likes
FROM Likes
GROUP BY post_id
HAVING COUNT(*) > (
    SELECT AVG(like_count)
    FROM (SELECT COUNT(*) AS like_count FROM Likes GROUP BY post_id) AS avg_table
);

### Query 2 — Top 5 most liked posts
Ranks posts by total likes in descending order.

SELECT post_id, COUNT(*) AS total_likes
FROM Likes
GROUP BY post_id
ORDER BY total_likes DESC
LIMIT 5;

### Query 3 — Users who never posted (NOT IN)
Identifies users with no posts using a subquery.

SELECT username
FROM Users
WHERE user_id NOT IN (SELECT user_id FROM Posts);

### Query 4 — User type classification (CASE)
Labels users as Influencer (>1000 followers) or Normal.

SELECT username, followers,
    CASE
        WHEN followers > 1000 THEN 'Influencer'
        ELSE 'Normal'
    END AS user_type
FROM Users;

### Query 5 — Search posts by keyword (LIKE)
Filters posts whose content contains the word "SQL".

SELECT * FROM Posts WHERE content LIKE '%SQL%';

### Query 6 — Posts within a date range (BETWEEN)
Retrieves posts created between January 1 and January 10, 2025.

SELECT * FROM Posts
WHERE created_at BETWEEN '2025-01-01' AND '2025-01-10';

### Query 7 — Posts with 2–4 likes (HAVING + BETWEEN)
Filters posts by a specific likes count range.

SELECT post_id, COUNT(*) AS total_likes
FROM Likes
GROUP BY post_id
HAVING COUNT(*) BETWEEN 2 AND 4;

### Query 8 — High-engagement posts (Multi-JOIN + HAVING)
Returns posts with at least 3 likes AND 2 comments using LEFT JOINs.

SELECT p.post_id, p.content,
    COUNT(DISTINCT l.like_id)    AS total_likes,
    COUNT(DISTINCT c.comment_id) AS total_comments
FROM Posts p
LEFT JOIN Likes    l ON p.post_id = l.post_id
LEFT JOIN Comments c ON p.post_id = c.post_id
GROUP BY p.post_id, p.content
HAVING total_likes >= 3 AND total_comments >= 2;

### Query 9 — Engagement summary view (CREATE VIEW)
Creates a reusable view combining posts, users, likes, and comments.

CREATE VIEW EngagementSummary AS
SELECT p.post_id, p.content, u.username,
    COUNT(DISTINCT l.like_id)    AS total_likes,
    COUNT(DISTINCT c.comment_id) AS total_comments
FROM Posts p
JOIN Users u ON p.user_id = u.user_id
LEFT JOIN Likes    l ON p.post_id = l.post_id
LEFT JOIN Comments c ON p.post_id = c.post_id
GROUP BY p.post_id, p.content, u.username;

---

## 💡 Concepts Covered

| Concept | Used In |
|---|---|
| DDL (CREATE TABLE) | Schema setup |
| DML (INSERT, SELECT) | Data population & retrieval |
| Primary & Foreign Keys | All tables |
| Aggregate Functions (COUNT, AVG) | Queries 1, 2, 7, 8, 9 |
| GROUP BY / HAVING | Queries 1, 2, 7, 8 |
| Subqueries | Queries 1, 3 |
| JOINs (JOIN, LEFT JOIN) | Queries 8, 9 |
| CASE Statement | Query 4 |
| LIKE | Query 5 |
| BETWEEN | Queries 6, 7 |
| NOT IN | Query 3 |
| CREATE VIEW | Query 9 |
| ORDER BY / LIMIT | Query 2 |

---

## ▶️ How to Run

1. Open MySQL Workbench or any MySQL client
2. Run the full .sql file to create the database, tables, and insert sample data
3. Execute individual queries to explore the results

mysql -u root -p < social_media_system.sql

---

## 🛠️ Tech Stack

- Database: MySQL
- Tool: MySQL Workbench

