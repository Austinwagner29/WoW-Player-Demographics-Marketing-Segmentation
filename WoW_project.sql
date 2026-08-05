-- Project Goal: 
-- Analyze World of Warcraft player demographics and gameplay preferences to identify meaningful customer segments and provide marketing recommendations.


/* ================================================
   DATA CLEANING AND VALIDATION
   ================================================ 


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
FROM `austin-wagner-projects.WoW_Demographics.Full Table`
GROUP BY Gender
ORDER BY Gender;

-- Repeated this process across the dataset.

-- Checked for spelling errors in the more congested columns such as  "Role", "Class", and "Race"

SELECT
    TRIM(Split_Roles) AS Role,
    COUNT(*) AS Num_of_counts
FROM `austin-wagner-projects.WoW_Demographics.Full Table`,
UNNEST(SPLIT(Role, ', ')) AS Split_Roles
GROUP BY Role
ORDER BY Role;

SELECT
    TRIM(Split_classes) AS Class,
    COUNT(*) AS Num_of_counts
FROM `austin-wagner-projects.WoW_Demographics.Full Table`,
UNNEST(SPLIT(Class, ', ')) AS Split_classes
GROUP BY Class
ORDER BY Class;

SELECT
    TRIM(Split_Races) AS Race,
    COUNT(*) AS Num_of_counts
FROM `austin-wagner-projects.WoW_Demographics.Full Table`,
UNNEST(SPLIT(Race, ', ')) AS Split_Races
GROUP BY Race
ORDER BY Race;



-- Cleaned and filtered the columns and created new table to work in.


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

FROM `austin-wagner-projects.WoW_Demographics.Full Table`;


-- After the new table is made, lets start asking the important business questions.


/* ==========================================================
   BUSINESS QUESTION 1:

   Are Patterns or Trends between gender and role/class?
   ========================================================== */

    
-- Grouped gender and tracked the total to get insight on what percentage makes up this dataset.


SELECT
  Gender,
  COUNT(*) AS Total_Gender_Count
FROM `austin-wagner-projects.WoW_Demographics.Cleaned Table`
GROUP BY 
  Gender
ORDER BY 
  Total_Count DESC;

/* QUERY RESULTS for Total gender count
+---------+--------------------+
| Gender  | Total_Gender_Count |
+---------+--------------------+
| Female  |          58        |
| Male    |          28        |
| Other   |          14        |
+---------+--------------------+ 
*/

-- Will use the query results above to calculate percentages.
    
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
  Role
ORDER BY
  Percentage DESC;


/* QUERY RESULTS PREVIEW: Total Count for Roles for each gender.
+---------+---------+------------+------------+
| Gender  | Role    | Role_Count | Percentage |
+---------+---------+------------+------------+
| Other   | DPS     |     12     |   85.71%   |
| Female  | DPS     |     49     |   84.48%   |
| Male    | DPS     |     21     |   75.00%   |
| Male    | Healer  |     12     |   42.86%   |
| Female  | Healer  |     23     |   39.66%   |
| Male    | Tank    |     11     |   39.29%   |
| Other   | Healer  |      5     |   35.71%   |
| Female  | Tank    |     16     |   27.59%   |
| Other   | Tank    |      2     |   14.29%   |
+---------+---------+------------+------------+

-- -- Business Insights:
- DPS is the most popular role across every gender demographic.
- Male players show the most balanced role distribution, with relatively higher participation in both Healer (42.86%) and Tank (39.29%) roles.
- Tank is the least selected role among Female (27.59%) and Other (14.29%) players, suggesting a stronger preference toward DPS and Healer roles.
*/

-- Lets investigate the Class percentages now.

SELECT
  Gender,
  TRIM(Class_name) AS Class,
  COUNT(Role) AS Class_Count,

  ROUND(
    COUNT(Class) /
    CASE
      WHEN Gender = 'Female' THEN 58
      WHEN Gender = 'Male' THEN 28
      WHEN Gender = 'Other' THEN 14
    END * 100,
    2
  ) AS Percentage

