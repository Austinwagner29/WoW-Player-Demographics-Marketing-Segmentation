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

-- Checked for spelling errors in the more congested columns such as  "Role", "Class", and "Race"

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

/*  
-- Cleaned Country Column
*/
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

/*  
-- Replaced / Cleaned Values for easier Readability
*/
    
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

/*
-- -- Business Question 1: Patterns or Trends between gender and role/class.
-- -- Are there any patterns or relationships we can make to focus on a specific audience for the next marketing campaign?

    
-- Grouped gender and tracked the total to get insight on what percentage makes up this dataset.
*/
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


-- Will use these query results to calculate percentages.
*/
    
SELECT
  Gender,
  TRIM(Role_name) AS Role,
  COUNT(Role) AS Role_Count,

  ROUND(
    COUNT(Role) /
    CASE
      WHEN Gender = 'Female' THEN 58
      WHEN Gender = 'Male' THEN 28
      WHEN Gender = 'Other' THEN 14
    END * 100,
    2
  ) AS Percentage

FROM `austin-wagner-projects.WoW_Demographics.Cleaned Table`
CROSS JOIN UNNEST(SPLIT(Role, ',')) AS Role_name
GROUP BY 
  Gender,
  Role;


/* QUERY RESULTS PREVIEW: Total Count for Roles for each gender.
+---------+---------+------------+------------+
| Gender  | Role    | Role_Count | Percentage |
+---------+---------+------------+------------+
| Female  | DPS     |     49     |   84.48%   |
| Female  | Healer  |     23     |   39.66%   |
| Female  | Tank    |     16     |   27.59%   |
| Male    | DPS     |     21     |   75.00%   |
| Male    | Healer  |     12     |   42.86%   |
| Male    | Tank    |     11     |   39.29%   |
| Other   | DPS     |     12     |   85.71%   |
| Other   | Healer  |      5     |   35.71%   |
| Other   | Tank    |      2     |   14.29%   |
+---------+---------+------------+------------+

-- -- Business Insights:
- DPS is the most popular role across every gender demographic.
- Male players show the most balanced role distribution, with relatively higher participation in both Healer (42.86%) and Tank (39.29%) roles.
- Tank is the least selected role among Female (27.59%) and Other (14.29%) players, suggesting a stronger preference toward DPS and Healer roles.


-- -- Business Question 2: 
