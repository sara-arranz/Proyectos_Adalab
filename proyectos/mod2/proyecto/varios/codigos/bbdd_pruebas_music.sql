-- 1. CREO COPIA DE LA BBDD ORIGINAL PARA LAS PRUEBAS Y NO MODIFICAR LOS DATOS DE LA ORIGINAL

CREATE DATABASE bbdd_pruebas_music;

CREATE TABLE bbdd_pruebas_music.lastfm AS SELECT * FROM music_stream_proyecto2 .artist_get_info_lastfm;
CREATE TABLE bbdd_pruebas_music.spotipy AS SELECT * FROM music_stream_proyecto2.tracks_spoty;

-- 2. VISUALIZACIÓN

USE bbdd_pruebas_music;
SELECT * 
FROM lastfm; -- 4118 líneas de artistas

-- 3. VISUALIZAR ARTISTAS DUPLICADOS: 

SELECT artist, COUNT(*) AS total
FROM lastfm
GROUP BY artist
HAVING total > 1; -- 951 artistas repetidos

-- PARA VISUALIZAR LOS nombres de los artistas que se repiten, mostrando cuántas veces se repiten

SELECT artist, COUNT(*)
FROM lastfm
GROUP BY artist
HAVING COUNT(*) > 1
ORDER BY COUNT(*) DESC; -- 951 filas

SELECT COUNT(*) 
FROM lastfm
WHERE artist IS NULL OR TRIM(artist) = ''; -- 0


-- 4. PARA ELIMINAR LOS DUPLICADOS CREAMOS TABLAS NUEVAS

-- Si el problema es que hay diferencias en mayúsculas/minúsculas o espacios, puedes "normalizar" los nombres de los artistas antes de aplicar DISTINCT

CREATE TABLE artistas_sin_duplicados 
SELECT DISTINCT TRIM(LOWER(artist)) AS artist
FROM lastfm; -- 2080 resultados

-- LOWER(artist): Convierte todos los nombres de los artistas a minúsculas.
-- TRIM(artist): Elimina los espacios en blanco al inicio y al final del nombre.

-- 5. Asegurarse de que los registros duplicados sean eliminados correctamente
-- Si el problema persiste, puedes intentar una estrategia diferente para eliminar duplicados, 
-- como asegurarte de que solo se guarde una fila por artista manteniendo un id único:

CREATE TABLE artistas_sin_duplicados 
SELECT artist, MIN(id) AS id
FROM lastfm
GROUP BY artist;

-- COMO NO TENEMOS ID:
CREATE TABLE artistas_sin_duplicados AS
SELECT artist
FROM lastfm
GROUP BY artist; -- Nuevamente devuelve 2080 artistas

-- Comprobación:
SELECT COUNT(DISTINCT artist)
FROM artistas_sin_duplicados; -- 2080

SELECT artist
FROM artistas_sin_duplicados;

-- 6. AHORA NECESITO COPIAR TODAS LAS COLUMNAS CON LOS DATOS AFECTADOS DE ESA DUPLICIDAD:

CREATE TABLE artistas_sin_duplicados AS
SELECT artist, MIN(listeners) AS oyentes, MIN(playcount) AS reproducciones, MAX(bio_content) AS biografia
FROM lastfm
GROUP BY artist;

SELECT artist, COUNT(*)
FROM artistas_sin_duplicados
GROUP BY artist,oyentes,reproducciones,biografia
HAVING COUNT(*) > 1; -- 0

-- 7. BÚSQUEDA DE NULOS

SELECT 
    COUNT(*) - COUNT(artist) AS null_artist,
    COUNT(*) - COUNT(oyentes) AS null_genre,
    COUNT(*) - COUNT(reproducciones) AS null_album,
    COUNT(*) - COUNT(biografia) AS null_year
FROM artistas_sin_duplicados; -- NO HAY VALORES NULOS

-- 8. BÚSQUEDA DE COLUMNAS SIN DATOS

