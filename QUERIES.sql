# QUERY 1:  ORDER CANDIDATE NAMES ALPHABETICALLY
SELECT CANDIDATE_ID,CANDIDATE_NAME,CANDIDATE_LNAME
FROM CANDIDATE
ORDER BY CANDIDATE_NAME;

# QUERY 2:  GET THE PROFESSORS' NAMES AND THE TRAININGS THEY LECTURE

  SELECT  STAFF.MEMBER_NAME,STAFF.MEMBER_LNAME,STAFF.TITLE,TRAINING.TRAINING_NAME
  FROM PROFESSOR 
  JOIN TRAINING_SESSION ON TRAINING_SESSION.TRAINING_SESSION_CODE=PROFESSOR.TRAINING_SESSION_CODE
  JOIN TRAINING ON TRAINING_SESSION.TRAINING_ID=TRAINING.TRAINING_ID
  JOIN STAFF ON STAFF.STAFF_ID=PROFESSOR.STAFF_ID;

# QUERY 3: GET THE CANDIDATES' NAMES AND THE TRAININGS THEY TAKE

  SELECT CANDIDATE.CANDIDATE_ID,CANDIDATE.CANDIDATE_NAME,CANDIDATE.CANDIDATE_LNAME,TRAINING.TRAINING_NAME
  FROM TRAINING_SESSION
  JOIN TRAINING_ATTENDANCE ON TRAINING_ATTENDANCE.TRAINING_SESSION_CODE=TRAINING_SESSION.TRAINING_SESSION_CODE
  JOIN TRAINING ON TRAINING_SESSION.TRAINING_ID=TRAINING.TRAINING_ID
  JOIN CANDIDATE ON CANDIDATE.CANDIDATE_ID=TRAINING_ATTENDANCE.CANDIDATE_ID
  GROUP BY CANDIDATE.CANDIDATE_ID;
  
# QUERY 4 :  GET THE LECTURES THAT WERE HELD ON 2021-01-27

SELECT TRAINING.TRAINING_NAME, TRAINING_HOURS.TRAINING_HOUR_DATE,TRAINING_HOURS.START_TIME
FROM TRAINING_SESSION
JOIN TRAINING_HOURS ON TRAINING_HOURS.TRAINING_SESSION_CODE=TRAINING_SESSION.TRAINING_SESSION_CODE
JOIN TRAINING ON TRAINING.TRAINING_ID=TRAINING_SESSION.TRAINING_ID
WHERE TRAINING_HOUR_DATE='2021-01-27';

# QUERY 5 : GET THE NAMES OF THE CANDIDATES THAT GOT CERTIFICATES, THE TRAINING THEY GOT CERTIFIED FOR AND THE CORRENSPONDING DATE

SELECT CANDIDATE.CANDIDATE_NAME,CANDIDATE.CANDIDATE_LNAME, TRAINING.TRAINING_NAME,CERTIFICATION_ARCHIVE.CERTIFICATION_DATE
FROM CERTIFICATION_ARCHIVE
JOIN CANDIDATE ON CANDIDATE.CANDIDATE_ID=CERTIFICATION_ARCHIVE.CANDIDATE_ID
JOIN TRAINING ON TRAINING.TRAINING_ID=CERTIFICATION_ARCHIVE.TRAINING_ID;


# QUERY 6 : GET THE NAMES OF THE CANDIDATES THAT HAVE GOTTEN INTERNSHIPS

SELECT CANDIDATE.CANDIDATE_NAME,CANDIDATE.CANDIDATE_LNAME, INTERNSHIP.COMPANY_NAME
FROM INTERNSHIP
JOIN CERTIFICATION_ARCHIVE ON CERTIFICATION_ARCHIVE.CERTIFICATE_ID=INTERNSHIP.CERTIFICATE_ID
JOIN CANDIDATE ON CANDIDATE.CANDIDATE_ID=CERTIFICATION_ARCHIVE.CANDIDATE_ID;
  
# QUERY 7 : GET THE TITLE AND THE NAME OF THE MOST PAID PERSON IN THE COMPANY

