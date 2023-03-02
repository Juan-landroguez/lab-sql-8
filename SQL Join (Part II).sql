USE sakila;


SELECT *
FROM sakila.country;

-- 1 Write a query to display for each store its store ID, city, and country.

SELECT s.store_id, c.city, co.country
FROM sakila.store s
JOIN sakila.address a
ON s.address_id = a.address_id
JOIN sakila.city c
ON a.city_id = c.city_id
JOIN sakila.country co
ON c.country_id = co.country_id;

-- 2 Write a query to display how much business, in dollars, each store brought in.

SELECT s.store_id AS store, CONCAT('$', FORMAT(sum(p.amount),2)) AS amount 
FROM store s
JOIN customer c 
ON s.store_id = c.store_id
JOIN payment p 
ON c.customer_id = p.customer_id
GROUP BY store;

-- 3 Which film categories are longest?

SELECT DISTINCT c.name, SEC_TO_TIME(AVG(length*60)) as av_duration
FROM sakila.film_category fc
JOIN sakila.category c
ON c.category_id = fc.category_id
JOIN sakila.film f
ON f.film_id = fc.film_id
GROUP BY c.name
ORDER BY av_duration DESC;


-- 4 Display the most frequently rented movies in descending order.

SELECT f.title, COUNT(r.rental_date) as times_rented
FROM film f
JOIN inventory i USING (film_id)
JOIN rental r USING (inventory_id)
GROUP BY f.title
ORDER BY times_rented DESC;

-- 5 List the top five genres in gross revenue in descending order.

SELECT c.name, SUM(p.amount) as gross_rev
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN inventory i ON fc.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY c.name
ORDER BY gross_rev DESC
LIMIT 5;

-- 6 Is "Academy Dinosaur" available for rent from Store 1?

SELECT 
CASE WHEN COUNT(*) > 0 THEN 'Yes' ELSE 'No' END AS available_for_rent
FROM rental
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
JOIN store ON inventory.store_id = store.store_id
WHERE film.title = 'Academy Dinosaur' AND store.store_id = 1;

-- 7 Get all pairs of actors that worked together.

SELECT 
  CONCAT(a1.first_name, ' ', a1.last_name) AS actor1,
  CONCAT(a2.first_name, ' ', a2.last_name) AS actor2
FROM
  film_actor fa1
  JOIN film_actor fa2 ON fa1.film_id = fa2.film_id AND fa1.actor_id <>fa2.actor_id
  JOIN actor a1 ON fa1.actor_id = a1.actor_id
  JOIN actor a2 ON fa2.actor_id = a2.actor_id
ORDER BY actor1, actor2;