SELECT *
FROM artistas_sin_duplicados
WHERE biografia IS NULL OR TRIM(biografia) = ''; -- 417 sin biografia

SELECT *
FROM artistas_sin_duplicados
WHERE oyentes IS NULL OR TRIM(oyentes) = ''; -- 0

SELECT *
FROM artistas_sin_duplicados
WHERE reproducciones IS NULL OR TRIM(reproducciones) = ''; -- 0

SELECT *
FROM artistas_sin_duplicados
WHERE artist IS NULL OR TRIM(artist) = ''; -- 0

-- CUESTIONES

-- ¿Géneros que aumentaron/disminuyeron en popularidad?

SELECT YEAR(release_date) AS year, genero, 
       ROUND (AVG(popularity),2) AS avg_popularity,
       MAX(popularity) AS max_popularity
FROM spotipy
GROUP BY YEAR(release_date), genero
ORDER BY YEAR, avg_popularity DESC;

-- SEGÚN EL RESULTADO LA POPULARIDAD SE MANTIENE A LO LARGO DE LOS AÑOS EN POP, RAO, INDIE Y REGGEATEON
-------------------------------------------------------

-- ¿Artistas que se mantuvieron en el tiempo vs. artistas emergentes?
-- Artistas consolidados → Aquellos que han lanzado música en varios años diferentes.
-- Artistas emergentes → Aquellos que solo tienen música en un solo año.

SELECT artist_name, 
       COUNT(DISTINCT YEAR(release_date)) AS num_years,
       CASE 
           WHEN COUNT(DISTINCT YEAR(release_date)) > 2 THEN 'Consolidado'
           ELSE 'Emergente'
       END AS categoria,
       MIN(release_date) AS first_release_date,  -- Primera fecha de lanzamiento del artista
       genero  
FROM spotipy
GROUP BY artist_name,genero
ORDER BY num_years DESC;

-- -- ---- PARA EVITAR TENER EN CUENTA LAS CANCIONES DE COLABORACIÓN. PERO NO FUNCIONA BIEN
SELECT s.artist_name, 
       COUNT(DISTINCT YEAR(s.release_date)) AS año,
       CASE 
           WHEN COUNT(DISTINCT YEAR(s.release_date)) > 1 THEN 'Consolidado'
           ELSE 'Emergente'
       END AS categoria
FROM spotipy s

JOIN (SELECT track_name
		FROM spotipy
		GROUP BY track_name
		HAVING COUNT(DISTINCT artist_name) = 1) AS cancion_artista

ON s.track_name = cancion_artista.track_name
GROUP BY s.artist_name
ORDER BY año DESC;

-- ¿Cuál género fue el más valorado durante la Pandemia?

-- Filtrar por los años de la pandemia: Limitar los datos a los años 2020 y 2021.
-- Obtener la popularidad por género: Podemos usar la media de popularidad (AVG(popularity))
-- Agrupar por género y ordenar por popularidad: Esto nos permitirá ver cuál fue el género más popular durante este periodo.

SELECT genero, YEAR(release_date), MAX(popularity) AS max_pop
FROM spotipy
WHERE YEAR (release_date) IN (2019, 2020, 2021)
GROUP BY genero, YEAR (release_date)
ORDER BY max_pop DESC;

-- ¿En qué año se han lanzado más canciones?

SELECT YEAR(release_date) AS año, 
       COUNT(*) AS canciones
FROM spotipy
GROUP BY año
ORDER BY canciones DESC -- Ordenamos los resultados en orden descendente, para que el año con más canciones aparezca primero.
LIMIT 5; --  Limitamos el resultado a los 5 años, para hacer la comparación.


-- ¿Cuál fue la canción más valorada durante la Pandemia? ¿Y en la actualidad?
SELECT track_name, artist_name, popularity, release_date, genero
FROM spotipy
WHERE YEAR (release_date) BETWEEN 2019 AND 2024
ORDER BY popularity DESC
LIMIT 50;

