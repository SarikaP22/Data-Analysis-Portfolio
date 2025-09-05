# Baby Name Trend Analysis
### Project Overview
This project analyzes the "U.S. Baby Names" dataset, a comprehensive collection of baby names over three decades, to uncover historical trends and meaningful insights. The goal was to demonstrate an end-to-end data analysis workflow using SQL, from understanding the data to answering specific business questions and delivering key findings.
<br>

### Data Source

**Dataset:** U.S. Baby Names (2 million+ rows)

**Description:** This dataset contains a record of all U.S. baby names broken down by state, gender, and birth year.

**Original Source:** This project uses a publicly available dataset. You can download the complete dataset from [here](https://app.mavenanalytics.io/guided-projects/f71c0a2b-05f4-43fe-a80c-8f3f86964ccc) <br>
**Note:** Due to the large size of the dataset, it is not included in this repository.
<br>

### Methodology
The analysis was structured into four key objectives to explore different aspects of the dataset:

####  
**Objective 1: Track Name Popularity -** Analyzed how the popularity of the most common names has changed over time, and identified names that experienced the biggest jumps in popularity.<br>
[SQL for Objective-1](objective-1.sql)

####  
**Objective 2: Compare Popularity Across Decades -** Found the most popular names for each year and for each decade to compare long-term naming trends.<br>
[SQL for Objective-2](objective-2.sql)

#### Objective 3: 
**Compare Popularity Across Regions:** Calculated the number of births in each of the six U.S. regions and identified the top names within each region to understand regional naming preferences.<br>
[SQL for Objective-3](objective-3.sql)

#### Objective 4: 
**Explore Unique Names:** Identified the most popular androgynous names, and found the shortest and longest names in the dataset to explore unique naming patterns.<br>
[SQL for Objective-4](objective-4.sql)
<br>

### Key Findings
**Popularity Trends:** The analysis revealed shifts in the top-ranked names over the decades, highlighting which names have maintained their popularity and which have faded.

**Androgynous Names:** We identified the top 10 most popular names given to both genders, providing insight into gender-neutral naming trends.

**Name Length:** The analysis successfully identified the shortest and longest names and the most popular names in each category, showing the diversity of name lengths in the U.S.

**Regional Trends:** By breaking down the data by region, we were able to see which names were most popular in specific geographic areas, revealing subtle regional naming customs.
<br>

### Technologies Used
**Language:** SQL

**Database:** SQLite
<br>

### How to Run This Project
**Set Up:** Navigate to the [SQLite Online website](https://sqliteonline.com/). Ensure you have tables loaded with the U.S. Baby Names data.

**Execute Queries:** Open the SQL file on SQLite to run the queries against your database. The file is structured with comments and sections that align with the objectives outlined in this README.
