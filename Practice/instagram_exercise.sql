--1. Find 5 oldest users
SELECT *
FROM users
ORDER BY created_at ASC LIMIT 5;

--2. What day of the week do most users register on?
SELECT
    COUNT(*) AS 'count',
    DAYNAME(created_at) AS 'day_of_week'
FROM users
GROUP BY day_of_week
ORDER BY count desc
LIMIT 2;

--3. Find users who have never posted a photo
SELECT username, image_url
FROM users
LEFT JOIN photos
    ON users.id = photos.user_id
WHERE image_url IS NULL;

--4. the most liked photo
SELECT 
    photos.id,
    COUNT(*) AS count
FROM photos
INNER JOIN likes
    ON likes.photo_id = photos.id
GROUP BY photos.id
ORDER BY count DESC LIMIT 5;

--5. how many times does the average user post?
SELECT (SELECT COUNT(*) FROM photos)/
(SELECT COUNT(*) FROM users) AS avg;

--6. top 5 most commonly used hashtags
SELECT
    tag_name,
    COUNT(*) as count
FROM photo_tags
JOIN tags ON tags.id = photo_tags.tag_id
GROUP BY tag_id
ORDER BY count DESC LIMIT 5;

--7. liked every single photo
SELECT 
    username, 
    COUNT(*) as count
FROM users
INNER JOIN likes ON users.id = likes.user_id
GROUP BY likes.user_id
HAVING count = (SELECT COUNT(*) FROM photos);

LEFT JOIN photos ON users.id = photos.user_id