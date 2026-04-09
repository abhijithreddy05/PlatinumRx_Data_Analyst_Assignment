-- 1. Find the revenue we got from each sales channel in a given year (Assuming year 2021)
SELECT 
    sales_channel,
    SUM(amount) AS total_revenue
FROM clinic_sales
WHERE EXTRACT(YEAR FROM datetime) = 2021
GROUP BY sales_channel;

-- 2. Find top 10 the most valuable customers for a given year (Assuming year 2021)
SELECT 
    uid,
    SUM(amount) AS total_spent
FROM clinic_sales
WHERE EXTRACT(YEAR FROM datetime) = 2021
GROUP BY uid
ORDER BY total_spent DESC
LIMIT 10;

-- 3. Find month wise revenue, expense, profit , status (profitable / not-profitable) for a given year (Assuming 2021)
WITH MonthlyRevenue AS (
    SELECT 
        EXTRACT(MONTH FROM datetime) AS month,
        SUM(amount) AS total_revenue
    FROM clinic_sales
    WHERE EXTRACT(YEAR FROM datetime) = 2021
    GROUP BY EXTRACT(MONTH FROM datetime)
),
MonthlyExpense AS (
    SELECT 
        EXTRACT(MONTH FROM datetime) AS month,
        SUM(amount) AS total_expense
    FROM expenses
    WHERE EXTRACT(YEAR FROM datetime) = 2021
    GROUP BY EXTRACT(MONTH FROM datetime)
),
Combined AS (
    -- Assuming PostgreSQL dialect where FULL OUTER JOIN is natively supported
    SELECT 
        COALESCE(r.month, e.month) AS month,
        COALESCE(r.total_revenue, 0) AS revenue,
        COALESCE(e.total_expense, 0) AS expense
    FROM MonthlyRevenue r
    FULL OUTER JOIN MonthlyExpense e ON r.month = e.month 
)
SELECT 
    month,
    revenue,
    expense,
    (revenue - expense) AS profit,
    CASE 
        WHEN (revenue - expense) > 0 THEN 'profitable'
        ELSE 'not-profitable'
    END AS status
FROM Combined
ORDER BY month;

-- 4. For each city find the most profitable clinic for a given month (Assuming month 9, year 2021)
WITH ClinicRevenue AS (
    SELECT cid, SUM(amount) AS total_revenue
    FROM clinic_sales
    WHERE EXTRACT(MONTH FROM datetime) = 9 AND EXTRACT(YEAR FROM datetime) = 2021
    GROUP BY cid
),
ClinicExpense AS (
    SELECT cid, SUM(amount) AS total_expense
    FROM expenses
    WHERE EXTRACT(MONTH FROM datetime) = 9 AND EXTRACT(YEAR FROM datetime) = 2021
    GROUP BY cid
),
ClinicProfits AS (
    SELECT 
        c.city,
        c.cid,
        c.clinic_name,
        COALESCE(r.total_revenue, 0) - COALESCE(e.total_expense, 0) AS profit
    FROM clinics c
    LEFT JOIN ClinicRevenue r ON c.cid = r.cid
    LEFT JOIN ClinicExpense e ON c.cid = e.cid
),
RankedProfits AS (
    SELECT 
        city,
        cid,
        clinic_name,
        profit,
        RANK() OVER(PARTITION BY city ORDER BY profit DESC) as rnk
    FROM ClinicProfits
)
SELECT city, clinic_name, profit
FROM RankedProfits
WHERE rnk = 1;

-- 5. For each state find the second least profitable clinic for a given month (Assuming month 9, year 2021)
WITH ClinicRevenue AS (
    SELECT cid, SUM(amount) AS total_revenue
    FROM clinic_sales
    WHERE EXTRACT(MONTH FROM datetime) = 9 AND EXTRACT(YEAR FROM datetime) = 2021
    GROUP BY cid
),
ClinicExpense AS (
    SELECT cid, SUM(amount) AS total_expense
    FROM expenses
    WHERE EXTRACT(MONTH FROM datetime) = 9 AND EXTRACT(YEAR FROM datetime) = 2021
    GROUP BY cid
),
ClinicProfits AS (
    SELECT 
        c.state,
        c.cid,
        c.clinic_name,
        COALESCE(r.total_revenue, 0) - COALESCE(e.total_expense, 0) AS profit
    FROM clinics c
    LEFT JOIN ClinicRevenue r ON c.cid = r.cid
    LEFT JOIN ClinicExpense e ON c.cid = e.cid
),
RankedProfits AS (
    SELECT 
        state,
        cid,
        clinic_name,
        profit,
        DENSE_RANK() OVER(PARTITION BY state ORDER BY profit ASC) as rnk
    FROM ClinicProfits
)
SELECT state, clinic_name, profit
FROM RankedProfits
WHERE rnk = 2;
