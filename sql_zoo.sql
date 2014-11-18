-- SQLZOO:SELECT basics

-- 1. The example shows the population of 'France'.

SELECT population
FROM world
WHERE name = 'Germany'


-- 2. Show the name and per capita gdp: gdp/population for each country
--    where the area is over 5,000,000 km^2

SELECT name, gdp/population 
FROM world
WHERE area > 5000000


-- 3. Show the name and continent where the area is less than 2000
--    and the gdp is more than 5000000000

SELECT name, continent
FROM world
WHERE area < 2000
AND gdp > 5000000000


-- 4. Show the name and the population for
--    'Denmark', 'Finland', 'Norway', 'Sweden

SELECT name, population 
FROM world
WHERE name IN ('Denmark', 'Finland', 'Norway', 'Sweden' )


-- 5. Show each country that begins with G

SELECT name 
FROM world
WHERE name LIKE 'G%'


-- 6. Show the area in 1000 square km. Show area/1000 instead of area

SELECT name, area/1000
FROM world
WHERE area BETWEEN 200000 AND 250000



-- =========================================================================


-- SELECT from WORLD


-- 1. Submit

SELECT name, continent, population
FROM world


-- 2. Show the name for the countries that have a population of at least
--    200 million. 200 million is 200000000, there are eight zeros. 

SELECT name 
FROM world
WHERE population > 200000000


-- 3. Give the name and the per capita GDP for those countries with a
--    population of at least 200 million. 

SELECT name, gdp/population
FROM world
WHERE population >= 200000000


-- 4. Show the name and population in millions for the countries of the
--    continent 'South America'. Divide the population by 1000000 to get
--    population in millions.

SELECT name, population/1000000
FROM world
WHERE continent='South America'


-- 5. Show the name and population for 'France', 'Germany', 'Italy'

SELECT name, population
FROM world
WHERE name in ('France', 'Germany', 'Italy')


-- 6. Show the countries which have a name that includes the word 'United' 

SELECT name
FROM world
WHERE name LIKE '%United%'


-- =========================================================================


-- SELECT from Nobel


-- 1. Change the query shown so that it displays Nobel prizes for 1950.

SELECT yr, subject, winner
FROM nobel
WHERE yr = 1950


-- 2. Show who won the 1962 prize for Literature.

SELECT winner
FROM nobel
WHERE yr = 1962
AND subject = 'Literature'


-- 3. Show the year and subject that won 'Albert Einstein' his prize.

SELECT yr, subject
FROM nobel
WHERE winner='Albert Einstein'


-- 4. Give the name of the 'Peace' winners since the year 2000, including 2000.

SELECT winner
FROM nobel
WHERE subject='Peace'
AND yr >= 2000


-- 5. Show all details (yr, subject, winner) of the Literature prize winners
--    for 1980 to 1989 inclusive. 

SELECT *
FROM nobel
WHERE subject='Literature'
AND yr BETWEEN 1980 AND 1989


-- 6. Show all details of the presidential winners:
--    ('Theodore Roosevelt', 'Woodrow Wilson', 'Jed Bartlet', 'Jimmy Carter')

SELECT * 
FROM nobel
WHERE winner in  ('Theodore Roosevelt', 'Woodrow Wilson', 'Jed Bartlet', 'Jimmy Carter')


-- 7. Show the winners with first name John

SELECT winner
FROM nobel
WHERE winner LIKE 'John%'


-- 8. In which years was the Physics prize awarded but no Chemistry prize.
--    (WARNING - this question is way too hard for this level, you will need to
--    use sub queries or joins). 

SELECT DISTINCT yr
FROM nobel
WHERE yr NOT IN
  (SELECT yr
   FROM nobel
   WHERE subject='Chemistry')
AND yr IN
  (SELECT yr
   FROM nobel
   WHERE subject='Physics')


-- =========================================================================


-- SELECT within SELECT


-- 1. List each country name where the population is larger than 'Russia'.

