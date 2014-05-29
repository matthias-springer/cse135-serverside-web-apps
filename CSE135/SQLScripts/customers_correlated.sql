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


/*INSERT INTO top20users
SELECT top20.*, COALESCE(SUM(sales.price*sales.quantity),0) AS sales, 1 AS user_sort_id, 0 AS product_sort_id
FROM
((SELECT U.id, U.name
FROM users U
WHERE (state_name = 'all' OR U.state = state_name)
AND (age_rangeid = -1 OR (U.age >= age_lower AND U.age < age_upper))
ORDER BY U.name ASC
OFFSET customer_offset
LIMIT 21
)AS top20
LEFT JOIN sales
ON top20.id = sales.uid)
LEFT JOIN products P
ON sales.pid = P.id
WHERE (categoryid = -1 OR P.cid = categoryid)
GROUP BY top20.id, top20.name;
*/
INSERT INTO top20users
SELECT top20.*, COALESCE(SUM(newProds.price*newProds.quantity),0) AS sales, 1 AS user_sort_id, 0 AS product_sort_id
FROM
(SELECT U.id, U.name
FROM users U
WHERE (state_name = 'all' OR U.state = state_name)
AND (age_rangeid = -1 OR (U.age >= age_lower AND U.age < age_upper))
ORDER BY U.name ASC
OFFSET customer_offset
LIMIT 21
)AS top20
LEFT JOIN 
(SELECT S.uid, S.price, S.quantity
FROM sales S
JOIN products P
ON S.pid = P.id
WHERE (categoryid = -1 OR P.cid = categoryid)
)AS newProds
ON top20.id = newProds.uid
GROUP BY top20.id, top20.name;

GET DIAGNOSTICS exist_more_users = ROW_COUNT;



/*INSERT INTO top10products
SELECT top10.*, COALESCE(SUM(price*quantity),0) AS sales, 0 AS user_sort_id, 1 AS product_sort_id
FROM 
(SELECT P.id, P.name
FROM products P
WHERE (categoryid = -1 OR P.cid = categoryid)
ORDER BY P.name ASC
OFFSET product_offset
LIMIT 10
)AS top10
LEFT JOIN sales
ON top10.id = sales.pid
LEFT JOIN users U
ON uid = U.id
WHERE (state_name = 'all' OR U.state = state_name)
AND (age_rangeid = -1 OR (U.age >= age_lower AND U.age < age_upper))
GROUP BY top10.id, top10.name;*/

INSERT INTO top10products
SELECT top10.*, COALESCE(SUM(newUsers.price*newUsers.quantity),0) AS sales, 0 AS user_sort_id, 1 AS product_sort_id
FROM 
(SELECT P.id, P.name
FROM products P
WHERE (categoryid = -1 OR P.cid = categoryid)
ORDER BY P.name ASC
OFFSET product_offset
LIMIT 10
)AS top10
LEFT JOIN 
(SELECT S.pid, S.price, S.quantity
FROM sales S
JOIN users U
ON S.uid = U.id
WHERE (state_name = 'all' OR U.state = state_name)
AND (age_rangeid = -1 OR (U.age >= age_lower AND U.age < age_upper))
)AS newUsers
ON top10.id = newUsers.pid
GROUP BY top10.id, top10.name;


RETURN QUERY
SELECT t.user_name, SUBSTRING(t.product_name from 1 for 10) AS product_name, t.sales
FROM 
(
SELECT CASE WHEN (exist_more_users = 1) THEN CAST(new_customer_offset AS TEXT) ELSE CAST(0 AS TEXT) END AS user_name, CAST(new_product_offset AS TEXT) AS product_name, 0 AS sales, 0  AS user_sort_id, 0 AS product_sort_id
UNION

(
select bla.user_name, bla.product_name, sum(bla.pricequantity) as sales, 1 AS user_sort_id, 1 AS product_sort_id
from
(
	(select top20users.name as user_name, top10products.name as product_name, price*quantity as pricequantity
	from top20users
	cross join top10products
	join sales
	on sales.uid=top20users.id and sales.pid=top10products.id
	) union
	(select top20users.name as user_name, top10products.name as product_name, 0 as pricequantity
	from top20users
	cross join top10products)
) as bla
group by bla.user_name, bla.product_name
)


--SELECT U.name AS user_name, P.name AS product_name, COALESCE((SELECT sum(price*quantity) FROM sales WHERE uid=U.id AND pid=P.id),0) AS sales, 1 AS user_sort_id, 1 AS product_sort_id
--FROM top20users U, top10products P

UNION
SELECT t20u.name AS user_name, 'all' AS product_name, t20u.sales AS sales, t20u.user_sort_id,  t20u.product_sort_id
FROM top20users t20u
UNION
SELECT 'all' AS user_name, t10p.name AS product_name, t10p.sales AS sales, t10p.user_sort_id,  t10p.product_sort_id
FROM top10products t10p
) AS t
ORDER BY t.user_sort_id, t.user_name, t.product_sort_id, t.product_name
LIMIT 231;


drop table top20users;
drop table top10products;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION generate_report_customers(integer, integer, text, integer, integer)
  OWNER TO postgres;
