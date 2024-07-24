
use mavenmovies;
-- **Join Practice:**
-- Write a query to display the customer's first name, last name, email, and city they live in.
-- List columns in the customer table
SELECT 
    c.first_name,
    c.last_name,
    c.email,
    ci.city
FROM 
    customer c
JOIN 
    address a ON c.address_id = a.address_id
JOIN 
    city ci ON a.city_id = ci.city_id;
    
    -- Q2 -- **Subquery Practice (Single Row):**
-- Retrieve the film title, description, and release year for the film that has the longest duration.
    
    SELECT title, description, release_year FROM  film WHERE length = (SELECT MAX(length) FROM film);
    
    -- Q3 -- **Join Practice (Multiple Joins):**
-- List the customer name, rental date, and film title for each rental made. Include customers who have never
-- rented a film.

SELECT 
    c.first_name,
    c.last_name,
    r.rental_date,
    f.title
FROM 
    customer c
LEFT JOIN 
    rental r ON c.customer_id = r.customer_id
LEFT JOIN 
    inventory i ON r.inventory_id = i.inventory_id
LEFT JOIN 
    film f ON i.film_id = f.film_id
ORDER BY 
    c.customer_id, r.rental_date;
    
    -- Q4. **Subquery Practice (Multiple Rows):**
-- Find the number of actors for each film. Display the film title and the number of actors for each film.
SELECT 
    f.title,
    COUNT(fa.actor_id) AS number_of_actors
FROM 
    film f
LEFT JOIN 
    film_actor fa ON f.film_id = fa.film_id
GROUP BY 
    f.film_id, f.title;
    
    -- 5. **Join Practice (Using Aliases):**
-- Display the first name, last name, and email of customers along with the rental date, film title, and rental
-- return date.
SELECT 
    c.first_name AS first_name,
    c.last_name AS last_name,
    c.email AS email,
    r.rental_date AS rental_date,
    f.title AS film_title,
    r.return_date AS return_date
FROM 
    customer c
JOIN 
    rental r ON c.customer_id = r.customer_id
JOIN 
    inventory i ON r.inventory_id = i.inventory_id
JOIN 
    film f ON i.film_id = f.film_id;
    
    -- Q6 -- . **Subquery Practice (Conditional):**
-- Retrieve the film titles that are rented by customers whose email domain ends with '.net'.

SELECT 
    f.title
FROM 
    film f
JOIN 
    inventory i ON f.film_id = i.film_id
JOIN 
    rental r ON i.inventory_id = r.inventory_id
JOIN 
    customer c ON r.customer_id = c.customer_id
WHERE 
    c.email LIKE '%.net';
    
    -- Q7. **Join Practice (Aggregation):**
-- Show the total number of rentals made by each customer, along with their first and last names. 

SELECT 
    c.first_name,
    c.last_name,
    COUNT(r.rental_id) AS total_rentals
FROM 
    customer c
LEFT JOIN 
    rental r ON c.customer_id = r.customer_id
GROUP BY 
    c.customer_id, c.first_name, c.last_name;
    
    -- Q8. **Subquery Practice (Aggregation):**
-- List the customers who have made more rentals than the average number of rentals made by all
-- customers.

SELECT 
    c.first_name,
    c.last_name,
    COUNT(r.rental_id) AS rental_count
FROM 
    customer c
JOIN 
    rental r ON c.customer_id = r.customer_id
GROUP BY 
    c.customer_id, c.first_name, c.last_name
HAVING 
    COUNT(r.rental_id) > (
        SELECT AVG(rental_count)
        FROM (
            SELECT 
                COUNT(r.rental_id) AS rental_count
            FROM 
                rental r
            GROUP BY 
                r.customer_id
        ) AS rental_counts
    );
    
    -- 9. **Join Practice (Self Join):**
-- Display the customer first name, last name, and email along with the names of other customers living in
-- the same city.
SELECT 
    c1.first_name AS customer_first_name,
    c1.last_name AS customer_last_name,
    c1.email AS customer_email,
    c2.first_name AS other_customer_first_name,
    c2.last_name AS other_customer_last_name,
    c2.email AS other_customer_email
FROM 
    customer c1