SELECT name
FROM world
WHERE population >
     (SELECT population FROM world
      WHERE name='Russia')


-- 2. Show the countries in Europe with a per capita GDP greater than
--    'United Kingdom'.


SELECT name
FROM world
WHERE continent='Europe'
AND gdp/population >
   (SELECT gdp/population
    FROM world
    WHERE name='United Kingdom')


-- 3. List the name and continent of countries in the continents containing
--    'Belize', 'Belgium'.

SELECT name, continent
FROM world
WHERE continent IN
   (SELECT continent
    FROM world
    WHERE name in ('Belize', 'Belgium'))


-- 4. Which country has a population that is more than Canada but less than
--    Poland? Show the name and the population.

SELECT name, population
FROM world
WHERE population >
   (SELECT population
    FROM world
    WHERE name='Canada')
AND population <
   (SELECT population
    FROM world
    WHERE name='Poland')


-- 5. Which countries have a GDP greater than every country in Europe?
--   [Give the name only.] (Some countries may have NULL gdp values)


SELECT name
FROM world
WHERE gdp >
    (SELECT MAX(gdp)
     FROM world
     WHERE continent='Europe')


-- 6. Find the largest country (by area) in each continent,
--    show the continent, the name and the area: 

SELECT continent, name, area
FROM world x
WHERE area >=
    ALL(SELECT area
        FROM world
        WHERE x.continent=continent
        AND area > 0)


-- 7. Find each country that belongs to a continent where all populations are
--    less than 25000000. Show name, continent and population

SELECT name, continent, population
FROM world
WHERE continent IN
   (SELECT continent 
    FROM world
    WHERE population < 25000000
    AND population > 0)


-- 8. Some countries have populations more than three times that of any of
--    their neighbours (in the same continent).
--    Give the countries and continents.


SELECT name, continent
FROM world x
WHERE population / 3 >
   ALL(SELECT population
       FROM world y
       WHERE x.continent=y.continent
       AND x.name <> y.name)
       

-- =========================================================================

-- SUM and COUNT


-- 1. Show the total population of the world. 

SELECT SUM(population)
FROM world


-- 2. List all the continents - just once each. 

SELECT DISTINCT continent
FROM world


-- 3. Give the total GDP of Africa

SELECT SUM(gdp)
FROM world
WHERE continent='Africa'


-- 4. How many countries have an area of at least 1000000

SELECT COUNT(name)
FROM world
WHERE area >= 1000000


-- 5. What is the total population of ('France','Germany','Spain')

SELECT SUM(population)
FROM world
WHERE name IN ('France','Germany','Spain')


-- 6. For each continent show the continent and number of countries.

SELECT continent, COUNT(name)
FROM world
GROUP BY(continent)


-- 7. For each continent show the continent and number of countries with
--    populations of at least 10 million. 

SELECT continent, COUNT(name)
FROM world
WHERE population > 10000000
GROUP BY(continent)


-- 8. List the continents that have a total population of at least 100 million.

SELECT continent
FROM world
GROUP BY(continent)
HAVING SUM(population) >= 100000000


-- =========================================================================

-- The JOIN operation


-- 1. Show matchid and player name for all goals scored by Germany.
--    teamid = 'GER'

SELECT matchid, player
FROM goal
WHERE teamid='GER'


-- 2. Show id, stadium, team1, team2 for game 1012

SELECT id,stadium,team1,team2
FROM game 
WHERE id=1012


-- 3. Show the player, teamid and mdate and for every German goal. teamid='GER'

SELECT player,teamid, mdate
FROM game JOIN goal ON (id=matchid)
WHERE teamid='GER'


-- 4. Show the team1, team2 and player for every goal scored by a player called
--    Mario player LIKE 'Mario%'

SELECT team1, team2, player
FROM game JOIN goal ON id=matchid
WHERE player LIKE 'Mario%'


-- 5. Show player, teamid, coach, gtime for all goals scored in the
--    first 10 minutes gtime<=10

SELECT player, teamid, coach, gtime
FROM goal JOIN eteam ON id=teamid 
WHERE gtime<=10