SELECT STAFF.MEMBER_NAME, STAFF.MEMBER_LNAME, STAFF.TITLE, SALARY.SALARY_AMOUNT
FROM STAFF
JOIN SALARY ON SALARY.STAFF_ID=STAFF.STAFF_ID
WHERE SALARY_AMOUNT=(SELECT MAX(SALARY_AMOUNT) FROM SALARY);

# QUERY 8 : GET THE NAMES OF CANDIDATES THAT START WITH A

SELECT * 
FROM CANDIDATE WHERE CANDIDATE_NAME LIKE 'A%';

# QUERY 9:  GET THE NAMES OF THE CANDIDATES THAT ARE FROM FERIZAJ

SELECT * 
FROM CANDIDATE WHERE CANDIDATE_CITY LIKE 'FERIZAJ%';

# QUERY 10: GET THE AGES OF THE CANDIDATES

SELECT CANDIDATE_NAME,CANDIDATE_LNAME,SYSDATE(),CANDIDATE_DATE_OF_BIRTH,DATEDIFF(SYSDATE(),CANDIDATE_DATE_OF_BIRTH)/365 AS AGE
FROM CANDIDATE WHERE(DATEDIFF(SYSDATE(), CANDIDATE_DATE_OF_BIRTH)/365);

# QUERY 11: GET THE NAMES OF THE STAFF MEMBERS THAT HAVE A SALARY GREATER THAN 500

SELECT  MEMBER_NAME, MEMBER_LNAME, SALARY.SALARY_AMOUNT
FROM STAFF
JOIN SALARY ON STAFF.STAFF_ID=SALARY.STAFF_ID
WHERE SALARY_AMOUNT>500
ORDER BY SALARY_AMOUNT; 

# QUERY 12: GET A LIST OF THE MOST PAID TO THE LEAST PAID TRAININGS
 SELECT TRAINING_NAME, TRAINING_COST
 FROM TRAINING
 ORDER BY TRAINING_COST;
 
 # QUERY 13 : COUNT THE NUMBER OF SESSION FOR EVERY TRAINING
 
SELECT TRAINING.TRAINING_NAME,COUNT(TRAINING_SESSION_NUMBER) AS NUMBER_OF_SESSIONS_SO_FAR
FROM TRAINING_SESSION
JOIN TRAINING ON TRAINING.TRAINING_ID=TRAINING_SESSION.TRAINING_ID
GROUP BY TRAINING.TRAINING_ID;

# QUERY 14 :  GET THE ATTENDANCES OF ALL CANDIDATES OF THE FIRST SESSION AND THE NAME OF THE TRANINGS THEY ATTENDED

SELECT 
CANDIDATE.CANDIDATE_NAME, CANDIDATE.CANDIDATE_LNAME, TRAINING.TRAINING_NAME,
SUM(CASE WHEN PRESENCE= 'TRUE' THEN 0 ELSE 1 END) AS PRESENCE,
SUM(CASE WHEN PRESENCE='FALSE' THEN 1 ELSE 0 END) AS ABSENCE
 FROM TRAINING_SESSION
  JOIN TRAINING_ATTENDANCE ON TRAINING_ATTENDANCE.TRAINING_SESSION_CODE=TRAINING_SESSION.TRAINING_SESSION_CODE
  JOIN TRAINING ON TRAINING_SESSION.TRAINING_ID=TRAINING.TRAINING_ID
  JOIN CANDIDATE ON CANDIDATE.CANDIDATE_ID=TRAINING_ATTENDANCE.CANDIDATE_ID
WHERE TRAINING_SESSION_NUMBER=20000
GROUP BY  TRAINING.TRAINING_ID,  CANDIDATE.CANDIDATE_ID;

# QUERY 15: GET THE NAMES OF THE CANDIDATES THAT FINISHED MORE THAN ONE TRAINING 

SELECT CANDIDATE.CANDIDATE_NAME, CANDIDATE.CANDIDATE_LNAME, COUNT(TRAINING.TRAINING_ID) AS TOTAL_NUMBER
FROM CERTIFICATION_ARCHIVE
JOIN CANDIDATE ON CANDIDATE.CANDIDATE_ID=CERTIFICATION_ARCHIVE.CANDIDATE_ID
JOIN TRAINING ON TRAINING.TRAINING_ID=CERTIFICATION_ARCHIVE.TRAINING_ID
GROUP BY CANDIDATE.CANDIDATE_ID 
HAVING TOTAL_NUMBER>1 ;


