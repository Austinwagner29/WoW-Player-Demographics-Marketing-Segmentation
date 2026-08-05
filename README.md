# World of Warcraft Player Demographics and Marketing Segmentation
<img width="1365" height="453" alt="image" src="https://github.com/user-attachments/assets/6c4e7f4f-8e53-4c18-8b1b-8c4158b7e948" />


# **Background and Overview**
Blizzard Entertainment is the developer and publisher of *"World of Warcraft"*. World of Warcraft is a massive multiplayer online role-playing video game where players can immerse themselves in an enormous online world. Blizzard Entertainment released "World of Warcraft" in the year 2004, and as of today in 2026, the World of Warcraft player base is thriving with new content releases and game updates.

By analyzing patterns and trends pertaining to the player base, valuable insights can be identified to assist Blizzard's marketing team with future promotional events and marketing campaigns. With the new expansion being released at the end of this year, Blizzard's strategic priorities include discovering trends between Class and Role preferences, gameplay preferences, and engagement levels across all three demographics.

<br>

To support strategic decision-making, the dataset contains survey responses from 100 unique players covering several key categories:
- **Gender:** Player demographic used to identify trends and preferences across different player segments.
  
- **Server:** Preferred gameplay style (PvE, PvP, or RP) used to analyze player interests and marketing opportunities.
  
- **Class:** Primary character class selected by each player when entering the game to identify class popularity across demographics.
  
- **Role:** Preferred player role (DPS, Tank, or Healer) used to uncover role preferences and participation trends.
  
- **Max-Level Characters:** Number of max-level characters owned by each player, used as a measure of player engagement.

<br>

**Dataset Limitation:** This analysis is based on a survey of 100 unique players and should be considered a representative sample rather than the entire World of Warcraft player base. While the findings provide valuable insights into player demographics and preferences, a larger sample size would improve confidence in the results and better represent the broader player population.

<img width="1006" height="202" alt="image" src="https://github.com/user-attachments/assets/5ccb03f8-edb4-4748-bd00-f9a21c97e773" />


<br>

The complete SQL analysis, including all data cleaning, queries, and business questions, can be viewed [Here](https://github.com/Austinwagner29/World-of-Warcraft-Player-Demographics-Marketing-Segmentation/blob/main/WoW_project.sql).

The interactive Power BI dashboard used to visualize the results of this analysis can be found here.

# Project Objective
- Analyze player demographics and gameplay preferences
- Identify the players class and role selection based off gender
- Evaluate the engagement rate across demographics
- Provide data-driven recommendations to Blizzard Entertainment's marketing team

# Key Metrics

- **Player Count** - Tracking the total number of players across demographics to identify audience size and segmentation opportunities.
  
- **Engagement levels** - Measures activity levels across all three demographics to identify players participation.
  
- **Class percentage** - Calculating the percentage distribution of class preferences amongst all demographics to identify the level of popularity for each class
  
- **Role percentage** - Calculating  the percentage distribution of player roles across each gender to uncover role preferences.
  
- **Average Max-Level Characters** - Measuring which demographic illustrates the highest level of engagement identify the most active player base




# Executive Summary
After analyzing the data, there are clear patterns in class and role preferences across gender demographics. While the Female and Other gender demographic heavily leans towards playing the DPS role with a shared interest for the *"Druid"* class, Male players show a more balanced distribution across all roles with the *"Monk"* class being the strongest preference. With *"PvE"* being the most popular gameplay style, Blizzard's marketing team would benefit greatly from focusing on the PvE community as its primary focus in future marketing campaigns and promotional events.


# Insights Deep Dive
### Class/Role Patterns and Trends
- DPS is the dominant role across all three gender demographics, with Female (84.48%) and Other players (85.71%) showing the strongest preference.

- Male players show the most balanced role distribution across all roles. Participation in the healer role for Male players (42.86%) was only slightly higher than Female players (39.66%) and Other players (35.71%)
  
- Tank is the least selected role among all three demographics, but Male players show a significantly higher percentage in the Tank role (39.29%) compared to Female (27.59%) and Other players (14.29%)

- Druid shows the largest percentage out of all classes for Female and Other players, while for Male players, the Monk class is the most favored. Death Knight and Hunter reflect consistency among all three demographics

<br>

### Gameplay Preferences
- PvE has the highest popularity between all three gameplay styles. This is a valuable insight for the marketing team to focus on the primary audience

- Players in the Other demographic show a stronger interest in the RP gameplay style over PvE and PvP. This will be a major factor in the following section regarding engagement levels.
  
- PvP is the least represented gameplay style across all three gender demographics.

<br>

### Engagement level
- The Other gender demographic shows the highest average number of max-level characters (3.42), indicating the highest level of player engagement within this survey.

- Female players represent the largest portion of the survey while maintaining the second highest engagement average number of max-level character (2.91).
  
- Male players recorded the lowest average number of max-level characters (2.59), suggesting lower overall engagement relative to the Female and Other demographics within this survey.

<br>

# Recommendations
- A promotional event tailored towards the most popular classes such as Druid, Death Knight, Hunter, and/or Monk should increase engagement among the surveyed player segments. This can be achieved by introducing class specific armor sets or exclusive class-themed mounts in Blizzard's next promotional event. Aligning promotional content with players existing class preferences may increase participation and increase overall participation levels for future events.

- Both PvE and the Female player base represent the largest segment within this survey, Blizzard's marketing team should prioritize their seasonal trailers that include new raids and dungeons, new PvE progression systems, and unveil new story mode campaign to get players excited. Emphasizing content most players already enjoy could increase player interest and participation which may drive overall engagement levels. 

- Role-playing represents a smaller but meaningful gameplay segment. Adding role-playing cosmetic items through promotional events, the in-game store, or the monthly trading-post for players to obtain would increase the activity and engagement within their own role-playing groups.

- PvP recorded the lowest participation among all three gameplay styles. Blizzard's marketing team should incentivize unique PvP exclusive rewards such as Mounts, PvP armor sets, cosmetic weapon illusions, and tabards. Blizzard should also further investigate the state of the PvP gameplay with player surveys on how to improve with future game updates and content releases with the help of the development team.

- Although Male players have the lowest level of engagement out of all three demographics, its important to note they have the highest individual max-level character count. It would be worth investigating to see how Blizzard can increase the engagement level with Male players to potentially promote new growth.
