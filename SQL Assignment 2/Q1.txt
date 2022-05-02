WITH Query_T1 AS
	(SELECT CUST,
			PROD,
			MONTH,
			AVG(QUANT) AS AVG_Quantity
	 	FROM SALES
		GROUP BY CUST, 
	 			 PROD, 
	 			 MONTH),
	Query_T2 AS
	(SELECT S.CUST,
			S.PROD,
			S.MONTH,
			S.QUANT,
			Query_T1.AVG_Quantity AS AFTER_Q
		FROM SALES AS S
		LEFT JOIN Query_T1 ON S.CUST = Query_T1.CUST
		AND S.PROD = Query_T1.PROD
		AND S.MONTH = Query_T1.MONTH-1),
	Query_T3 AS
	(SELECT Query_T2.CUST,
			Query_T2.PROD,
			Query_T2.MONTH,
			Query_T1.AVG_Quantity AS BEFORE_Q,
			Query_T2.QUANT,
			Query_T2.AFTER_Q
		FROM Query_T2
		LEFT JOIN Query_T1 ON Query_T2.CUST = Query_T1.CUST
		AND Query_T2.PROD = Query_T1.PROD
		AND Query_T2.MONTH = Query_T1.MONTH + 1),
	Query_T4 AS
	(SELECT CUST,
			PROD,
			MONTH
		FROM SALES
		GROUP BY CUST,
				 PROD,
				 MONTH),
	Query_T5 AS
	(SELECT CUST,
			PROD,
			MONTH,
			COUNT(QUANT) AS COUNT_Q
		FROM Query_T3
		WHERE QUANT BETWEEN BEFORE_Q AND AFTER_Q
			OR QUANT BETWEEN AFTER_Q AND BEFORE_Q
		GROUP BY CUST,
				 PROD,
				 MONTH)
SELECT Query_T4.CUST AS "Customer",
	   Query_T4.PROD AS "Product",
	   Query_T4.MONTH AS "Month",
	   Query_T5.COUNT_Q AS "Sales_Count_Between_Averages"
	FROM Query_T4
	LEFT JOIN Query_T5 ON Query_T4.CUST = Query_T5.CUST
		  AND Query_T4.PROD = Query_T5.PROD
		  AND Query_T4.MONTH = Query_T5.MONTH
	ORDER BY Query_T4.CUST,
			 Query_T4.PROD,
			 Query_T4.MONTH