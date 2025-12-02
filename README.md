# HALLOWEEN-SQL-CHALLENGE
Solved the 'Haunted House Escape' SQL challenge by Ms. Mary Knoeferl. Imported the provided SQLite database into Jupyter, connected it to a PostgreSQL server via pgAdmin, and wrote SQL queries to answer the challenge questions and escape the rooms.

## Overview
This project contains my complete solutions to the **"Haunted House Escape" SQL Challenge** designed by Ms. Mary Knoeferl.  
The challenge provides a SQLite database (`haunted_house_escape.db`) containing multiple themed tables.  
To escape each room of the haunted house, specific SQL puzzles must be solved.

I imported the SQLite database into **Jupyter Notebook**, connected it to a **PostgreSQL server using pgAdmin**, and wrote SQL queries in pgAdmin to solve all **8 challenge rooms**.

## Database Setup
# 1. SQLite Database
- Located in the repository as `haunted_house_escape.db`
- Can be opened in Jupyter Notebook and/or imported into PostgreSQL
# 2. PostgreSQL Connection via pgAdmin
- Create a PostgreSQL DB named `haunted_house_escape`
- Import SQLite tables or manually create them, I imported them using Jupyter notebook
- Execute all SQL queries in pgAdmin

- ## Project Structure
haunted-house-escape/
├── haunted_house_escape.db          # SQLite database with haunted house data
├── haunted_house_escape.ipynb       # Jupyter notebook with data exploration
├── haunted_house_escape_queries.sql # SQL solutions for all 8 rooms
├── Haunted House Escape SQL Challenge - mknoeferl.pdf  # Challenge instructions
└── README.md                        # Project documentation

## Database Schema
The haunted house contains 12 interconnected tables:
- **ghosts** - Information about spirits haunting the house
- **portraits** - Cursed paintings with their subjects
- **meals** - Poisoned dinner courses served to guests
- **authors** - Writers of mysterious books
- **books** - Volumes in the haunted library
- **rooms** - Laboratory chambers for experiments
- **experiments** - Scientific trials with success rates
- **tombstones** - Graveyard markers with epitaphs
- **chimes** - Clock tower bell rings
- **keys** - Magical keys with power levels
- **locks** - Doors that need specific keys
- **attempts** - Records of key-lock combinations

### Room Challenges & Solutions
## Room 1: The Entryway
**Challenge:** Find the sum of favorite numbers for ghosts whose names start with 'B' and haunt the Entryway.
sql
SELECT name, SUM(favorite_number) AS sum_fnums 
FROM ghosts
WHERE haunting_room = 'Entryway' AND name LIKE 'B%'
GROUP BY name;
**Explanation**:
  Filter ghosts haunting the Entryway
  Only include names starting with B
  Sum their favorite_number
  Group by name to list each ghost individually

## Room 2: The Hall of Portraits
**Challenge:** Find the oldest painting to reveal the next clue.
sql
SELECT * FROM portraits
WHERE painted_year = (SELECT MIN(painted_year) FROM portraits);
**Explanation**:
  Find the minimum painted year
  Return the painting(s) matching that year - the oldest portrait

## Room 3: The Dining Hall
**Challenge:** Find all course types where the average poison level exceeds 7.
sql
SELECT course, AVG(poison_level) AS avg_poison_level 
FROM meals
GROUP BY course
HAVING AVG(poison_level) > 7;
**Explanation**:
  Group meals by course
  Calculate average poison level
  Filter groups using HAVING, not WHERE (because it acts on aggregates)

## Room 4: The Library
**Challenge:** Return titles and authors for books written by authors who died before 1900.
sql
SELECT a.name, b.title
FROM authors a
LEFT JOIN books b ON a.author_id = b.author_id
WHERE a.death_year < 1900
**Explanation**:
  Use a LEFT JOIN to connect authors → books
  Filter authors whose death_year < 1900
  Return book titles + author names

