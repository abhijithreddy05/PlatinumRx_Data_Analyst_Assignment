-- 1. For every user in the system, get the user_id and last booked room_no
WITH RankedBookings AS (
    SELECT 
        user_id, 
        room_no,
        ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY booking_date DESC) as rn
    FROM bookings
)
SELECT user_id, room_no
FROM RankedBookings
WHERE rn = 1;

-- 2. Get booking_id and total billing amount of every booking created in November, 2021
SELECT 
    b.booking_id,
    SUM(bc.item_quantity * i.item_rate) AS total_billing_amount
FROM bookings b
JOIN booking_commercials bc ON b.booking_id = bc.booking_id
JOIN items i ON bc.item_id = i.item_id
WHERE b.booking_date >= '2021-11-01' AND b.booking_date < '2021-12-01'
GROUP BY b.booking_id;

-- 3. Get bill_id and bill amount of all the bills raised in October, 2021 having bill amount > 1000
SELECT 
    bc.bill_id,
    SUM(bc.item_quantity * i.item_rate) AS bill_amount
FROM booking_commercials bc
JOIN items i ON bc.item_id = i.item_id
WHERE bc.bill_date >= '2021-10-01' AND bc.bill_date < '2021-11-01'
GROUP BY bc.bill_id
HAVING SUM(bc.item_quantity * i.item_rate) > 1000;

-- 4. Determine the most ordered and least ordered item of each month of year 2021
WITH MonthlyItemCounts AS (
    SELECT 
        EXTRACT(MONTH FROM bc.bill_date) AS month,
        bc.item_id,
        i.item_name,
        SUM(bc.item_quantity) AS total_quantity
    FROM booking_commercials bc
    JOIN items i ON bc.item_id = i.item_id
    WHERE EXTRACT(YEAR FROM bc.bill_date) = 2021
    GROUP BY EXTRACT(MONTH FROM bc.bill_date), bc.item_id, i.item_name
),
RankedItems AS (
    SELECT 
        month,
        item_name,
        total_quantity,
        RANK() OVER(PARTITION BY month ORDER BY total_quantity DESC) as rnk_most,
        RANK() OVER(PARTITION BY month ORDER BY total_quantity ASC) as rnk_least
    FROM MonthlyItemCounts
)
SELECT 
    month,
    MAX(CASE WHEN rnk_most = 1 THEN item_name END) AS most_ordered_item,
    MAX(CASE WHEN rnk_least = 1 THEN item_name END) AS least_ordered_item
FROM RankedItems
GROUP BY month;

-- 5. Find the customers with the second highest bill value of each month of year 2021
WITH MonthlyBills AS (
    SELECT 
        EXTRACT(MONTH FROM bc.bill_date) AS month,
        b.user_id,
        SUM(bc.item_quantity * i.item_rate) AS bill_value
    FROM booking_commercials bc
    JOIN items i ON bc.item_id = i.item_id
    JOIN bookings b ON bc.booking_id = b.booking_id
    WHERE EXTRACT(YEAR FROM bc.bill_date) = 2021
    GROUP BY EXTRACT(MONTH FROM bc.bill_date), b.user_id
),
RankedBills AS (
    SELECT 
        month,
        user_id,
        bill_value,
        DENSE_RANK() OVER(PARTITION BY month ORDER BY bill_value DESC) as rnk
    FROM MonthlyBills
)
SELECT 
    month,
    user_id,
    bill_value
FROM RankedBills
WHERE rnk = 2;
