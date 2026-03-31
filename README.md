🎬 Netflix Data Analysis & Database Normalization (SQL Project)

📌 Overview

This project demonstrates end-to-end data analysis and database design using the Netflix dataset.
It covers **data cleaning, exploratory data analysis (EDA), and advanced database normalization**, simulating real-world data engineering workflows.

---

🎯 Key Objectives

* Clean and preprocess raw data using SQL
* Perform insightful exploratory data analysis (EDA)
* Convert denormalized data into a normalized relational schema
* Implement many-to-many relationships using mapping tables
* Optimize queries for performance

---

🛠️ Tech Stack

* **SQL (MySQL)**
* **Excel** (initial data exploration)
* *(Optional)* Power BI / Tableau for visualization

---

📂 Project Structure

```bash
data/
    netflix_titles.csv

sql/
  Project Netflix.sql

README.md
```

---

🧹 Data Cleaning

Performed key preprocessing steps:

* Converted `date_added` to proper DATE format
* Extracted year and created derived columns
* Handled null and missing values
* Removed duplicate records
* Standardized categorical fields

---

📊 Exploratory Data Analysis (EDA)

Key insights generated:

* Distribution of Movies vs TV Shows
* Year-wise content growth trend
* Top countries producing Netflix content
* Most frequent genres
* Percentage distribution by type per year using window functions

---

🧠 Database Normalization (Advanced 🔥)

📉 Problem

The dataset contained multi-valued columns:

* `cast` → multiple actors in one field
* `listed_in` → multiple genres
* `country` → multiple countries

This violates normalization rules and leads to redundancy.

---

✅ Solution

The dataset was normalized into multiple relational tables:

Main Table

* `netflix_titles`

Dimension Tables

* `actors`
* `genres`
* `countries`

Bridge Tables (Many-to-Many Relationships)

* `show_actors`
* `show_genres`
* `show_countries`

---

🏗️ Database Design

* One show → many actors
* One actor → many shows
* One show → many genres
* One genre → many shows
* One show → many countries

Implemented using **bridge tables with foreign keys**.

---

⚡ Challenges & Solutions

| Challenge                     | Solution                          |
| ----------------------------- | --------------------------------- |
| Comma-separated values        | Split using SQL string functions  |
| Foreign key constraint errors | Added primary keys and indexing   |
| Slow queries (`FIND_IN_SET`)  | Used batching and optimized joins |
| Large query timeouts          | Processed data in chunks          |

---

📈 Sample Insights

* Movies dominate the platform, but TV Shows are steadily increasing
* The United States produces the majority of content
* Drama and International genres are the most common

---

🚀 Future Improvements

* Build interactive dashboard using Power BI / Tableau
* Add more normalized entities (directors, production companies)
* Optimize schema with indexing and constraints
* Automate ETL pipeline

---

💼 What This Project Demonstrates

* Strong SQL fundamentals
* Real-world data cleaning techniques
* Database design & normalization skills
* Query optimization and performance handling

---

👨‍💻 Author

**Karan Patel**

---

⭐ Support

If you found this project useful, consider giving it a ⭐ on GitHub!
