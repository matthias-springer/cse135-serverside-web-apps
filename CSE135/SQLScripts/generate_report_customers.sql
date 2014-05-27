-- Function: generate_report_customers(integer, integer, text, integer, integer)

-- DROP FUNCTION generate_report_customers(integer, integer, text, integer, integer);

CREATE OR REPLACE FUNCTION generate_report_customers(IN product_offset integer, IN customer_offset integer, IN state_name text, IN categoryid integer, IN age_rangeid integer)
  RETURNS TABLE(user_name text, product_name text, sales bigint) AS
$BODY$

DECLARE 
age_lower integer := (SELECT lower_limit FROM agerange WHERE rangeid = age_rangeid);
age_upper integer := (SELECT upper_limit FROM agerange WHERE rangeid = age_rangeid);
--implementing check for Next20customers button only. Next10products button is supposed to show up all the time
new_customer_offset integer := customer_offset+20;
new_product_offset integer := product_offset+10;
exist_more_users integer :=0;

BEGIN

CREATE TEMP TABLE top20users(
    id              INTEGER,
    name            TEXT,
    sales	    INTEGER,
    user_sort_id    INTEGER,
    product_sort_id INTEGER
);

CREATE TEMP TABLE top10products(
    id              INTEGER,
    name            TEXT,
    sales	    INTEGER,
    user_sort_id    INTEGER,
    product_sort_id INTEGER
);


INSERT INTO top20users
SELECT top20.*, SUM(S.price*S.quantity) AS sales, 1 AS user_sort_id, 0 AS product_sort_id
FROM
(SELECT DISTINCT U.id, U.name
FROM users U
LEFT JOIN sales S
ON S.uid = U.id
LEFT JOIN products P
ON P.id = S.pid
WHERE (state_name = 'all' OR U.state = state_name)
AND (age_rangeid = -1 OR (U.age >= age_lower AND U.age < age_upper))
AND (categoryid = -1 OR P.cid = categoryid)
ORDER BY U.name ASC
OFFSET customer_offset
LIMIT 20
)AS top20
LEFT JOIN sales S
ON top20.id = S.uid
GROUP BY top20.id, top20.name
ORDER BY top20.name ASC;

PERFORM DISTINCT U.name
FROM users U
LEFT JOIN sales S
ON S.uid = U.id
LEFT JOIN products P
ON P.id = S.pid
WHERE (state_name = 'all' OR U.state = state_name)
AND (age_rangeid = -1 OR (U.age >= age_lower AND U.age < age_upper))
AND (categoryid = -1 OR P.cid = categoryid)
ORDER BY U.name ASC
OFFSET new_customer_offset
LIMIT 1;

GET DIAGNOSTICS exist_more_users = ROW_COUNT;

INSERT INTO top10products
SELECT top10.id, top10.name, SUM(S.price*S.quantity) AS sales, 0 AS user_sort_id, 1 AS product_sort_id
FROM 
(SELECT DISTINCT P.id, P.name, P.cid
FROM products P
LEFT JOIN sales S
ON P.id = S.pid
LEFT JOIN users U
ON U.id = S.uid
WHERE (categoryid = -1 OR P.cid = categoryid)
AND (state_name = 'all' OR U.state = state_name)
AND (age_rangeid = -1 OR (U.age >= age_lower AND U.age < age_upper))
ORDER BY name ASC
OFFSET product_offset
LIMIT 10
)AS top10
LEFT JOIN sales S
ON top10.id = S.pid
GROUP BY top10.id, top10.name
ORDER BY top10.name ASC;


RETURN QUERY
SELECT t.user_name, t.product_name, t.sales
FROM 
(
SELECT CASE WHEN (exist_more_users = 1) THEN CAST(new_customer_offset AS TEXT) ELSE CAST(0 AS TEXT) END AS user_name, CAST(new_product_offset AS TEXT) AS product_name, 0 AS sales, 0  AS user_sort_id, 0 AS product_sort_id
UNION
SELECT U.name AS user_name, P.name AS product_name, COALESCE(SUM(S.price*S.quantity),0) AS sales, 1 AS user_sort_id, 1 AS product_sort_id
FROM top20users U
CROSS JOIN top10products P
LEFT JOIN sales S
ON (P.id = S.pid AND U.id = S.uid)
GROUP BY U.name, P.name
UNION
SELECT t20u.name AS user_name, 'all' AS product_name, t20u.sales AS sales, t20u.user_sort_id,  t20u.product_sort_id
FROM top20users t20u
UNION
SELECT 'all' AS user_name, t10p.name AS product_name, t10p.sales AS sales, t10p.user_sort_id,  t10p.product_sort_id
FROM top10products t10p
) AS t
ORDER BY t.user_sort_id, t.user_name, t.product_sort_id, t.product_name;


drop table top20users;
drop table top10products;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION generate_report_customers(integer, integer, text, integer, integer)
  OWNER TO postgres;