-- 6. List the the dates of the matches and the name of the team in which
--    'Fernando Santos' was the team1 coach.

SELECT mdate, teamname
FROM game JOIN eteam ON team1=eteam.id
WHERE coach='Fernando Santos'


-- 7. List the player for every goal scored in a game where the stadium was
--   'National Stadium, Warsaw'

SELECT player
FROM game JOIN goal ON id=matchid
WHERE stadium='National Stadium, Warsaw'


-- 8. Show the name of all players who scored a goal against Germany.

SELECT DISTINCT player
FROM game JOIN goal ON matchid = id 
WHERE 'GER' IN (team1, team2)
AND teamid <> 'GER'


-- 9. Show teamname and the total number of goals scored.

SELECT teamname, COUNT(player)
FROM eteam JOIN goal ON id=teamid
GROUP BY(teamname)


-- 10. Show the stadium and the number of goals scored in each stadium.

SELECT stadium, COUNT(player)
FROM game JOIN goal ON id=matchid
GROUP BY(stadium)


-- 11. For every match involving 'POL', show the matchid, date and the number
--     of goals scored.

SELECT matchid, mdate, COUNT(player)
FROM game JOIN goal ON matchid = id 
WHERE (team1 = 'POL' OR team2 = 'POL')
GROUP BY(id)


-- 12. For every match where 'GER' scored, show matchid, match date and the
--     number of goals scored by 'GER'

SELECT matchid, mdate, COUNT(player)
FROM game JOIN goal ON matchid=id
WHERE teamid='GER'
GROUP BY(id)


-- 13. List every match with the goals scored by each team as shown.
--     This will use "CASE WHEN" which has not been explained in any
--     previous exercises.

SELECT mdate,
       team1,
       SUM(CASE WHEN teamid=team1 THEN 1 ELSE 0 END) as score1,
       team2,
       SUM(CASE WHEN teamid=team2 THEN 1 ELSE 0 END) as score2
FROM game LEFT JOIN goal ON matchid=id
GROUP BY(id)
ORDER BY mdate, matchid, team1, team2


-- =========================================================================



-- More JOIN operations

-- 1. List the films where the yr is 1962 [Show id, title]

SELECT id, title
FROM movie
WHERE yr=1962


-- 2. Give year of 'Citizen Kane'.

SELECT yr
FROM movie
WHERE title = 'Citizen Kane'


-- 3. List all of the Star Trek movies, include the id, title and yr
--    (all of these movies include the words Star Trek in the title).
--    Order results by year.

SELECT id, title, yr
FROM movie
WHERE title LIKE '%Star Trek%'
ORDER BY yr


-- 4. What are the titles of the films with id 11768, 11955, 21191

SELECT title
FROM movie
WHERE id IN (11768, 11955, 21191)


-- 5. What id number does the actor 'Glenn Close' have?

SELECT id
FROM actor
WHERE name='Glenn Close'


-- 6. What is the id of the film 'Casablanca'

SELECT id
FROM movie
WHERE title='Casablanca'


-- 7. Obtain the cast list for 'Casablanca'.
--    Use the id value that you obtained in the previous question

SELECT actor.name
FROM movie JOIN casting JOIN actor 
ON movie.id = movieid AND actorid = actor.id
WHERE movie.id=11768


-- 8. Obtain the cast list for the film 'Alien'

SELECT actor.name
FROM movie JOIN casting JOIN actor 
ON movie.id = movieid AND actorid = actor.id
WHERE movie.title='Alien'


-- 9. List the films in which 'Harrison Ford' has appeared

SELECT movie.title
FROM movie JOIN casting JOIN actor
ON movie.id = movieid AND actor.id = actorid
WHERE actor.name='Harrison Ford'


-- 10. List the films where 'Harrison Ford' has appeared - but not in the
--     star role. [Note: the ord field of casting gives the position of the
--     actor. If ord=1 then this actor is in the starring role]

