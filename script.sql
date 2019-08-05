#########################
#  automated dashboard  #
#########################

#rename columns
ALTER TABLE `studentperformance` CHANGE `race/ethnicity` `race_ethnicity` VARCHAR(255);
ALTER TABLE `studentperformance` CHANGE `parental level of education` `parent_education` VARCHAR(255);
ALTER TABLE `studentperformance` CHANGE `test preparation course` `prep_course` VARCHAR(255);
ALTER TABLE `studentperformance` CHANGE `math score` `math` INT;
ALTER TABLE `studentperformance` CHANGE `reading score` `reading` INT;
ALTER TABLE `studentperformance` CHANGE `writing score` `writing` INT;

#query all
SELECT * FROM studentperformance;

#query gender, subject, avg_score
SELECT gender, "math" AS "subject", AVG(math) AS "avg_score"
	FROM studentperformance
	GROUP BY gender 
UNION SELECT gender, "reading" AS "subject", AVG(reading) AS "avg_score"
	FROM studentperformance
	GROUP BY gender 
UNION SELECT gender, "writing" AS "subject", AVG(writing) AS "avg_score"
	FROM studentperformance
	GROUP BY gender;

#query race_ethnicity, subject, avg_score
SELECT race_ethnicity, "math" AS "subject", AVG(math) AS "avg_score"
	FROM studentperformance
	GROUP BY race_ethnicity 
UNION SELECT race_ethnicity, "reading" AS "subject", AVG(reading) AS "avg_score"
	FROM studentperformance
	GROUP BY race_ethnicity 
UNION SELECT race_ethnicity, "writing" AS "subject", AVG(writing) AS "avg_score"
	FROM studentperformance
	GROUP BY race_ethnicity;

#query parent_education, subject, avg_score
SELECT parent_education, "math" AS "subject", AVG(math) AS "avg_score"
	FROM studentperformance
	GROUP BY parent_education 
UNION SELECT parent_education, "reading" AS "subject", AVG(reading) AS "avg_score"
	FROM studentperformance
	GROUP BY parent_education 
UNION SELECT parent_education, "writing" AS "subject", AVG(writing) AS "avg_score"
	FROM studentperformance
	GROUP BY parent_education;    

#query lunch, subject, avg_score
SELECT lunch, "math" AS "subject", AVG(math) AS "avg_score"
	FROM studentperformance
	GROUP BY lunch 
UNION SELECT lunch, "reading" AS "subject", AVG(reading) AS "avg_score"
	FROM studentperformance
	GROUP BY lunch 
UNION SELECT lunch, "writing" AS "subject", AVG(writing) AS "avg_score"
	FROM studentperformance
	GROUP BY lunch;
    
#query prep_course, subject, avg_score
SELECT prep_course, "math" AS "subject", AVG(math) AS "avg_score"
	FROM studentperformance
	GROUP BY prep_course 
UNION SELECT prep_course, "reading" AS "subject", AVG(reading) AS "avg_score"
	FROM studentperformance
	GROUP BY prep_course 
UNION SELECT prep_course, "writing" AS "subject", AVG(writing) AS "avg_score"
	FROM studentperformance
	GROUP BY prep_course;
    
