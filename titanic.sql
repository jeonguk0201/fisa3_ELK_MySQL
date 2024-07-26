select * from titanic_raw tr ;

create table titan as select * from titanic_raw tr ;
desc titan;
SELECT * from titan;

-- 평균 나이를 계산하여 변수에 저장
SET @avg_age = (SELECT ROUND(AVG(age), 0) FROM titan WHERE age IS NOT NULL);

SELECT sum(age), count(age) from titan;

-- 그 변수를 사용하여 업데이트
UPDATE titan
SET age = @avg_age
WHERE age is null;

ALTER TABLE titan ADD COLUMN age_group VARCHAR(10);

UPDATE titan
SET age_group = CASE
	WHEN age < 0 THEN 'others'
    WHEN age >= 0 AND age < 5 THEN '0-4'
    WHEN age >= 5 AND age < 10 THEN '5-9'
    WHEN age >= 10 AND age < 15 THEN '10-14'
    WHEN age >= 15 AND age < 20 THEN '15-19'
    WHEN age >= 20 AND age < 25 THEN '20-24'
    WHEN age >= 25 AND age < 30 THEN '25-29'
    WHEN age >= 30 AND age < 35 THEN '30-34'
    WHEN age >= 35 AND age < 40 THEN '35-39'
    WHEN age >= 40 AND age < 45 THEN '40-44'
    WHEN age >= 45 AND age < 50 THEN '45-49'
    WHEN age >= 50 AND age < 55 THEN '50-54'
    WHEN age >= 55 AND age < 60 THEN '55-59'
    WHEN age >= 60 AND age < 65 THEN '60-64'
    WHEN age >= 65 AND age < 70 THEN '65-69'
    WHEN age >= 70 AND age < 75 THEN '70-74'
    WHEN age >= 75 AND age < 80 THEN '75-79'
    WHEN age >= 80 AND age < 85 THEN '80-84'
    WHEN age >= 85 AND age < 90 THEN '85-89'
    WHEN age >= 90 AND age < 95 THEN '90-94'
    WHEN age >= 95 AND age < 100 THEN '95-99'
    ELSE NULL
END;
