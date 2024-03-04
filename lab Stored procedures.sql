use sakila;

-- Last lab quiestion 3
SELECT first_name, email
FROM customer
WHERE customer_id IN (
    SELECT r.customer_id
    FROM rental r
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film_category fc ON i.film_id = fc.film_id
    JOIN category cat ON fc.category_id = cat.category_id
    WHERE cat.name = 'Action'
);

-- info given
  select first_name, last_name, email
  from customer
  join rental on customer.customer_id = rental.customer_id
  join inventory on rental.inventory_id = inventory.inventory_id
  join film on film.film_id = inventory.film_id
  join film_category on film_category.film_id = film.film_id
  join category on category.category_id = film_category.category_id
  where category.name = "Action"
  group by first_name, last_name, email;
  
-- 1 Now keep working on the previous stored procedure to make it more dynamic. Update the stored procedure in a such manner that it
  --  can take a string argument for the category name and return the results for all customers that rented movie of that 
  -- category/genre. For eg., it could be action, animation, children, classics, etc.
  
DELIMITER //
CREATE PROCEDURE category_received(IN category_name VARCHAR(50), OUT result_category VARCHAR(50))
BEGIN
    SELECT first_name, last_name, email
    INTO result_category
    FROM customer
    WHERE customer_id IN (
        SELECT r.customer_id
        FROM rental r
        JOIN inventory i ON r.inventory_id = i.inventory_id
        JOIN film_category fc ON i.film_id = fc.film_id
        JOIN category cat ON fc.category_id = cat.category_id
        WHERE cat.name = category_name
    );
END //
DELIMITER ;

-- 2 Write a query to check the number of movies released in each movie category. Convert the query in to a stored procedure to filter
  --  only those categories that have movies released greater than a certain number. Pass that number as an argument in the 
  -- stored procedure.
  
SELECT name, count(category_id) AS 'Total' FROM category GROUP BY name;

DELIMITER //
CREATE PROCEDURE FilterMovieCategories(IN min_movie_count INT)
BEGIN
    SELECT c.name AS category_name, COUNT(fc.film_id) AS movie_count
    FROM category c
    LEFT JOIN film_category fc ON c.category_id = fc.category_id
    GROUP BY c.name
    HAVING movie_count > min_movie_count;
END //
DELIMITER ;
