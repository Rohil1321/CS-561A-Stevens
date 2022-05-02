WITH Query_T1 AS
	(SELECT CUST,
			PROD,
			MONTH,
			Round(AVG(QUANT), 0) AS AVG_Quantity
	 	FROM SALES
		GROUP BY CUST,
				 PROD,
				 MONTH),
	Query_T2 AS
	(SELECT Query_T1.CUST,
			Query_T1.PROD,
			Query_T1.MONTH,
			Query_T1.AVG_Quantity,
			Query_TT1.AVG_Quantity AS AFTER_AVERAGE
		FROM Query_T1
		LEFT JOIN Query_T1 AS Query_TT1 ON Query_T1.CUST = Query_TT1.CUST
			  AND Query_T1.PROD = Query_TT1.PROD
			  AND Query_T1.MONTH = Query_TT1.MONTH-1),
	Query_T3 AS
	(SELECT Query_T1.CUST,
			Query_T1.PROD,
			Query_T1.MONTH,
			Query_T1.AVG_Quantity,
			Query_TT1.AVG_Quantity AS BEFORE_AVERAGE
		FROM Query_T1
		LEFT JOIN Query_T1 AS Query_TT1 ON Query_T1.CUST = Query_TT1.CUST
			  AND Query_T1.PROD = Query_TT1.PROD
			  AND Query_T1.MONTH = Query_TT1.MONTH + 1)
SELECT Query_T2.CUST AS "CUSTOMER",
	   Query_T2.PROD AS "PRODUCT",
	   Query_T2.MONTH AS "MONTH",
	   BEFORE_AVERAGE AS "BEFORE_AVG",
	   Query_T2.AVG_Quantity AS "DURING_AVG",
	   AFTER_AVERAGE AS "AFTER_AVG"
	FROM Query_T2
	JOIN Query_T3 ON Query_T2.CUST = Query_T3.CUST
	 AND Query_T2.PROD = Query_T3.PROD
	 AND Query_T2.MONTH = Query_T3.MONTH
	ORDER BY Query_T2.CUST,
			 Query_T2.PROD,
			 Query_T2.MONTH