FROM `austin-wagner-projects.WoW_Demographics.Cleaned Table`
CROSS JOIN UNNEST(SPLIT(Class, ',')) AS Class_name
GROUP BY 
  Gender,
  Class
HAVING
  Percentage > 20
ORDER BY
  Gender DESC,
  Percentage DESC;

/* QUERY RESULTS PREVIEW: Class Count Percentages
+---------+----------------+-------------+------------+
| Gender  | Class          | Class_Count | Percentage |
+---------+----------------+-------------+------------+
| Other   | Druid          |      6      |   42.86%   |
| Other   | Death Knight   |      5      |   35.71%   |
| Other   | Hunter         |      5      |   35.71%   |
| Other   | Demon Hunter   |      4      |   28.57%   |
| Other   | Warlock        |      3      |   21.43%   |
| Other   | Priest         |      3      |   21.43%   |
| Other   | Warrior        |      3      |   21.43%   |
| Male    | Monk           |      8      |   28.57%   |
| Male    | Hunter         |      7      |   25.00%   |
| Male    | Death Knight   |      6      |   21.43%   |
| Male    | Priest         |      6      |   21.43%   |
| Female  | Druid          |     22      |   37.93%   |
| Female  | Hunter         |     19      |   32.76%   |
| Female  | Death Knight   |     17      |   29.31%   |
| Female  | Paladin        |     15      |   25.86%   |
| Female  | Priest         |     14      |   24.14%   |
+---------+----------------+-------------+------------+


-- -- Business Insights:
-- Druid is a popular Class for Female (37.93%%) and Other (42.86%) players while Monk is more popular for Male (28.57%) players.
-- Death knight and Hunter demonstrate consistent popularity across all demographics.


-- Conclusion: Yes, the analysis indicates clear trends in Class/Role preferences across gender demographics. DPS is the dominant role among all three groups, while Druid 
   is the leading class for Female and Other players. Male players, however, show the strongest preference for Monk. Death Knight and Hunter also exhibit consistent 
   popularity across every demographic.


   =======================================================================
   BUSINESS QUESTION 2: 

   How do gameplay preferences (PvE, PvP, and Roleplay) vary across 
   different player demographics, and what opportunities do these trends 
   create for Blizzard's future content and marketing strategies?
   ======================================================================= */

-- Lets investigate the gameplay type based off the demograpic of the player.

SELECT DISTINCT
  TRIM(Split_Server) AS Server_Type,
  COUNT(Split_Server) AS Player_Count
FROM
  `austin-wagner-projects.WoW_Demographics.Cleaned Table`
CROSS JOIN UNNEST (Split(Server, '/')) AS Split_server
GROUP BY
  Server_Type
ORDER BY
  Player_Count DESC;


/* QUERY RESULTS: Overall Gameplay Preference
+-------------+--------------+
| Server_Type | Player_Count |
+-------------+--------------+
| PvE         |      59      |
| RP          |      36      |
| PvP         |      25      |
+-------------+--------------+
*/

-- We can see the overall gameplay preference is PvE, lets take a look if that varies across gender.

SELECT DISTINCT
  Gender,
  TRIM(Split_Server) AS Server_Type,
  COUNT(Split_Server) AS Player_Count
FROM
  `austin-wagner-projects.WoW_Demographics.Cleaned Table`
CROSS JOIN UNNEST (Split(Server, '/')) AS Split_server
GROUP BY
  Gender,
  Server_Type
ORDER BY
  Gender ASC,
  Player_Count DESC;


