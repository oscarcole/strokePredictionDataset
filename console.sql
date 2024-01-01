/* Average age of patients diagnosed with heart disease vs those without heart disease? This could show if age is a
   risk factor. */

-- Create CTE for Query pulling Age, Heart Disease, and Diagnosis
WITH 'Heart_Disease_Age_CTE' AS(
    SELECT patient_data.'age', stroke_data."Heart Disease", stroke_data.'diagnosis'
    FROM patient_data
    LEFT JOIN stroke_data
    ON patient_data."Patient ID" = stroke_data."Patient ID"
)

-- Query pulling from 'Heart_Disease_Age_CTE'
SELECT
    CASE
	    WHEN "Heart Disease" = '0' THEN 'Without Heart Disease'
        WHEN "Heart Disease" = '1' THEN 'With Heart Disease'
    END AS "Heart Disease Status",
    AVG(Age) AS "Average Age"
FROM Heart_Disease_Age_CTE

-- Filters by stroke diagnosis
WHERE "Diagnosis"
          IN ('No Stroke' , 'Stroke')

-- Group clause divvying up result into two rows
GROUP BY
    CASE
	    WHEN "Heart Disease" = '0' THEN 'Without Heart Disease'
        WHEN "Heart Disease" = '1' THEN 'With Heart Disease'
    END;




-- Percentage of patients with high blood pressure (hypertension) that also have heart disease.
SELECT COUNT(*) * 100 /
	(SELECT COUNT(*)
     FROM stroke_data
     WHERE "Systolic BP" > 130
     AND "Diastolic BP" > 80)
     AS "HBP patients with Heart Disease"
FROM stroke_data
WHERE "Hypertension" = '1';




-- Average BMI of patients with vs without heart disease.

SELECT
    CASE
        WHEN "Heart Disease" = '1' THEN 'Avg BMI with HD'
        WHEN "Heart Disease" = '0' THEN 'Avg BMI without HD'
    END AS "Category",
    AVG("Body Mass Index (BMI)") AS "Average BMI"
FROM
    stroke_data
WHERE
    "Heart Disease" IN ('1', '0')
GROUP BY
    CASE
        WHEN "Heart Disease" = '1' THEN 'Avg BMI with HD'
        WHEN "Heart Disease" = '0' THEN 'Avg BMI without HD'
    END;




-- Percentage of patients with heart disease smoke vs patients without heart disease.

SELECT
    CASE
	    WHEN "Smoking Status" = 'Non-smoker'-- non smoking
            THEN 'Non-smoking Stroke Patients'
        WHEN "Smoking Status" = 'Currently Smokes' -- smokers
            THEN 'Smoking Stroke Patients'
        WHEN "Smoking Status" = 'Formerly Smoked' -- former smokers
            THEN 'Formerly Smoking Stroke Patients'
    END AS "Category",
    COUNT("Smoking Status") AS "Smokers and Non-Smokers with Heart Disease",
    COUNT("Smoking Status") * 100.0 / (SELECT COUNT(*)
                                       FROM stroke_data
                                       WHERE Diagnosis = 'Stroke') AS "Percentage"
FROM stroke_data
WHERE "Heart Disease" = '1'
AND Diagnosis = 'Stroke'
GROUP BY
    CASE
	    WHEN "Smoking Status" = 'Non-smoker'
            THEN 'Non-smoking Stroke Patients'
        WHEN "Smoking Status" = 'Currently Smokes'
            THEN 'Smoking Stroke Patients'
        WHEN "Smoking Status" = 'Formerly Smoked'
            THEN 'Formerly Smoking Stroke Patients'
    END;




-- Percentage of patients with heart disease have a family history of stroke vs those without.