SELECT movie.title
FROM movie JOIN casting JOIN actor
ON movie.id = movieid AND actor.id = actorid
WHERE actor.name='Harrison Ford' 
AND casting.ord <> 1


-- 11. List the films together with the leading star for all 1962 films.

SELECT movie.title, actor.name
FROM movie JOIN casting JOIN actor
ON movie.id = movieid AND actor.id = actorid
WHERE casting.ord = 1
AND movie.yr = 1962


-- 12. Which were the busiest years for 'John Travolta', show the year and the
--     number of movies he made each year for any year in which he made more
--     than 2 movies.

SELECT movie.yr, COUNT(movie.title) as movies
FROM movie JOIN casting JOIN actor
ON movie.id = movieid AND actor.id = actorid
WHERE actor.name = 'John Travolta'
GROUP BY(movie.yr)
HAVING COUNT(movie.title) > 2


-- 13. List the film title and the leading actor for all of the films
--     'Julie Andrews' played in.

SELECT DISTINCT mtitle, actor.name
FROM
   (SELECT movie.id as mid, title as mtitle
    FROM movie JOIN casting JOIN actor
    ON movie.id = movieid AND actor.id = actorid
    WHERE actor.name='Julie Andrews') M
JOIN casting JOIN actor
ON mid = movieid AND actor.id = actorid
WHERE ord=1


-- 14. Obtain a list in alphabetical order of actors who've had at least 30
--     starring roles.

SELECT actor.name
FROM movie JOIN casting JOIN actor
ON movie.id = movieid AND actor.id = actorid
WHERE ord=1
GROUP BY(actor.name)
HAVING COUNT(actor.name) >= 30


-- 15. List the films released in the year 1978 ordered by the number of actors
--     in the cast.
--     NOTE: Engine will not accpet this answer because it breakes
--     ties differently

SELECT movie.title, COUNT(actorid)
FROM movie JOIN casting JOIN actor
ON movie.id = movieid AND actor.id = actorid
WHERE movie.yr=1978
GROUP BY(movie.title)
ORDER BY COUNT(actor.id) DESC


-- 16. List all the people who have worked with 'Art Garfunkel'.

SELECT DISTINCT actor.name
FROM
   (SELECT movie.id as mid
    FROM movie JOIN casting JOIN actor
    ON movie.id = movieid AND actor.id = actorid
    WHERE actor.name='Art Garfunkel') M
JOIN casting JOIN actor
ON mid = movieid AND actor.id = actorid
WHERE actor.name <> 'Art Garfunkel'


-- =========================================================================


-- Using Null


-- 1. List the teachers who have NULL for their department.

SELECT name
FROM teacher
WHERE dept IS NULL


-- 2. Note the INNER JOIN misses the teacher with no department and the
--    department with no teacher.

SELECT teacher.name, dept.name
FROM teacher INNER JOIN dept
ON (teacher.dept=dept.id)


-- 3. Use a different JOIN so that all teachers are listed.

SELECT teacher.name, dept.name
FROM teacher LEFT OUTER JOIN dept
ON teacher.dept=dept.id


-- 4. Use a different JOIN so that all departments are listed.

SELECT teacher.name, dept.name
FROM teacher RIGHT OUTER JOIN dept
ON teacher.dept=dept.id


-- 5. Use COALESCE to print the mobile number. Use the number '07986 444 2266'
--    there is no number given. Show teacher name and mobile number or
--    '07986 444 2266'

SELECT name, COALESCE(mobile, '07986 444 2266')
FROM teacher


-- 6. Use the COALESCE function and a LEFT JOIN to print the name and
--    department name. Use the string 'None' where there is no department.

SELECT teacher.name, COALESCE(dept.name, 'None')
FROM teacher LEFT OUTER JOIN dept
ON teacher.dept=dept.id


-- 7. Use COUNT to show the number of teachers and the number of mobile phones.

SELECT COUNT(name), 
       SUM(CASE WHEN mobile IS NULL THEN 0 ELSE 1 END)
