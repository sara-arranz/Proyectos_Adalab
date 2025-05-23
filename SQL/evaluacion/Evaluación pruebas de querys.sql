-- EJERCICIO EVALUACIÓN

-- Base de Datos Sakila:
USE sakila;

-- EJERCICIOS:

-- 1. Selecciona todos los nombres de las películas sin que aparezcan duplicados.
SELECT DISTINCT(title)
	FROM film;

-- 2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".
SELECT title, rating
	FROM film
		WHERE rating IN ("PG-13");

-- 3. Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.
SELECT title, description AS `description`
	FROM film
		WHERE `description` LIKE '%amazing%';

-- 4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.
SELECT title, length
	FROM film
		WHERE length > 120
        ORDER BY length;

-- 5. Recupera los nombres de todos los actores.
SELECT first_name
	FROM actor;

-- Ejercicio más completo generando el nombre y apellido en una sola columna denominada 'Total_actores_actrices':
SELECT CONCAT(first_name, ' ', last_name) AS  Total_actores_actrices
	FROM actor;

-- 6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.
SELECT first_name, last_name
	FROM actor
		WHERE last_name LIKE '%Gibson%';

-- 7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.
SELECT first_name -- ,actor_id
	FROM actor
		WHERE actor_id BETWEEN 10 AND 20;

-- 8. Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su clasificación.
SELECT title -- , rating
	FROM film
		WHERE rating NOT IN ('R','PG-13');

-- 9. Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con el recuento.
SELECT rating AS Clasificacion, COUNT(title) AS Total_peliculas  
FROM film  
GROUP BY rating
ORDER BY Total_peliculas DESC;

-- 10. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad 
-- de películas alquiladas.

-- cantidad total de películas alquiladas. tabla rental, customer_id
-- por cada cliente. tabla customer, customer_id

SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) AS 'num_peliculas_alquildas'
	FROM customer AS c
INNER JOIN rental AS r
	USING (customer_id)
GROUP BY customer_id;

-- comprobación clientes: 
SELECT COUNT(customer_id)
FROM customer;

-- 11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.

SELECT *
	FROM category
INNER JOIN film_category
	USING (category_id)
INNER JOIN inventory
	USING (film_id)
INNER JOIN rental
	USING (inventory_id);

-- FILTRO EL SELECT
SELECT c.`name`, COUNT(r.rental_id) AS Total_alquiladas
	FROM category AS c
INNER JOIN film_category AS fc
	USING (category_id)
INNER JOIN inventory AS i
	USING (film_id)
INNER JOIN rental AS r
	USING (inventory_id)

GROUP BY  c.`name`
ORDER BY Total_alquiladas DESC;

-- 12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.

-- promedio duración películas- tabla film (length)
-- clasificacion de las peliculas - tabla film (rating)

SELECT rating AS clasificación, ROUND(AVG(length),2) AS duración_media
	FROM film
    GROUP BY rating
    ORDER BY duración_media DESC;

-- 13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".

-- nombre y apellidos de actores = tabla actor, first_name, last_name
-- película 'Indian Love' = tabla film, title
-- como conectar films con actor = tabla intermedia film_actor

SELECT *
	FROM actor AS a
INNER JOIN film_actor AS fa
	USING (actor_id)
INNER JOIN film AS f
	USING(film_id);

-- Limpio el select y filtro la película

SELECT a.first_name, a.last_name -- , f.title
	FROM actor AS a
INNER JOIN film_actor AS fa
	USING (actor_id)
INNER JOIN film AS f
	USING(film_id)
    WHERE title = 'Indian Love';

-- 14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.

SELECT title -- , `description`
FROM film
	WHERE `description`LIKE '%DOG%' OR `description`LIKE '%CAT%';
    
-- 15. Hay algún actor o actriz que no aparezca en ninguna película en la tabla film_actor.
SELECT a.first_name, a.last_name
	FROM actor AS a
LEFT JOIN film_actor AS fa -- comparo todos los actores con el id_film
	USING (actor_id)
    WHERE fa.film_id IS NULL;
    
-- Comprobación query:
SELECT a.first_name, a.last_name, fa.film_id
	FROM actor AS a
LEFT JOIN film_actor AS fa
	USING (actor_id);

-- 16. Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.
SELECT title, release_year
FROM film
	WHERE release_year BETWEEN 2005 AND 2010;

-- 17. Encuentra el título de todas las películas que son de la misma categoría que "Family".
SELECT f.title -- ,c.`name`
	FROM film AS f
INNER JOIN film_category AS fc
	USING(film_id)
INNER JOIN category AS c
	USING(category_id)
    WHERE c.`name`= 'Family';

-- 18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.

SELECT a.first_name, a.last_name, COUNT(film_id) AS num_peliculas
	FROM actor AS a
INNER JOIN film_actor AS fa
	USING (actor_id)
INNER JOIN film AS f
	USING (film_id)
GROUP BY a.actor_id
		HAVING COUNT(f.film_id)>10
        ORDER BY num_peliculas DESC;

-- 19. Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film.

SELECT title, rating AS categoria, length AS duracion
	FROM film
    WHERE rating = 'R' AND length > 120
    ORDER BY length DESC;

-- 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y
-- muestra el nombre de la categoría junto con el promedio de duración.

