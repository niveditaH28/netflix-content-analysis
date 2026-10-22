# netflix-content-analysis
# Netflix Content Strategy Analysis

## Business question
What does Netflix's catalog look like, and which content types, genres and regions should a streaming platform prioritise?

## Tools
SQL (MySQL), DBeaver, Power BI (Power Query, DAX)

## Dataset
[Netflix Movies and TV Shows (Kaggle)](https://www.kaggle.com/datasets/shivamb/netflix-shows): 8,807 titles, data through mid-2021.

## Process
1. **Loaded** the CSV into MySQL and verified the row count (8,807).
2. **Cleaned** the data in SQL:
   - 2,634 missing directors and 831 missing countries, filled with "Unknown"
   - 4 missing ratings, labelled "Not Rated"
   - 10 missing dates, left as NULL and excluded from year-based charts
   - Converted text dates (e.g. "September 24, 2021") to a proper DATE column
3. **Analysed** with SQL (aggregations, CTEs, window functions): see `netflix_analysis.sql`.
4. **Visualised** in Power BI. Split the multi-value genre and country columns into separate tables, linked with one-to-many relationships, so every genre and country is counted.
5. One malformed record with shifted columns was removed in Power Query.

## Key findings
- Movies make up **69.6%** of the catalog and TV shows **30.4%**.
- Titles added per year grew from **429 (2016) to 2,016 (2019)**, the peak year, then eased to 1,879 in 2020.
- TV shows' share of additions rose from about **25% (2018) to about 34% (2021)**.
- **Dramas** were the top first-listed genre every year from 2017 to 2021, with Comedies second and Action & Adventure third from 2018.
- The **United States** leads with 3,211 titles (about 36%), followed by **India** (1,008) and the **United Kingdom** (628).

## Recommendation
Catalog growth has moved from rapid expansion (2016 to 2019) to a more selective phase, with TV shows taking a growing share. Keep drama and comedy as core categories and increase TV series investment, the fastest-rising format.

## Limitations
- 2021 is a partial year, so its lower totals are not a decline.
- The SQL genre and country results count only the first value listed; the Power BI dashboard counts all of them, so its numbers are slightly higher.
- The data shows what was added to the catalog, not what people watched.
- About 9% of titles have no country listed.

## Files
- `netflix_analysis.sql`: cleaning and analysis queries
- `netflix_dashboard.pbix`: Power BI dashboard
- `dashboard_overview.png`, `dashboard_deepdive.png`: screenshots

![Overview](dashboard_overview.png)
![Deep Dive](dashboard_deepdive.png)
