.read data.sql


CREATE TABLE bluedog AS
  SELECT color, pet FROM students
    WHERE color = 'blue'
        AND pet = 'dog'
  ;

CREATE TABLE bluedog_songs AS
  SELECT color, pet, song FROM students
    WHERE color = 'blue'
        AND pet = 'dog'
  ;

CREATE TABLE matchmaker AS
  SELECT A.pet, A.song, A.color, B.color
  FROM students AS A, students AS B
  WHERE A.pet = B.pet
    AND A.song = B.song
    AND A.time < B.time
  ;


CREATE TABLE sevens AS
  SELECT seven FROM students, numbers
  WHERE students.number = 7
  AND numbers.'7' = 'True'
  AND students.time = numbers.time
  ;


CREATE TABLE favpets AS
  SELECT pet, COUNT(*) AS counts FROM students
  GROUP BY pet
  ORDER BY counts DESC LIMIT 10
  ;


CREATE TABLE dog AS
  SELECT * FROM favpets
  WHERE pet = 'dog'
  ;


CREATE TABLE bluedog_agg AS
  SELECT song, COUNT(*) AS counts FROM bluedog_songs
  GROUP BY song
  ORDER BY counts DESC
  ;


CREATE TABLE instructor_obedience AS
  SELECT seven, instructor, COUNT(*) FROM students
  WHERE seven = '7'
  GROUP BY instructor
  ;


CREATE TABLE smallest_int_having AS
  SELECT time, smallest FROM students
  GROUP BY smallest
  HAVING COUNT(smallest) = 1
  ;


CREATE TABLE smallest_int_count AS
  SELECT smallest, COUNT(smallest) FROM students
  GROUP BY smallest
  ORDER BY smallest
  ;