SELECT track_name, artist_name, popularity, release_date, genero
FROM spotipy
WHERE YEAR (release_date) BETWEEN 2019 AND 2020
ORDER BY popularity DESC
LIMIT 1;

SELECT track_name, artist_name, popularity, release_date, genero
FROM spotipy
WHERE YEAR (release_date) IN ('2024')
ORDER BY popularity DESC
LIMIT 1;

-- ¿Se consumió más música durante la Pandemia?

SELECT genero,YEAR(release_date) AS año, 
       COUNT(*) AS num_canciones, 
       AVG(popularity) AS popularidad_media
FROM spotipy
WHERE YEAR(release_date) BETWEEN 2019 AND 2021  
GROUP BY año, genero
ORDER BY año;

-- Artistas del 2019 que aún tienenoyentes en la actualidad: 521

SELECT DISTINCT s.artist_name
FROM spotipy s
JOIN artistas_sin_duplicados a ON s.artist_name = a.artist
WHERE YEAR(s.release_date) IN (2019);

-- Quien de estos artistas es el más popular en la actualidad

-- Filtrar los artistas de 2019 que también existen en la tabla artistas_sin_duplicados, es decir, en los datos de last_fm.

SELECT s.artist_name, MAX(s.popularity) AS max_popularidad
FROM spotipy s

JOIN artistas_sin_duplicados a 
ON s.artist_name = a.artist
	WHERE YEAR(s.release_date) IN ('2019')
    
GROUP BY s.artist_name
ORDER BY max_popularidad DESC;

-- Comparativa de la popularidad de los artistas más escuchados en 2019 con su número de oyentes en la actualidad

SELECT s.popularity, s.artist_name, a.artist, a.oyentes
	FROM spotipy AS s
    
JOIN artistas_sin_duplicados AS a
ON s.artist_name = a.artist

	WHERE YEAR (s.release_date) = 2019
    AND s.popularity > 50 AND a.oyentes > 0

ORDER BY s.popularity DESC
LIMIT 50;


SELECT s.artist_name, MAX(s.popularity) AS max_popularidad
FROM spotipy s

JOIN artistas_sin_duplicados a 
ON s.artist_name = a.artist
	WHERE YEAR(s.release_date) IN ('2019')
    
GROUP BY s.artist_name
ORDER BY max_popularidad DESC;

-- Comparativa de la popularidad de los artistas más escuchados en 2019 con su número de oyentes en la actualidad

SELECT s.popularity, s.artist_name, a.artist, a.oyentes, s.genero
	FROM spotipy AS s
    
JOIN artistas_sin_duplicados AS a
ON s.artist_name = a.artist

	WHERE YEAR (s.release_date) BETWEEN 2019 AND 2022
    AND s.popularity > 50 AND a.oyentes > 0

ORDER BY s.popularity DESC, s.genero
LIMIT 50;

-- Comparativa del genero reggeateon

SELECT YEAR(release_date), ROUND(AVG(popularity),2), COUNT(track_name)
FROM spotipy
WHERE genero IN ('reggaeton') 
GROUP BY YEAR(release_date);

--  Consulta sobre el Consumo de Música y el Impacto de la Pandemia

-- Para estudiar el impacto en la música, puedes hacer comparaciones entre el consumo de música antes y durante la pandemia, 
-- especialmente entre los años 2019, 2020, y 2021.

-- Ejemplo de consulta para comparar el consumo (popularidad de canciones y géneros):

SELECT YEAR(s.release_date) AS year, 
       s.genero, 
       AVG(s.popularity) AS avg_popularity,
       COUNT(s.track_name) AS num_tracks,
       SUM(a.oyentes) AS total_listeners
FROM spotipy s
JOIN artistas_sin_duplicados a ON s.artist_name = a.artist
WHERE YEAR(s.release_date) IN (2019, 2020, 2021, 2022, 2024)
GROUP BY YEAR(s.release_date), s.genero
ORDER BY year, avg_popularity DESC;

