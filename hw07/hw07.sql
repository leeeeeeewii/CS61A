CREATE TABLE parents AS
  SELECT "abraham" AS parent, "barack" AS child UNION
  SELECT "abraham"          , "clinton"         UNION
  SELECT "delano"           , "herbert"         UNION
  SELECT "fillmore"         , "abraham"         UNION
  SELECT "fillmore"         , "delano"          UNION
  SELECT "fillmore"         , "grover"          UNION
  SELECT "eisenhower"       , "fillmore";

CREATE TABLE dogs AS
  SELECT "abraham" AS name, "long" AS fur, 26 AS height UNION
  SELECT "barack"         , "short"      , 52           UNION
  SELECT "clinton"        , "long"       , 47           UNION
  SELECT "delano"         , "long"       , 46           UNION
  SELECT "eisenhower"     , "short"      , 35           UNION
  SELECT "fillmore"       , "curly"      , 32           UNION
  SELECT "grover"         , "short"      , 28           UNION
  SELECT "herbert"        , "curly"      , 31;

CREATE TABLE sizes AS
  SELECT "toy" AS size, 24 AS min, 28 AS max UNION
  SELECT "mini"       , 28       , 35        UNION
  SELECT "medium"     , 35       , 45        UNION
  SELECT "standard"   , 45       , 60;


-- The size of each dog
CREATE TABLE size_of_dogs AS
  SELECT name, size FROM dogs, sizes
  WHERE height > min AND height <= max
  ;


-- All dogs with parents ordered by decreasing height of their parent
CREATE TABLE by_parent_height AS
  SELECT A.name FROM parents, dogs A, dogs B
  WHERE A.name = child AND B.name = parent
  ORDER BY B.height DESC
  ;


-- Filling out this helper table is optional
CREATE TABLE siblings AS
  SELECT "REPLACE THIS LINE WITH YOUR SOLUTION";

-- Sentences about siblings that are the same size
CREATE TABLE sentences AS
  SELECT 'The two siblings, ' || A.name || ' plus ' || B.name || ' have the same size: ' || E.size
  FROM dogs A, dogs B, parents C, parents D, size_of_dogs E, size_of_dogs F
  WHERE A.name = C.child AND B.name = D.child AND C.parent = D.parent
  AND A.name = E.name AND B.name = F.name AND E.size = F.size
  AND A.name < B.name
  ;


-- Ways to stack 4 dogs to a height of at least 175, ordered by total height
CREATE TABLE stacks_helper(dogs, stack_height, last_height, n);

-- Add your INSERT INTOs here
INSERT INTO stacks_helper SELECT name, height, height, 1 FROM dogs;
INSERT INTO stacks_helper SELECT dogs || ', ' || name, stack_height + height, height, n + 1 FROM stacks_helper, dogs WHERE height > last_height;
INSERT INTO stacks_helper SELECT dogs || ', ' || name, stack_height + height, height, n + 1 FROM stacks_helper, dogs WHERE height > last_height;
INSERT INTO stacks_helper SELECT dogs || ', ' || name, stack_height + height, height, n + 1 FROM stacks_helper, dogs WHERE height > last_height;


CREATE TABLE stacks AS
  SELECT dogs, stack_height FROM stacks_helper
  WHERE n = 4 AND stack_height >= 175
  ORDER BY stack_height
  ;


-- Total size for each fur type where all of the heights differ by no more than 30% from the average height
CREATE TABLE low_variance AS
  SELECT fur, SUM(height) FROM dogs
  GROUP BY fur
  HAVING MIN(height) > AVG(height) * 0.7 AND MAX(height) < AVG(height) * 1.3
  ;


-- Heights and names of dogs that are above average in height among
-- dogs whose height has the same first digit.
-- CREATE TABLE above_average AS -- seems the wrong table name
CREATE TABLE tallest AS
  WITH average_height AS(
    SELECT height / 10 AS digit, AVG(height) AS average FROM dogs
    GROUP BY digit
    HAVING COUNT(*) > 1
  )
  SELECT height, name FROM average_height, dogs
  WHERE height / 10 = digit AND height > average
  ;


-- non_parents is an optional, but recommended question
-- All non-parent relations ordered by height difference
CREATE TABLE non_parents as
  WITH ancestors AS (
    SELECT A.name AS pre, B.name AS nxt FROM dogs A, dogs B, parents C, parents D
    WHERE A.name = C.child AND B.name = D.parent AND C.parent = D.child UNION
    SELECT E.name, F.name FROM dogs E, dogs F, ancestors G, parents H
    WHERE E.name = G.pre AND G.nxt = H.child AND F.name = H.parent
  )
  SELECT A.name, B.name FROM dogs A, dogs B, ancestors C
  WHERE A.name = C.pre AND B.name = C.nxt
  OR A.name = C.nxt AND B.name = C.pre
  ORDER BY A.height - B.height
  ;