/* QUERY RESULTS: Gameplay Preference by gender
+--------+-------------+--------------+
| Gender | Server_Type | Player_Count |
+--------+-------------+--------------+
| Female | PvE         |      36      |
| Female | RP          |      20      |
| Female | PvP         |      17      |
| Male   | PvE         |      17      |
| Male   | RP          |       9      |
| Male   | PvP         |       6      |
| Other  | RP          |       7      |
| Other  | PvE         |       6      |
| Other  | PvP         |       2      |
+--------+-------------+--------------+

-- -- Business insights:
-- PvE has the highest popularity among female and male players, with substantially higher participation than either RP or PvP.
-- Players in the Other demographic show a much stronger preference for RP and PvE server types than PvP.
-- PvP is the least represented gameplay style across all three gender demographics.

-- Conclusion: Within this survey, PvE is the most popular gameplay, suggesting that future marketing campaigns and content releases surrounding PvE-focused players would reach the largest audience. 
   However, RP and PvP players should not be overlooked, as they represent meaningful player segments that may benefit and provide growth from targeted events, promotions, and gameplay updates.

-- Recommendation: Blizzard should focus on new content releases around PvE gameplay to maximize reach towards the largest audience. At the same time, Blizzard should still support the RP
   and PvP community through targeted events and active updates to make that portion of the community feel seen and heard which could increase the growth and interest for those gameplay types.


   ==========================================================================
   BUSINESS QUESTION 3

   What player segment appears to be the most engaged based off the number 
   of max-level characters that players has?
   ========================================================================== */

-- Lets investigate on how many players have max-level toons.

SELECT
  STRING_AGG(DISTINCT gender, ', ' ORDER BY Gender) AS Genders,
  `Max Level Characters` AS Max_level_Toons,
  COUNT(Gender) AS Player_Count
FROM
  `austin-wagner-projects.WoW_Demographics.Cleaned Table`
GROUP BY
  Max_Level_Toons
ORDER BY 
  Max_level_toons DESC;

/* QUERY RESULTS: Max-Level Characters by Gender
+----------------------+-----------------+--------------+
| Genders              | Max_Level_Toons | Player_Count |
+----------------------+-----------------+--------------+
| Male                 | 12              | 1            |
| Male                 | 11              | 1            |
| Male                 | 9               | 1            |
| Female, Male         | 7               | 2            |
| Female, Male, Other  | 6               | 10           |
| Female, Male, Other  | 5               | 9            |
| Female, Male, Other  | 4               | 11           |
| Female, Male, Other  | 3               | 11           |
| Female, Male, Other  | 2               | 28           |
| Female, Male, Other  | 1               | 20           |
| Female, Male, Other  | 0               | 6            |
+----------------------+-----------------+--------------+

-- Most players own between 1 to 6 max-level characters in this survey.
-- Male players record the highest individual max-level character (between 9-12) even though this survey represents a small portion of the male demographic.
-- These higher individual max-level character counts contribute to the Male demographic recording the highest average number of max-level characters. This trend may indicate the 
   presence of a highly engaged subgroup and is worth further investigation.

-- Calculating the average number of max-level characters by gender could help greater insight on player engagement.
*/

SELECT
  Gender,
  ROUND(AVG(`Max Level Characters`), 2) AS AVG_Max_Toons,
  Count(*) AS Total_Count
FROM
  `austin-wagner-projects.WoW_Demographics.Cleaned Table`
GROUP BY
  Gender
ORDER BY
  AVG_Max_Toons DESC;

/* QUERY RESULTS: Average Max-Level Characters by Gender

+--------+---------------+-------------+
| Gender | AVG_Max_Toons | Total_Count |
+--------+---------------+-------------+
| Male   | 3.43          | 28          |
| Other  | 2.93          | 14          |
| Female | 2.88          | 58          |
+--------+---------------+-------------+


-- -- Business Insights:
-- The Male gender demographic has the highest average number of max-level characters (3.43), indicating the highest overall engagement.
-- Despite Female players respresent the largest portion of this survey, they recorded the lowest average number of max-level characters (2.88).
-- Although Other players represent the smallest population, they still maintain the second-highest average number of max-level characters level (2.93).

-- Conclusion: A small number of Male players reported 9, 11, and 12 max-level characters, which contributes to the Male demographic recording the highest average number of max-level characters among the 
   three demographics. Although the Female players should still be marketed to due to them making up the largest population in this survey, it is important to note the Other gender demographic record the 
   second-highest engagement.

-- Recommendation: Male players recorded the highest average number of max-level characters within this survey. However, there is a contribuing factor due to them also having the highest individual max-level 
   character count. Blizzard should investigate further among Male players to see if this group is worth marketing towards. The Other gender demographic, although records to lowest population, maintains 
   the second-highest average max-level character, and will still benefit from incorporating events for this player base.
*/
