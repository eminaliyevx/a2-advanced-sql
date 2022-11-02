CREATE TABLE COURSES
(
  id   SERIAL PRIMARY KEY,
  name VARCHAR(256)
);

CREATE TABLE ASSIGNMENTS
(
  id        SERIAL PRIMARY KEY,
  studentid INT,
  courseid  INT,
  grade     FLOAT CHECK ( grade >= 0 AND grade <= 100 ),
  FOREIGN KEY (studentid) REFERENCES STUDENTS (id),
  FOREIGN KEY (courseid) REFERENCES COURSES (id)
);

CREATE TABLE ENROLLMENTS
(
  id         SERIAL PRIMARY KEY,
  studentid  INT,
  courseid   INT,
  totalGrade FLOAT,
  FOREIGN KEY (studentid) REFERENCES STUDENTS (id),
  FOREIGN KEY (courseid) REFERENCES COURSES (id)
);

CREATE OR REPLACE FUNCTION getTotalGrade() RETURNS TRIGGER
  LANGUAGE plpgsql
AS
$$
DECLARE
  total FLOAT;
BEGIN
  SELECT SUM(grade) INTO total FROM assignments WHERE studentid = NEW.studentid AND courseid = NEW.courseid;

  UPDATE enrollments SET totalgrade = total WHERE studentid = NEW.studentid AND courseid = NEW.courseid;

  RETURN NEW;
END;
$$;

CREATE OR REPLACE TRIGGER totalGradeTrigger
  AFTER UPDATE
  ON assignments
  FOR EACH ROW
EXECUTE FUNCTION getTotalGrade()