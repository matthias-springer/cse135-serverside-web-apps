-- Function: generate_report_states(integer, integer, text, integer, integer)
--lastmodified: 11:05pm
-- DROP FUNCTION generate_report_states(integer, integer, text, integer, integer);

CREATE OR REPLACE FUNCTION generate_report_states(IN product_offset integer, IN state_offset integer, IN state_name text, IN categoryid integer, IN age_rangeid integer)
  RETURNS TABLE(state text, product_name text, sales bigint) AS
$BODY$

DECLARE 
age_lower integer := (SELECT lower_limit FROM agerange WHERE rangeid = age_rangeid);
age_upper integer := (SELECT upper_limit FROM agerange WHERE rangeid = age_rangeid);
--implementing check for Next20states button only. Next10products button is supposed to show up all the time
new_state_offset integer := state_offset+20;
new_product_offset integer := product_offset+10;
exist_more_states integer :=0;

BEGIN

CREATE TEMP TABLE top20states(
    id              INTEGER,
    name            TEXT,
    sales	    INTEGER,
    state_sort_id    INTEGER,
    product_sort_id INTEGER
);

CREATE TEMP TABLE top10products(
    id              INTEGER,
    name            TEXT,
    sales	    INTEGER,
    state_sort_id    INTEGER,
    product_sort_id INTEGER
);


INSERT INTO top20states
SELECT top20.id, top20.name, COALESCE(SUM(newStates.price*newStates.quantity),0) AS sales, 1 AS state_sort_id, 0 AS product_sort_id
FROM
(SELECT St.id, St.name
FROM states St
WHERE (state_name = 'all' OR St.name = state_name)
ORDER BY St.name ASC
OFFSET state_offset
LIMIT 21
)AS top20
LEFT JOIN 
(SELECT U.state, S.price, S.quantity
FROM sales S
JOIN products P
ON S.pid = P.id
JOIN users U
ON S.uid = U.id
WHERE (state_name = 'all' OR U.state = state_name)
AND (age_rangeid = -1 OR (U.age >= age_lower AND U.age < age_upper))
AND (categoryid = -1 OR P.cid = categoryid)
)AS newStates
ON top20.name = newStates.state
GROUP BY top20.id, top20.name;

GET DIAGNOSTICS exist_more_states = ROW_COUNT;

INSERT INTO top10products
SELECT top10.id, top10.name, COALESCE(SUM(newProducts.price*newProducts.quantity),0) AS sales, 0 AS state_sort_id, 1 AS product_sort_id
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
JOIN products P
ON S.pid = P.id
WHERE (state_name = 'all' OR U.state = state_name)
AND (age_rangeid = -1 OR (U.age >= age_lower AND U.age < age_upper))
AND (categoryid = -1 OR P.cid = categoryid)
)AS newProducts
ON top10.id = newProducts.pid
GROUP BY top10.id, top10.name;


RETURN QUERY
SELECT t.state_name, SUBSTRING(t.product_name from 1 for 10) AS product_name, t.sales
FROM 
(
SELECT CASE WHEN (exist_more_states = 21) THEN CAST(new_state_offset AS TEXT) ELSE CAST(0 AS TEXT) END AS state_name, CAST(new_product_offset AS TEXT) AS product_name, 0 AS sales, 0  AS state_sort_id, 0 AS product_sort_id
UNION

(
select bla.state_name, bla.product_name, sum(bla.pricequantity) as sales, 1 AS state_sort_id, 1 AS product_sort_id
from
(
	(select top20states.name as state_name, top10products.name as product_name, price*quantity as pricequantity
	from top20states
	cross join top10products
	join users
	on top20states.name = users.state
	join sales
	on (sales.uid = users.id and sales.pid=top10products.id)
	where (age_rangeid = -1 OR (users.age >= age_lower AND users.age < age_upper))
	) union
	(select top20states.name as states_name, top10products.name as product_name, 0 as pricequantity
	from top20states
	cross join top10products)
) as bla
group by bla.state_name, bla.product_name
)


--SELECT U.name AS user_name, P.name AS product_name, COALESCE((SELECT sum(price*quantity) FROM sales WHERE uid=U.id AND pid=P.id),0) AS sales, 1 AS user_sort_id, 1 AS product_sort_id
--FROM top20users U, top10products P

UNION
SELECT t20s.name AS state_name, 'all' AS product_name, t20s.sales AS sales, t20s.state_sort_id,  t20s.product_sort_id
FROM top20states t20s
UNION
SELECT 'all' AS state_name, t10p.name AS product_name, t10p.sales AS sales, t10p.state_sort_id,  t10p.product_sort_id
FROM top10products t10p
) AS t
ORDER BY t.state_sort_id, t.state_name, t.product_sort_id, t.product_name
LIMIT 231;


drop table top20states;
drop table top10products;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION generate_report_states(integer, integer, text, integer, integer)
  OWNER TO postgres;
