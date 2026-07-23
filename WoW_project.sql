-- Project Goal: 
-- Analyze World of Warcraft player demographics and gameplay preferences to identify meaningful customer segments and provide marketing recommendations.


-- DATA Cleaning Process:

/* 
Issues Identified

* Inconsistent country values (Ex. usa changed to USA)
* Missing values
* Spelling Errors
* Multiple Roles in one field
*/


-- Did a simple check for leading or trailing spaces along with distinct values and spelling to see if a clean up for any specific columns were necessary.  

SELECT
    Gender,
    COUNT(*) AS Num_of_counts
FROM `austin-wagner-projects.WoW_Demographics.Cleaned Table`
GROUP BY Gender
ORDER BY Gender;

-- ^ Did this for all columns

-- Also Wanted to check for spelling errors in the more congested columns such as  "Role", "Class", and "Race"

SELECT
    TRIM(Split_Roles) AS Role,
    COUNT(*) AS Num_of_counts
FROM `austin-wagner-projects.WoW_Demographics.Cleaned Table`,
UNNEST(SPLIT(Role, ', ')) AS Split_Roles
GROUP BY Role
ORDER BY Role;

SELECT
    TRIM(Split_classes) AS Class,
    COUNT(*) AS Num_of_counts
FROM `austin-wagner-projects.WoW_Demographics.Cleaned Table`,
UNNEST(SPLIT(Class, ', ')) AS Split_classes
GROUP BY Class
ORDER BY Class;

SELECT
    TRIM(Split_Races) AS Race,
    COUNT(*) AS Num_of_counts
FROM `austin-wagner-projects.WoW_Demographics.Cleaned Table`,
UNNEST(SPLIT(Race, ', ')) AS Split_Races
GROUP BY Race
ORDER BY Race;




-- Cleaned and filtered the necessary columns and created new table to work in


CREATE OR REPLACE TABLE
`austin-wagner-projects.WoW_Demographics.Cleaned Table`
AS

SELECT
    -- No changes
    Timestamp,
    Gender,
    Sexuality,
    Age,
    Attracted,
    Type,


-- Cleaned Country Column
  
    CASE
        WHEN LOWER(TRIM(Country)) = 'usa' THEN 'USA'
        WHEN LOWER(TRIM(Country)) = 'méxici' THEN 'Mexico'
        WHEN LOWER(TRIM(Country)) = 'england' THEN 'United Kingdom'
        WHEN LOWER(TRIM(Country)) = 'scotland' THEN 'United Kingdom'
        WHEN LOWER(TRIM(Country)) = 'uk' THEN 'United Kingdom'
        WHEN LOWER(TRIM(Country)) = 'u.k' THEN 'United Kingdom'
        WHEN LOWER(TRIM(Country)) = 'românia' THEN 'Romania'
        WHEN LOWER(TRIM(Country)) = 'russian federation' THEN 'Russia'
        WHEN LOWER(TRIM(Country)) = 'the netherlands' THEN 'Netherlands'
        ELSE TRIM(Country)
    END AS Country,

  
-- Replaced / Cleaned Values for easier Readability
  
    Main AS `Main Character Gender`,
    Faction,
    CASE
      WHEN `Server` = 'N/A' THEN NULL
      ELSE REPLACE(TRIM(Server), ';', ' / ')
      END AS `Server`,
    REPLACE(Role, ';', ', ') AS Role,
    REPLACE(Class, ';', ', ') AS Class,
    REPLACE(Race, ';', ', ') AS Race,
    Max AS `Max Level Characters`,

FROM `austin-wagner-projects.WoW_Demographics.Full Table`


-- -- Business Question 1: Patterns or Trends between gender and role/class
-- -- Are there any patterns or relationships we can make to focus on a specific audience for the next marketing campaign?


-- Grouped gender and tracked the total to get insight on what percentage makes up this dataset

  SELECT
  Gender,
  COUNT(*) AS Total_Count
FROM `austin-wagner-projects.WoW_Demographics.Cleaned Table`
GROUP BY 
  Gender
ORDER BY 
  Total_Count DESC

  /* Query Results
+---------+-------------+
| Gender  | Total_Count |
+---------+-------------+
| Female  |     58      |
| Male    |     28      |
| Other   |     14      |
+---------+-------------+ 
  */

  -- -- Insights: 58 out of 100 entries are Female, We will circle back to this when calculating the percentage for the number of each role to gender

  -- Lets see the count of "Roles" tied to each gender
  
SELECT
  Gender,
  TRIM(Trimmed_table) AS Role,
  COUNT(*) AS Total_count
FROM `austin-wagner-projects.WoW_Demographics.Cleaned Table`
CROSS JOIN UNNEST(Split(Role, ',')) AS Trimmed_table
GROUP BY
  Gender,
  Role
ORDER BY
  Gender,
  Role,
  Total_Count DESC;


*/ QUERY RESULTS PREVIEW: Total Count for Roles for each gender
+---------+---------+-------------+
| Gender  | Role    | Total_Count |
+---------+---------+-------------+
| Female  | DPS     |      49     |
| Female  | Healer  |      23     |
| Female  | Tank    |      16     |
| Male    | DPS     |      21     |
| Male    | Healer  |      12     |
| Male    | Tank    |      11     |
| Other   | DPS     |      12     |
| Other   | Healer  |       5     |
| Other   | Tank    |       2     |
+---------+---------+-------------+
*/

-- 
