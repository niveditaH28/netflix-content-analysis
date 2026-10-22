USE netflix_project;
DROP TABLE IF EXISTS netflix_titles;

CREATE TABLE netflix_titles (
  show_id VARCHAR(10),
  type VARCHAR(20),
  title VARCHAR(255),
  director TEXT,
  `cast` TEXT,
  country TEXT,
  date_added VARCHAR(50),
  release_year INT,
  rating VARCHAR(20),
  duration VARCHAR(30),
  listed_in VARCHAR(255),
  description TEXT
) CHARACTER SET utf8mb4;
SELECT COUNT(*) FROM netflix_project.netflix_titles;
SELECT type, COUNT(*) FROM netflix_project.netflix_titles GROUP BY type;
-- Duplicate IDs
SELECT show_id, COUNT(*) FROM netflix_project.netflix_titles
GROUP BY show_id HAVING COUNT(*) > 1;

-- Missing values
SELECT
  SUM(director IS NULL OR director = '') AS missing_director,
  SUM(country IS NULL OR country = '') AS missing_country,
  SUM(date_added IS NULL OR TRIM(date_added) = '') AS missing_date,
  SUM(rating IS NULL OR rating = '') AS missing_rating
FROM netflix_project.netflix_titles;
-- 1. Movies vs TV shows
SELECT type, COUNT(*) AS total,
       ROUND(COUNT(*) * 100 / (SELECT COUNT(*) FROM netflix_project.netflix_titles), 1) AS pct
FROM netflix_project.netflix_titles GROUP BY type;

-- 2. Titles added per year, by type
SELECT YEAR(date_added_clean) AS yr, type, COUNT(*) AS titles
FROM netflix_project.netflix_titles
WHERE date_added_clean IS NOT NULL
GROUP BY yr, type ORDER BY yr;

-- 3. Top 10 countries (first country listed)
SELECT SUBSTRING_INDEX(country, ',', 1) AS main_country, COUNT(*) AS titles
FROM netflix_project.netflix_titles
WHERE country <> 'Unknown'
GROUP BY main_country ORDER BY titles DESC LIMIT 10;

-- 4. Top 3 genres per year (CTE + window function)
WITH genre_counts AS (
  SELECT YEAR(date_added_clean) AS yr,
         TRIM(SUBSTRING_INDEX(listed_in, ',', 1)) AS genre,
         COUNT(*) AS cnt
  FROM netflix_project.netflix_titles
  WHERE date_added_clean IS NOT NULL
  GROUP BY yr, genre
)
SELECT * FROM (
  SELECT *, RANK() OVER (PARTITION BY yr ORDER BY cnt DESC) AS rnk
  FROM genre_counts
) t WHERE rnk <= 3 ORDER BY yr, rnk;

-- 5. Average gap between release and arrival on Netflix
SELECT ROUND(AVG(YEAR(date_added_clean) - release_year), 1) AS avg_gap_years
FROM netflix_project.netflix_titles WHERE date_added_clean IS NOT NULL;

-- 6. Rating distribution
SELECT rating, COUNT(*) AS titles
FROM netflix_project.netflix_titles
GROUP BY rating ORDER BY titles DESC;

ALTER TABLE netflix_project.netflix_titles ADD COLUMN date_added_clean DATE;
SELECT COUNT(*) AS total, COUNT(date_added_clean) AS dates_filled FROM netflix_project.netflix_titles;

SELECT date_added, LENGTH(date_added) AS len, date_added_clean FROM netflix_project.netflix_titles LIMIT 10;
UPDATE netflix_project.netflix_titles SET date_added_clean = STR_TO_DATE(TRIM(date_added), '%M %e, %Y') WHERE date_added IS NOT NULL AND TRIM(date_added) <> '';
SELECT COUNT(*) AS total, COUNT(date_added_clean) AS dates_filled FROM netflix_project.netflix_titles;

SELECT type, COUNT(*) AS total, ROUND(COUNT(*) * 100 / (SELECT COUNT(*) FROM netflix_project.netflix_titles), 1) AS pct FROM netflix_project.netflix_titles GROUP BY type;

SELECT YEAR(date_added_clean) AS yr, type, COUNT(*) AS titles FROM netflix_project.netflix_titles WHERE date_added_clean IS NOT NULL GROUP BY YEAR(date_added_clean), type ORDER BY yr;

SELECT SUBSTRING_INDEX(country, ',', 1) AS main_country, COUNT(*) AS titles FROM netflix_project.netflix_titles WHERE country <> 'Unknown' GROUP BY SUBSTRING_INDEX(country, ',', 1) ORDER BY titles DESC LIMIT 10;

WITH genre_counts AS (SELECT YEAR(date_added_clean) AS yr, TRIM(SUBSTRING_INDEX(listed_in, ',', 1)) AS genre, COUNT(*) AS cnt FROM netflix_project.netflix_titles WHERE date_added_clean IS NOT NULL GROUP BY YEAR(date_added_clean), TRIM(SUBSTRING_INDEX(listed_in, ',', 1)))
SELECT yr, genre, cnt, rnk FROM (SELECT yr, genre, cnt, RANK() OVER (PARTITION BY yr ORDER BY cnt DESC) AS rnk FROM genre_counts) t WHERE rnk <= 3 ORDER BY yr, rnk;

SELECT COUNT(*) FROM netflix_project.netflix_titles WHERE country IS NULL OR TRIM(country) = '';
UPDATE netflix_project.netflix_titles SET country = 'Unknown' WHERE country IS NULL OR TRIM(country) = '';

SELECT TRIM(SUBSTRING_INDEX(TRIM(BOTH ',' FROM TRIM(country)), ',', 1)) AS main_country, COUNT(*) AS titles FROM netflix_project.netflix_titles WHERE TRIM(country) NOT IN ('', 'Unknown') GROUP BY main_country ORDER BY titles DESC LIMIT 10;
SELECT YEAR(date_added_clean) AS yr, type, COUNT(*) AS titles FROM netflix_project.netflix_titles WHERE date_added_clean IS NOT NULL GROUP BY YEAR(date_added_clean), type ORDER BY yr;