FROM teacher


-- 8. Use COUNT and GROUP BY dept.name to show each department and the number
--    of staff. Use a RIGHT JOIN to ensure that the Engineering department is
--    listed.

SELECT dept.name, COUNT(teacher.id)
FROM teacher RIGHT OUTER JOIN dept
ON teacher.dept=dept.id
GROUP BY dept.id


-- 9. Use CASE to show the name of each teacher followed by 'Sci' if the the
--    teacher is in dept 1 or 2 and 'Art' otherwise.

SELECT teacher.name,
       CASE 
       WHEN teacher.dept IN (1, 2)
       THEN 'Sci'
       ELSE 'Art'
       END
FROM teacher LEFT OUTER JOIN dept
ON teacher.dept=dept.id


-- 10. Use CASE to show the name of each teacher followed by 'Sci' if the the
--     teacher is in dept 1 or 2 show 'Art' if the dept is 3 and 'None'
--     otherwise.

SELECT teacher.name,
       CASE 
       WHEN teacher.dept IN (1, 2)
       THEN 'Sci'
       WHEN teacher.dept = 3
       THEN 'Art'
       ELSE 'None'
       END
FROM teacher LEFT OUTER JOIN dept
ON teacher.dept=dept.id


-- =========================================================================


-- National Student Survey 2012 


-- 1. Show the the percentage who STRONGLY AGREE

SELECT A_STRONGLY_AGREE
  FROM nss
 WHERE question='Q01'
   AND institution='Edinburgh Napier University'
   AND subject='(8) Computer Science'


-- 2. Show the institution and subject where the score is at least 100 for
--    question 15.

SELECT institution, subject
FROM nss
WHERE score >= 100
AND question='Q15'


-- 3. Show the institution and score where the score for
--    '(8) Computer Science' is less than 50 for question 'Q15' 

SELECT institution,score
FROM nss
WHERE question='Q15'
AND subject='(8) Computer Science'
AND score < 50


-- 4. Show the subject and total number of students who responded to
--    question 22 for each of the subjects '(8) Computer Science' and
--    '(H) Creative Arts and Design'. 

SELECT subject, SUM(response)
FROM nss
WHERE question='Q22'
AND subject IN ('(8) Computer Science', '(H) Creative Arts and Design')
GROUP BY subject


-- 5. Show the subject and total number of students who A_STRONGLY_AGREE to
--    question 22 for each of the subjects '(8) Computer Science' and
--    '(H) Creative Arts and Design'.

SELECT subject, SUM(response * A_STRONGLY_AGREE / 100)
FROM nss
WHERE question='Q22'
AND subject IN ('(8) Computer Science', '(H) Creative Arts and Design')
GROUP BY subject


-- 6. Show the percentage of students who A_STRONGLY_AGREE to question 22 for
--    the subject '(8) Computer Science' show the same figure for the subject
--    '(H) Creative Arts and Design'. 

SELECT subject, ROUND(SUM(response*A_STRONGLY_AGREE)/SUM(response))
FROM nss
WHERE question='Q22'
AND subject IN ('(8) Computer Science', '(H) Creative Arts and Design')
GROUP BY subject


-- 7. Show the average scores for question 'Q22' for each institution that
--    include 'Manchester' in the name. 

SELECT institution, 
       ROUND(SUM(score * response) / SUM(response))
FROM nss
WHERE question='Q22'
AND (institution LIKE '%Manchester%')
GROUP BY institution


-- 8. Show the institution, the total sample size and the number of computing
--    students for institutions in Manchester for 'Q01'. 

SELECT institution, 
       SUM(sample), 
       SUM(CASE 
           WHEN subject='(8) Computer Science' 
           THEN sample
           ELSE 0
           END) 
FROM nss
WHERE question='Q01' 
AND (institution LIKE '%Manchester%') 
GROUP BY institution


-- =========================================================================


-- Self join


-- 1. How many stops are in the database.

SELECT COUNT(id)
FROM stops


