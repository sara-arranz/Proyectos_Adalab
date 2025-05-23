
-- EJERCICIOS

USE sakila;

-- 1. Calcula el número total de alquíleres de cada cliente
SELECT c.first_name, c.last_name,COUNT(r.rental_id) AS num_peliculas_alquiladas
	FROM customer AS c
INNER JOIN rental AS r
	USING(customer_id)
GROUP BY c.customer_id;

-- 2. Nombre de películas más alquiladas
SELECT f.title, COUNT(r.rental_id) AS num_alquiler
	FROM film AS f
INNER JOIN inventory AS i
	USING(film_id)
INNER JOIN rental AS r
	USING(inventory_id)
GROUP BY f.title
ORDER BY num_alquiler DESC
LIMIT 5;

-- 3. Calcula el número de actores en cada categoría de película
SELECT c.`name`, COUNT(actor_id) AS num_actores
	FROM category AS c
INNER JOIN film_category AS fc
	USING(category_id)
INNER JOIN film_actor AS fa
	USING(film_id)
INNER JOIN actor AS a
	USING (actor_id)
GROUP BY  c.`name`
ORDER BY num_actores DESC;

-- 4. Calcula el promedio de alquiler total

-- Alquileres totales por cliente:
SELECT CONCAT(c.first_name," ", c.last_name) AS clientes, COUNT(r.rental_id) AS num_alquileres
	FROM customer AS c
INNER JOIN rental AS r
	USING(customer_id)
GROUP BY customer_id;
    
-- Necesitamos una subconsulta para de este resultado hacer la media:
SELECT ROUND(AVG(num_alquileres), 2) AS promedio_alquiler
FROM ( SELECT COUNT(r.rental_id) AS num_alquileres
			FROM customer AS c
			INNER JOIN rental AS r
			USING(customer_id)
			GROUP BY c.customer_id) AS alquileres_por_cliente
;

-- 5. Películas más alquiladas por categoría:
SELECT c.`name`, COUNT(rental_id) AS num_alquiler
	FROM category AS c
INNER JOIN film_category AS fc
	USING(category_id)
INNER JOIN inventory AS i
	USING(film_id)
INNER JOIN rental AS r
	USING(inventory_id)
GROUP BY category_id
ORDER BY num_alquiler DESC;

-- 6. Películas que no se han alquilado nunca:
SELECT c.`name`, COUNT(r.rental_id) AS num_alquiler
	FROM category AS c
INNER JOIN film_category AS fc 
	USING(category_id)
INNER JOIN inventory AS i 
	USING(film_id)
LEFT JOIN rental AS r -- QUEREMOS INCLUIR TODAS LAS PELÍCULAS Y NECESITAMOS LAS QUE SU RENTAL_ID SEA 0
	USING(inventory_id)
GROUP BY c.category_id
	HAVING COUNT(r.rental_id) = 0;

-- 7. Películas más recientes alquiladas: En esta consulta no es necesario agrupar por rental_id porque no estás realizando ninguna operación de agregación 
-- como COUNT(), SUM(), AVG(), o similar. 


SELECT f.title, r.rental_date
FROM film AS f
INNER JOIN inventory AS i 
    USING(film_id)
INNER JOIN rental AS r 
    USING(inventory_id)
ORDER BY r.rental_date DESC
LIMIT 10;










