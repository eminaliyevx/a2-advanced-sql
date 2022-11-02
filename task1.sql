CREATE TABLE SCHOOLS
(
  id   SERIAL PRIMARY KEY,
  name VARCHAR(256)
);

CREATE TABLE STUDENTS
(
  id        SERIAL PRIMARY KEY,
  firstname VARCHAR(256),
  lastname  VARCHAR(256),
  schoolid  INT,
  FOREIGN KEY (schoolid) REFERENCES SCHOOLS (id)
);

CREATE OR REPLACE FUNCTION createStudent(firstname VARCHAR(256), lastname VARCHAR(256), schoolname VARCHAR(256))
  RETURNS INT
  LANGUAGE plpgsql
AS
$$
DECLARE
  studentid INT;
  schoolid  INT;
BEGIN
  SELECT id INTO schoolid FROM schools WHERE name = schoolname;

  IF schoolid IS NULL
  THEN
    INSERT INTO schools(name) VALUES (schoolname) RETURNING id INTO schoolid;
  END IF;

  INSERT INTO STUDENTS(firstname, lastname, schoolid)
  VALUES (firstname, lastname, schoolid)
  RETURNING id INTO studentid;

  RETURN studentid;
END;
$$;

SELECT createStudent('Emin', 'Aliyev', 'SITE');
