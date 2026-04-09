# PlatinumRx Data Analyst Assignment

## Objective
This repository contains the solution for the PlatinumRx Data Analyst assessment covering Database Management (SQL), Data Manipulation (Spreadsheets), and Programming Logic (Python).

## Directory Structure
- **`SQL/`**: Contains schema setup and query scripts. Standard ANSI SQL / PostgreSQL dialect used where applicable.
  - `01_Hotel_Schema_Setup.sql`
  - `02_Hotel_Queries.sql`
  - `03_Clinic_Schema_Setup.sql`
  - `04_Clinic_Queries.sql`
- **`Spreadsheets/`**: Contains the generated `.xlsx` analysis file.
  - `Ticket_Analysis.xlsx` 
- **`Python/`**: Contains python scripts.
  - `01_Time_Converter.py`
  - `02_Remove_Duplicates.py`

## Instructions
- **SQL**: You can run the schema setup scripts to load the tables and sample data in MySQL, PostgreSQL, or online tools like DB Fiddle. The query scripts provide the specific solutions.
- **Python**: Run the python scripts in your terminal using `python3 01_Time_Converter.py` and `python3 02_Remove_Duplicates.py`. The scripts include basic test cases to demonstrate correct output.
- **Spreadsheets**: Open `Ticket_Analysis.xlsx` using MS Excel or Google Sheets. Features implemented include:
  - `ticket` tab: Helper logic added via string/date manipulation to check matching day and hour.
  - `feedbacks` tab: `INDEX-MATCH` usage to retrieve the `created_at` timestamp.
  - `Analysis` tab: `COUNTIFS` structure to fetch outlet-wise counts of tickets created and closed in the same day and same hour.