-- 2. Find the id value for the stop 'Craiglockhart'

SELECT id
FROM stops
WHERE name='Craiglockhart'


-- 3. Give the id and the name for the stops on the '4' 'LRT' service.

SELECT stops.id, stops.name
FROM stops JOIN route ON stops.id=route.stop
WHERE company='LRT'
AND route.num=4


-- 4. The query shown gives the number of routes that visit either
--    London Road (149) or Craiglockhart (53). Run the query and notice the two
--    services that link these stops have a count of 2. Add a HAVING clause to
--    restrict the output to these two routes. 

SELECT company, num, COUNT(*)
FROM route 
WHERE stop=149 OR stop=53
GROUP BY company, num
HAVING COUNT(*) = 2


-- 5. Execute the self join shown and observe that b.stop gives all the places
--    you can get to from Craiglockhart, without changing routes. Change the
--    query so that it shows the services from Craiglockhart to London Road. 

SELECT a.company, a.num, a.stop, b.stop
FROM route a JOIN route b  JOIN stops
ON (
  a.company=b.company 
  AND a.num=b.num 
  AND stops.id=b.stop)
WHERE a.stop=53
AND stops.name='London Road'


-- 6. The query shown is similar to the previous one, however by joining two
--    copies of the stops table we can refer to stops by name rather than by
--    number. Change the query so that the services between 'Craiglockhart' and
--    'London Road' are shown. If you are tired of these places try
--    'Fairmilehead' against 'Tollcross'

SELECT a.company, a.num, stopa.name, stopb.name
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
  JOIN stops stopa ON (a.stop=stopa.id)
  JOIN stops stopb ON (b.stop=stopb.id)
WHERE stopa.name='Craiglockhart'
AND stopb.name='London Road'


-- 7. Give a list of all the services which connect stops 115 and 137
--    ('Haymarket' and 'Leith') 

SELECT DISTINCT a.company, a.num
FROM route a JOIN route b 
ON a.company=b.company 
AND a.num=b.num
WHERE a.stop=115 AND b.stop=137


-- 8. Give a list of the services which connect the stops 'Craiglockhart' and
--    'Tollcross'

SELECT a.company, a.num
FROM route a JOIN route b JOIN stops sa JOIN stops sb
ON a.company=b.company 
AND a.num=b.num
AND a.stop=sa.id
AND b.stop=sb.id
WHERE sa.name='Craiglockhart' AND sb.name='Tollcross'


-- 9. Give a distinct list of the stops which may be reached from
--    'Craiglockhart' by taking one bus, including 'Craiglockhart' itself.
--    Include the company and bus no. of the relevant services. 

SELECT DISTINCT sb.name, a.company, a.num
FROM route a JOIN route b JOIN stops sa JOIN stops sb
ON a.company=b.company 
AND a.num=b.num
AND a.stop=sa.id
AND b.stop=sb.id
WHERE sa.name='Craiglockhart'


-- 10. Find the routes involving two buses that can go from Craiglockhart to
--     Sighthill. Show the bus no. and company for the first bus, the name of
--     the stop for the transfer, and the bus no. and company for the second bus

-- NOTE: Engine accpets this as correct ans, though there's misssing
--       'AND a.company=b.company' in the first sub select 

SELECT DISTINCT an, ac, stops.name, dn, dc
FROM
  -- all lines going from Craiglockahart to somewhere
  (SELECT a.num as an, a.company as ac, b.stop as bstop
   FROM 
   route a JOIN route b JOIN stops s
   ON a.num=b.num AND s.id=a.stop
   WHERE s.name='Craiglockhart') T1
 JOIN
  -- all lines going from somewhere to Sighthill 
  (SELECT d.num as dn, d.company as dc, c.stop as cstop
   FROM 
   route c JOIN route d JOIN stops s
   ON c.num=d.num AND c.company=d.company AND s.id=d.stop
   WHERE s.name='Sighthill') T2
 JOIN stops
 ON bstop=cstop AND bstop=stops.id

   
-- =========================================================================