SELECT
    CASE
	    WHEN "Family History of Stroke" = 'Yes'
            THEN 'Family History of Stroke'
        WHEN "Family History of Stroke" = 'No'
            THEN 'No Family History of Stroke'
    END AS 'Category',
        COUNT("Family History of Stroke") AS "Count of Patients",  -- Counts all family history with stroke
        COUNT("Family History of Stroke") * 100 / (SELECT COUNT(*)  -- Calcs percentage of all family history with stroke
    FROM stroke_data
    WHERE Diagnosis = 'Stroke') AS "Percentage"
FROM stroke_data
WHERE "Heart Disease" = '1'
AND Diagnosis = 'Stroke'
GROUP BY
    CASE
	    WHEN "Family History of Stroke" = 'Yes'
            THEN 'Family History of Stroke'
        WHEN "Family History of Stroke" = 'No'
            THEN 'No Family History of Stroke'
    END;




-- Average glucose level of patients with vs without heart disease
SELECT
    CASE
	    WHEN "Heart Disease" = '0'
		    THEN 'Patients w/o Heart Disease' -- when heart disease == False
        WHEN "Heart Disease" = '1'
	        THEN 'Patients with Heart Disease' -- when heart disease == True
    END AS 'Category',
    (SELECT AVG("Average Glucose Level")) AS 'Avg Glucose'
    FROM stroke_data
    WHERE Diagnosis = 'Stroke'
    GROUP BY CASE
        WHEN "Heart Disease" = '0'
	        THEN 'Patients w/o Heart Disease'
        WHEN "Heart Disease" = '1'
	        THEN 'Patients with Heart Disease'
    END;




-- Percentage of patients with heart disease live a sedentary lifestyle compared to active patients.

SELECT
    CASE
	    WHEN "Physical Activity" = 'High' THEN 'High Activity'
        WHEN "Physical Activity" = 'Moderate' THEN 'Moderate Activity'
        WHEN "Physical Activity" = 'Low' THEN 'Sedentary'
    END AS 'Category',
    COUNT("Physical Activity") AS 'Count of Patients',
    COUNT("Physical Activity") * 100 / (SELECT COUNT(*)
                                        FROM stroke_data
                                        WHERE "Heart Disease" = '1') AS 'Percentage'
FROM stroke_data
WHERE "Heart Disease" = '1'
    GROUP BY CASE
        WHEN "Physical Activity" = 'High' THEN 'High Activity'
        WHEN "Physical Activity" = 'Moderate' THEN 'Moderate Activity'
        WHEN "Physical Activity" = 'Low' THEN 'Sedentary'
    END;




-- Average stress level of patients with vs without heart disease.

SELECT
    CASE
		WHEN "Heart Disease" = '0'
			THEN 'AVG stress levels w/o Heart Disease'
        WHEN "Heart Disease" = '1'
	        THEN 'AVG stress levels with Heart Disease'
        END AS "Category",
    AVG("Stress Levels") AS "Average Stress Levels"
FROM stroke_data
WHERE "Heart Disease" IN ('0', '1')
GROUP BY
    CASE
	    WHEN "Heart Disease" = '0'
		    THEN 'AVG stress levels w/o Heart Disease'
          WHEN "Heart Disease" = '1'
	          THEN 'AVG stress levels with Heart Disease'
        END;




-- Dietary habits are most common in patients with heart disease vs those without.

SELECT "Dietary Habits" AS 'Diet',
       COUNT("Dietary Habits") AS 'Popularity'
FROM stroke_data
GROUP BY "Dietary Habits";




-- Average HDL and LDL cholesterol of patients with vs without heart disease.

SELECT
    CASE
	    WHEN "Heart Disease" = '0' THEN 'w/o Heart Disease'
        WHEN "Heart Disease" = '1' THEN 'with Heart Disease'
    END AS 'Category',
    (SELECT AVG("HDL") AS "Average HDL"),
    (SELECT AVG("LDL") AS "Average LDL")
FROM stroke_data
GROUP BY CASE
        WHEN "Heart Disease" = '0' THEN 'w/o Heart Disease'
        WHEN "Heart Disease" = '1' THEN 'with Heart Disease'
    END;
