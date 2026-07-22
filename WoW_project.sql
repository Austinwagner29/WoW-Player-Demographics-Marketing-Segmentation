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



SELECT
  CASE
    WHEN country = 'usa' THEN 'USA'
    WHEN country = 'Méxici' THEN 'Mexico'
    WHEN country = 'England' THEN 'U.K'
    WHEN country = 'România' THEN 'Romania'
    ELSE country
  END AS country
FROM
  `austin-wagner-projects.WoW_Demographics.Full Table`