JOIN 
    address a1 ON c1.address_id = a1.address_id
JOIN 
    city ci ON a1.city_id = ci.city_id
JOIN 
    address a2 ON ci.city_id = a2.city_id
JOIN 
    customer c2 ON a2.address_id = c2.address_id
WHERE 
    c1.customer_id <> c2.customer_id;
    
    -- 10. **Subquery Practice (Correlated Subquery):**
-- Retrieve the film titles with a rental rate higher than the average rental rate of films in the same category.
SELECT 
    f.title, 
    f.rental_rate
FROM 
    film f
JOIN 
    film_category fc ON f.film_id = fc.film_id
WHERE 
    f.rental_rate > (
        SELECT AVG(f1.rental_rate)
        FROM film f1
        JOIN film_category fc1 ON f1.film_id = fc1.film_id
        WHERE fc1.category_id = (
            SELECT fc2.category_id
            FROM film_category fc2
            WHERE fc2.film_id = f.film_id
        )
    );
    
    -- Q11. **Subquery Practice (Nested Subquery):**
-- Retrieve the film titles along with their descriptions and lengths that have a rental rate greater than the
-- average rental rate of films released in the same year. 
SELECT 
    f.title,
    f.description,
    f.length
FROM 
    film f
WHERE 
    f.rental_rate > (
        SELECT AVG(f1.rental_rate)
        FROM film f1
        WHERE f1.release_year = f.release_year
    );
    
    -- Q12. **Subquery Practice (IN Operator):**
-- List the first name, last name, and email of customers who have rented at least one film in the
-- 'Documentary' category.
SELECT 
    c.first_name,
    c.last_name,
    c.email
FROM 
    customer c
WHERE 
    c.customer_id IN (
        SELECT r.customer_id
        FROM rental r
        JOIN inventory i ON r.inventory_id = i.inventory_id
        JOIN film f ON i.film_id = f.film_id
        JOIN film_category fc ON f.film_id = fc.film_id
        JOIN category cat ON fc.category_id = cat.category_id
        WHERE cat.name = 'Documentary'
    );
  
  
  -- Q13. **Subquery Practice (Scalar Subquery):**
-- Show the title, rental rate, and difference from the average rental rate for each film.

SELECT 
    f.title,
    f.rental_rate,
    f.rental_rate - (
        SELECT AVG(f1.rental_rate)
        FROM film f1
    ) AS rate_difference
FROM 
    film f;
    
    -- Q14. **Subquery Practice (Existence Check):**
-- Retrieve the titles of films that have never been rented.
SELECT 
    f.title
FROM 
    film f
WHERE 
    NOT EXISTS (
        SELECT 1
        FROM rental r
        JOIN inventory i ON r.inventory_id = i.inventory_id
        WHERE i.film_id = f.film_id
    );
    
    -- Q 15. **Subquery Practice (Correlated Subquery - Multiple Conditions):**
-- List the titles of films whose rental rate is higher than the average rental rate of films released in the same
-- year and belong to the 'Sci-Fi' category.

SELECT 
    f.title
FROM 
    film f
JOIN 
    inventory i ON f.film_id = i.film_id
JOIN 
    rental r ON i.inventory_id = r.inventory_id
JOIN 
    film_category fc ON f.film_id = fc.film_id
JOIN 
    category cat ON fc.category_id = cat.category_id
WHERE 
    cat.name = 'Sci-Fi'
    AND f.rental_rate > (
        SELECT AVG(f1.rental_rate)
        FROM film f1
        JOIN film_category fc1 ON f1.film_id = fc1.film_id
        JOIN category cat1 ON fc1.category_id = cat1.category_id
        WHERE f1.release_year = f.release_year
        AND cat1.name = 'Sci-Fi'
    )
GROUP BY 
    f.title;
    
    -- 16. **Subquery Practice (Conditional Aggregation):**
-- Find the number of films rented by each customer, excluding customers who have rented fewer than five
-- films.
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(r.rental_id) AS number_of_films_rented
FROM 
    customer c
JOIN 
    rental r ON c.customer_id = r.customer_id
GROUP BY 
    c.customer_id, c.first_name, c.last_name
HAVING 
    COUNT(r.rental_id) >= 5;