## Room 5: The Laboratory
**Challenge:** Find the experiment with the highest success rate.
sql
SELECT * FROM experiments
WHERE success_rate = (SELECT MAX(success_rate) FROM experiments);
**Explanation**:
  Identify maximum success rate
  Return experiments that match it(Handles ties automatically)

## Room 6: The Graveyard
**Challenge:** Classify deaths as 'Peaceful' (old age) or 'Tragic' (other causes).
sql
SELECT name, cause_of_death,
    CASE 
        WHEN cause_of_death = 'old age' THEN 'Peaceful' 
        ELSE 'Tragic' 
    END AS peacefulness
FROM tombstones;
**Explanation**:
  Use a CASE statement to define a new column
  If death caused by “old age” - Peaceful, Otherwise - Tragic

## Room 7: The Clock Tower
**Challenge:** Find the chime that was louder than the one before it.
sql
WITH cte AS (
    SELECT *, LAG(volume) OVER() AS pre_volume 
    FROM chimes
    ORDER BY chime_id
)
SELECT chime_id FROM cte
WHERE volume < pre_volume;
**Explanation**:
  LAG() window function retrieves previous row’s volume
  Compare each chime’s volume with the previous one
  Return the chime_id where this increase happened

## Room 8: The Final Door
**Challenge:** Find the door that can be opened by the key with the highest average power level among successful attempts.
sql
WITH cte AS (
    SELECT k.key_id, a.lock_id, AVG(power_level) AS avg_power 
    FROM keys k
    JOIN attempts a ON k.key_id = a.key_id
    WHERE a.success = 1
    GROUP BY k.key_id, a.lock_id
    ORDER BY avg_power DESC
    LIMIT 1
)
SELECT l.door_name FROM locks l
JOIN cte c ON c.lock_id = l.lock_id;
**Explanation**:
  Filter successful attempts
  Compute average power per key–lock pair
  Pick the strongest combination (ORDER BY … LIMIT 1)
  Return the door associated with that lock

----- Demonstrated skills in: Aggregations, Filtering, Subqueries, Conditional logic, Window functions, CASE expressions, JOINs, CTEs -----

### GETTING STARTED (JUPYTER NOTEBOOK)
## Prerequisites
bash
pip install pandas sqlalchemy psycopg2-binary jupyter

## Running the Project
1. Clone the repository
2. Open the Jupyter notebook:
   bash
   jupyter notebook haunted_house_escape.ipynb
3. Run the cells to explore the database
4. Execute queries from haunted_house_escape_queries.sql to solve each room

## Database Migration
The project includes code to migrate from SQLite to PostgreSQL: (as my pc has PostgreSQL)
python
import sqlite3
import pandas as pd
import sqlalchemy as sal
# Connect to SQLite
sqlite_conn = sqlite3.connect("haunted_house_escape.db")
# Connect to PostgreSQL
engine = sal.create_engine('postgresql://user:password@localhost:5432/haunted_house_escape')
# Transfer tables
tables = ['ghosts', 'portraits', 'meals', 'authors', 'books', 'rooms', 
          'experiments', 'tombstones', 'chimes', 'keys', 'locks', 'attempts']
for table in tables:
    df = pd.read_sql(f'SELECT * FROM {table}', sqlite_conn)
    df.to_sql(table, engine, if_exists='replace', index=False)

##  Technologies Used
- SQLite - Original database format
- PostgreSQL - Database migration target
- SQLAlchemy - Database connectivity
- Jupyter Notebook - Interactive development environment
- Python pandas - Data processing, manipulation and analysis

##  Learning Outcomes
This project demonstrates proficiency in:
- Writing complex SQL queries for real-world scenarios
- Database design and relationships
- Data migration between database systems
- Python-SQL integration
- Problem-solving with SQL

##  Author - **Pragna Nunna**

##  Acknowledgments
- Challenge created by **Ms. Mary Knoeferl** (you can visit her linkedin profile for more such challenges)
- Halloween-themed SQL challenge for educational purposes

## 📝 License
This project is for educational purposes.


**Happy Haunting! 👻🔍**
