/* skills used: JOINS, Window Functions, CTE, Aggregate Functions*/


-- Collect users information from tables collected from each webpage*/
-- Notice the sequence should be home_page_table, search_page_table, payment_page_table, payment_confirmation_table. And we have an extra user_table */
-- Calculate the conversion rate

WITH joined_table 
  AS (SELECT * 
      FROM user_table u
      LEFT JOIN home_page_table h
      ON u.user_id = h.user_id
      LEFT JOIN search_page_table s
      ON u.user_id = s.user_id
      LEFT JOIN payment_page_table pp
      ON u.user_id = pp.user_id
      LEFT JOIN payment_confirmation_table pc
      ON u.user_id = pc.user_id
      ORDER BY u.user_id)
  
SELECT   SUM (CASE 
          WHEN u.page IS NOT NULL THEN 1
          ELSE 0
          END) AS num_total,
          SUM (CASE 
          WHEN h.page IS NOT NULL THEN 1
          ELSE 0
          END) AS num_home_page, 
          SUM (CASE 
          WHEN s.page IS NOT NULL THEN 1
          ELSE 0
          END) AS num_search_page,
          SUM (CASE 
          WHEN pp.page IS NOT NULL THEN 1
          ELSE 0
          END) AS num_payment_page,
          SUM (CASE 
          WHEN pc.page IS NOT NULL THEN 1
          ELSE 0
          END) AS num_payment_confirm_page,
          num_home_page/num_total AS rate_1, 
          num_search_page/num_total AS rate_2,
          num_payment_page/num_total AS rate_3,
          num_payment_confirm_page/num_total AS rate_4,
  FROM joined_table 
  
-- use the paymentstatuslog table to get the payment funnel data for individuals who are under the new page test. Let's say the user_id is 310478

  SELECT user_id, status_id, time_in_status, 
  LEAD(time_in_status) OVER (ORDER BY status_id) AS time_in_previous_status, (time_in_status-time_in_previous_status) AS time_diff
FROM paymentstatuslog

