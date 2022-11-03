--.     abre la base de datos:  sqlite3 imdb-large.sqlite3.db

--.  Esos comandos van en la temrinal:
--.     .mode column
--.     .headers on


--1.Buscá todas las películas filmadas en el año que naciste.
select * from movies where year = 1996 limit 30;

--2.Cuantas películas hay en la DB que sean del año 1982?
select COUNT(*) from movies where year = 1982;

--3.Buscá actores que tengan el substring stack en su apellido.
select * from actors where last_name like '%stack%';

--.4 Buscá los 10 nombres y apellidos más populares entre los actores. Cuantos actores tienen cada uno de esos nombres y apellidos?

select first_name,
    last_name,
    COUNT(*) AS total
from actors
group by LOWER(first_name),
    LOWER(last_name)
order by total DESC
LIMIT 10;

--. 5 Listá el top 100 de actores más activos junto con el número de roles que haya realizado.

select actors.first_name,
    actors.last_name,
    COUNT(*) AS total
FROM actors
    JOIN roles ON actors.id = roles.actor_id
GROUP BY actors.id
ORDER BY total DESC 
LIMIT 20;

--.6 Cuantas películas tiene IMDB por género? Ordená la lista por el género menos popular.

SELECT genre,
    COUNT(*) AS total
FROM movies_genres
GROUP BY genre
ORDER BY total;

--.7 Listá el nombre y apellido de todos los actores que trabajaron en la película "Braveheart" de 1995, ordená la lista alfabéticamente por apellido.

SELECT actors.first_name, actors.last_name
FROM actors
    JOIN roles ON actors.id = roles.actor_id
    JOIN movies ON movies.id = roles.movie_id
WHERE movies.name = 'Braveheart' AND movies.year = 1995 ORDER BY actors.last_name;

--.8 Listá todos los directores que dirigieron una película de género 'Film-Noir' en un año bisiesto (para reducir la complejidad, asumí que cualquier año divisible por cuatro es bisiesto). Tu consulta debería devolver el nombre del director, el nombre de la peli y el año. Todo ordenado por el nombre de la película.

select d.first_name, d.last_name, m.name, m.year -- lo que necesitamos
from directors as d 
join movies_directors as md on md.director_id = d.id -- director unimos con movie_dir
join movies as m on m.id = md.movie_id --  movie_director con movie 
join movies_genres as mg on m.id = mg.movie_id -- movie con generos
where mg.genre = 'Film-Noir' and m.year % 4 = 0 -- las condiciones
order by m.name; -- ordenado por nombre

--.9 Listá todos los actores que hayan trabajado con Kevin Bacon en películas de Drama (incluí el título de la peli). Excluí al señor Bacon de los resultados.

--usamos uns subQuery 
-- actors -- roles -- movies -- movies_genre


select m.id
from movies as m
join roles as r on m.id = r.movie_id
join actors as a on r.actor_id = a.id
where a.first_name = 'Kevin' and a.last_name = 'Bacon';

select distinct a.first_name, a.last_name, m.name
from actors as a 
join roles as r on a.id = r.actor_id
join movies as m on r.movie_id = m.id
join movies_genres as mg on m.id = mg.movie_id
where mg.genre = 'Drama' and m.id in (
    select m.id
from movies as m
join roles as r on m.id = r.movie_id
join actors as a on r.actor_id = a.id
where a.first_name = 'Kevin' and a.last_name = 'Bacon'
)
and (a.first_name || ' ' || a.last_name != 'Kevin Bacon')
order by a.last_name;

-- 10. Qué actores actuaron en una película antes de 1900 y también en una película después del 2000?
select r.actor_id
from roles as r
join movies as m on r.movie_id = m.id
where m.year < 1900 limit 20;

select * from actors
where id in (
    select r.actor_id
from roles as r
join movies as m on r.movie_id = m.id
where m.year < 1900 
) and id in (
    select r.actor_id
from roles as r
join movies as m on r.movie_id = m.id
where m.year > 2000
) limit 20;

-- 11. Buscá actores que actuaron en cinco o más roles en la misma película después del año 1990. Noten que los ROLES pueden tener duplicados ocasionales, sobre los cuales no estamos interesados: queremos actores que hayan tenido cinco o más roles DISTINTOS (DISTINCT cough cough) en la misma película. Escribí un query que retorne los nombres del actor, el título de la película y el número de roles (siempre debería ser > 5).
select  a.first_name, a.last_name, m.name, count(distinct (role)) as total_roles
from actors as a 
join roles as r on a.id = r.actor_id
join movies as m on r.movie_id = m.id
where m.year > 1990 
group by a.id, m.id
having total_roles > 5;

-- 12. Para cada año, contá el número de películas en ese años que sólo tuvieron actrices femeninas.
select r.movie_id
from roles as r
join actors as a on r.actor_id = a.id
where a.gender = 'M'

select year, count(id) as total
from movies
where id not in (
    select r.movie_id
from roles as r
join actors as a on r.actor_id = a.id
where a.gender = 'M'
)
group by year limit 30;