SELECT c.`name`, ROUND(AVG(length),2) AS duracion_media
	FROM film AS f
INNER JOIN film_category AS fc
	USING(film_id)
INNER JOIN category AS c
	USING(category_id)
GROUP BY category_id
    HAVING AVG(f.length) > 120;

-- Compruebo las categorias existentes
SELECT `name`
FROM category;
-- Si el ejercicio pidiera mostrar todas las categrías debería usar un LEFT JOIN. 

-- 21. Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto
-- con la cantidad de películas en las que han actuado.

-- actores = tabla actor (actor_id)
-- actuación en películas = tabla film_actor (actor_id, film_id)

SELECT a.first_name, a.last_name, COUNT(fa.film_id) AS num_peliculas
	FROM actor AS a
INNER JOIN film_actor AS fa
	USING(actor_id)
GROUP BY a.actor_id
HAVING num_peliculas >= 5
ORDER BY num_peliculas DESC;

-- 22. Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. Utiliza una
-- subconsulta para encontrar los rental_ids con una duración superior a 5 días y luego selecciona las películas correspondientes.

-- encontrar los rental_ids con una duración superior a 5 días = tabla rental, rental_id, rental_date, return_date
SELECT rental_id, DATEDIFF(return_date, rental_date) AS "dias_alquiler"
	FROM rental
    WHERE  DATEDIFF(return_date, rental_date) > 5
    ORDER BY dias_alquiler;

-- películas que fueron alquiladas = tabla film, film_id
-- alquiler mayor de 5 días = rental, inventory_id
-- necesito conectar ambas tablas con la tabla inventory, inventory_id, film_id

SELECT f.title, DATEDIFF(r.return_date, r.rental_date) AS dias_alquiler
	FROM film AS f
INNER JOIN inventory AS i
	USING(film_id)
INNER JOIN rental AS r
	USING(inventory_id)
		WHERE r.rental_id IN (SELECT rental_id
								FROM rental
								WHERE  DATEDIFF(return_date, rental_date) > 5)
ORDER BY dias_alquiler;


-- 23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror". 
-- Utiliza una subconsulta para encontrar los actores que han actuado en películas de la categoría "Horror" y luego exclúyelos de la lista de actores.


-- en películas de la categoría "Horror" = tabla film (film_id) + tabla film_category (film_id, category_id) + tabla category (category_id, name = horror)
SELECT c.`name` AS categoria, f.title AS pelicula
	FROM film AS f
INNER JOIN film_category AS fc
	USING(film_id)
INNER JOIN category AS c
	USING(category_id)
		WHERE c.`name`= 'horror';

-- -- actores que NO han actuado en películas = tabla actor (first_name, last_name, actor_id) + film_actor (actor_id, film_id) + film (film_id, title)
SELECT a.first_name, a.last_name
	FROM actor AS a
INNER JOIN film_actor AS fa
	USING(actor_id)
INNER JOIN film AS f
	USING(film_id)
		WHERE film_id NOT IN (SELECT f.film_id
							FROM film AS f
						INNER JOIN film_category AS fc
							USING(film_id)
						INNER JOIN category AS c
							USING(category_id)
						WHERE c.`name`= 'horror')
;

-- si quisiera ver la categoría de las películas para comprobar el reultado tendría que incluir los inner join de las tablas categorías
-- en la consulta principal. 

SELECT a.first_name, a.last_name, f.title, c.`name` AS category
	FROM actor AS a
INNER JOIN film_actor AS fa 
	USING(actor_id)
INNER JOIN film AS f 
	USING(film_id)
INNER JOIN film_category AS fc 
	USING(film_id)
INNER JOIN category AS c 
	USING(category_id)
		WHERE f.film_id NOT IN (SELECT f.film_id
									FROM film AS f
								INNER JOIN film_category AS fc 
									USING(film_id)
								INNER JOIN category AS c 
									USING(category_id)
										WHERE c.`name` = 'horror')
;

-- USO DE CTE 

WITH peliculas_horror AS (SELECT f.film_id
							FROM film AS f
							INNER JOIN film_category AS fc 
								USING(film_id)
							INNER JOIN category AS c 
								USING(category_id)
									WHERE c.name = 'horror'
)

SELECT a.first_name, a.last_name, f.title, c.`name` AS category
	FROM actor AS a
INNER JOIN film_actor AS fa 
	USING(actor_id)
INNER JOIN film AS f 
	USING(film_id)
INNER JOIN film_category AS fc 
	USING(film_id)
INNER JOIN category AS c 
	USING(category_id)
WHERE f.film_id NOT IN (SELECT film_id FROM peliculas_horror);


-- 24. Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en
-- la tabla film.

SELECT f.title, c.`name` AS categoría, f.length AS duración
	FROM film AS f
INNER JOIN film_category AS fc 
	USING(film_id)
INNER JOIN category AS c 
	USING(category_id)
WHERE c.`name` = 'Comedy' AND f.length > 180;

-- En esta consulta no es necesario usar GROUP BY porque no estamos realizando ningún tipo de agregación, es decir, 
-- no estamos calculando promedios, sumas, ni cualquier otro tipo de cálculo agregado sobre los datos.










    
    
    