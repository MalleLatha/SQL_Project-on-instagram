-- Find the actors who have acted in the film ‘Frost Head.’
SELECT * FROM mavenmovies;

SELECT * FROM mavenmovies.actor;
-- question 1
-- Write a SQL query to count the number of characters except for the spaces for each actor. Return the first 10 actors' name lengths along with their names


select concat (first_name,'',last_name) as actor_name ,
 length(concat (first_name,'',last_name)) as  length from actor
 limit 10;
 
 

 
 -- List all Oscar awardees(Actors who received the Oscar award) with their full names and the length of their names
 


 select concat(first_name,'',last_name) as full_names,
 length (concat(first_name,'',last_name)) as length ,AWARDS From actor_award
 AWARDS WHERE awards LIKE '%OSCAR%'; 
 
 
  -- Find the actors who have acted in the film ‘Frost Head.’
  
 SELECT * FROM mavenmovies;
select concat (first_name,'',last_name) as actors , title from actor
inner join film_actor on actor.actor_id = film_actor.actor_id
inner join film on  film.film_id = film_actor.film_id 
where title ='frost head';

-- Pull all the films acted by the actor ‘Will Wilson.’
select concat(First_name,'',Last_name) as actor,title from film 
inner join  film_actor on film.film_id = film_actor. film_id
inner join actor on film_actor.actor_id = actor.actor_id
where first_name='will' and last_name='wilson';

-- Pull all the films which were rented and return them in the month of May.

select title,rental_date,return_date,description from film
inner join  inventory on film.film_id = inventory.film_id
inner join rental on inventory.inventory_id = rental.inventory_id
where month(rental.rental_date)= 5 and month( rental.return_date)=5;


-- Pull all the films with ‘Comedy’ category.
select title,description ,category.name from film
inner join film_category on film.film_id = film_category.film_id
inner join category on film_category.category_id = category.category_id
where category.name ='comedy';

SELECT * FROM ig_clone.users;
-- 1...How many times does the average user post?
select count(*) from photos;
select count(*)from users;
select
(select count(*) from photos)/(select count(*)from users) as avg;

-- 2.... Find the top 5 most used hashtags.

SELECT tag_name,COUNT(*) AS total
FROM tags
JOIN photo_tags ON tags.id = photo_tags.tag_id
GROUP BY tags.id
ORDER BY total DESC
LIMIT 5;

-- 3... Find users who have liked every single photo on the site.
SELECT username
FROM users
JOIN likes
	ON users.id = likes.user_id
GROUP BY user_id
HAVING COUNT(*) = (SELECT COUNT(*) FROM photos);


-- 4..  Retrieve a list of users along with their usernames and the rank of their account creation, ordered by the creation date in ascending order..
select username , CREATED_AT, RANK() OVER(ORDER BY CREATED_AT) RANKING from users
order by creatED_at ASC;


-- 5..  List the comments made on photos with their comment texts, photo URLs, and usernames of users who posted the comments. Include the comment count for each photo


SELECT
    P.image_url,
    U.username,
    C.comment_text,
    COUNT(C.id) AS comment_count
FROM
    Photos P
JOIN
    Comments C ON P.id = C.photo_id
JOIN
    Users U ON C.user_id = U.id
GROUP BY
    P.id, P.image_url, U.username, C.comment_text;
    
    
  -- 6.. For each tag, show the tag name and the number of photos associated with that tag. Rank the tags by the number of photos in descending order.  
    
    
    SELECT
    tag_name,
    photo_count,
    RANK() OVER (ORDER BY photo_count DESC) ranking
FROM (
    SELECT
        T.tag_name,
        COUNT(PT.photo_id) AS photo_count
    FROM
        Tags T
    JOIN
        Photo_Tags PT ON T.id = PT.tag_id
    GROUP BY
        T.tag_name
) AS tag_photo_counts
ORDER BY
    photo_count DESC;

-- 7..List the usernames of users who have posted photos along with the count of photos they have posted. Rank them by the number of photos in descending order.    
    SELECT
    username,
    photo_count,
    RANK() OVER (ORDER BY photo_count DESC) AS ranking
FROM (
    SELECT
        U.username,
        COUNT(P.id) AS photo_count
    FROM
        Users U
    JOIN
        Photos P ON U.id = P.user_id
    GROUP BY
        U.username
) AS user_photo_counts
ORDER BY
    photo_count DESC;
    
    -- 8.. Display the username of each user along with the creation date of their first posted photo and the creation date of their next posted photo.
        
        WITH UserPhotoDetails AS (
    SELECT
        U.username,
        P.created_at,
        LEAD(P.created_at) OVER (PARTITION BY U.id ORDER BY P.created_at) AS next_photo_creation_date
    FROM
        Users U
    JOIN
        Photos P ON U.id = P.user_id
)
SELECT
    UPD.username,
    UPD.created_at AS first_photo_creation_date,
    UPD.next_photo_creation_date
FROM
    UserPhotoDetails UPD
WHERE
    UPD.created_at = (SELECT MIN(created_at) FROM UserPhotoDetails WHERE username = UPD.username)
ORDER BY
    UPD.username, UPD.created_at;

        
    -- 9.. For each comment, show the comment text, the username of the commenter, and the comment text of the previous comment made on the same photo.;
WITH CommentDetails AS (
    SELECT
        C.comment_text,
        U.username,
        P.id,
        LAG(C.comment_text) OVER (PARTITION BY P.id ORDER BY C.created_at) AS previous_comment_text
    FROM
        Comments C
    JOIN
        Users U ON C.user_id = U.id
    JOIN
        Photos P ON C.photo_id = P.id
)
SELECT
    comment_text,
    username,
    previous_comment_text
FROM
    CommentDetails;
    -- 10..  Show the username of each user along with the number of photos they have posted and the number of photos posted by the user before them and after them, based on the creation date.
   with photocount as
(
select user.username, 
count(p.id) as photo_count,
lag(count(p.id))over (order by user.created_at) as previouscount,
lead(count(p.id )) over(order by user.created_at) as nextcount
from users user
join photos p on user.id = p.user_id
group by user.username
)
select username, photo_count,previouscount,nextcount from photocount; 
    














 
 