# QUERY 16 : FIND THE AVERAGE OF THE TOTAL POINTS OF THE CANDIDATES WHO ARE FROM PRISHTINE

SELECT COUNT(TOTAL_POINTS) AS TOTAL_NUMBER_OF_CANDIDATES, SUM(TOTAL_POINTS) AS TOTAL_POINTS ,AVG(TOTAL_POINTS) AS AVERAGE_POINTS
FROM EVALUATION
JOIN CANDIDATE ON CANDIDATE.CANDIDATE_ID=EVALUATION.CANDIDATE_ID
WHERE CANDIDATE.CANDIDATE_CITY='PRISHTINE';

# QUERY 17 : GET THE PHONE NUMBERS FOR PROFESSORS

SELECT STAFF.MEMBER_NAME, STAFF.MEMBER_LNAME, STAFF.PHONE_NUMBER
FROM STAFF
JOIN PROFESSOR ON PROFESSOR.STAFF_ID=STAFF.STAFF_ID;

# QUERY 18 : ORDER THE CANDIDATES FROM YOUNGEST TO OLDEST

SELECT *
FROM CANDIDATE
GROUP BY CANDIDATE_DATE_OF_BIRTH
ORDER BY CANDIDATE_DATE_OF_BIRTH DESC;


# QUERY 19 : FIND THE TOTAL NUMBER OF OUR MALE AND FEMALE CANDIDATES RESPECTIVELY

  SELECT SUM(CASE WHEN CANDIDATE.CANDIDATE_GENDER = 'M' THEN 1 ELSE 0 END) MALE,
  SUM(CASE WHEN CANDIDATE.CANDIDATE_GENDER = 'F' THEN 1 ELSE 0 END) FEMALE,
  COUNT(*) TOTAL
FROM CANDIDATE;
  
# QUERY 20 : GET THE NAMES OF STAFF MEMBERS THAT HAVE A MASTERS DEGREE

SELECT STAFF.MEMBER_NAME, STAFF.MEMBER_LNAME, QUALIFICATIONS.EDUCATION_DEGREE
FROM STAFF
JOIN QUALIFICATIONS ON  QUALIFICATIONS.STAFF_ID = STAFF.STAFF_ID
WHERE EDUCATION_DEGREE= 'MASTERS DEGREE';

# QUERY 21 : GET THE NAMES OF STAFF MEMBERS THAT HAVE HAD PRIOR EXPERIENCE IN THEIR JOB AS PROFESSOR

SELECT STAFF.MEMBER_NAME, STAFF.MEMBER_LNAME, STAFF.TITLE, QUALIFICATIONS.PRIOR_EXPERIENCE
FROM STAFF
JOIN QUALIFICATIONS ON QUALIFICATIONS.STAFF_ID = STAFF.STAFF_ID
WHERE(CASE WHEN PRIOR_EXPERIENCE = 'TRUE' THEN 0 ELSE 1 END) 
AND STAFF.TITLE = 'PROFESSOR';

# QUERY 22 : GET THE DATE WHERE THERE HAVE BEEN PAYMENTS FOR THE TRAINING 'ARTIFICIAL INTELLIGENCE'

SELECT TRAINING_NAME, PAYMENT_DATE FROM PAYMENT JOIN TRAINING
ON PAYMENT.TRAINING_ID = TRAINING.TRAINING_ID
WHERE TRAINING_NAME = 'ARTIFICIAL INTELLIGENCE';

# QUERY 23 : GET THE NAMES OF STAFF MEMBERS THAT ARE MARRIED

SELECT  * FROM STAFF WHERE RELATIONSHIP_STATUS = 'MARRIED';


# QUERY 24 : GET THE NAMES OF STAFF MEMBERS WHOSE AGE IS GREATER THAN 30

SELECT STAFF.MEMBER_NAME, STAFF.MEMBER_LNAME,SYSDATE(),MEMBER_DATE_OF_BIRTH,DATEDIFF(SYSDATE(),MEMBER_DATE_OF_BIRTH)/365 AS AGE
FROM STAFF WHERE(DATEDIFF(SYSDATE(), MEMBER_DATE_OF_BIRTH)/365)>30;







