WITH Query_T1 AS
	(SELECT CUST,
			PROD,
			STATE,
			Round(AVG(QUANT), 0) AS AVG_Quantity
		FROM SALES
		GROUP BY CUST,
				 PROD,
				 STATE),
	Query_T2 AS
	(SELECT Query_T1.CUST,
			Query_T1.PROD,
			Query_T1.STATE,
			Round(AVG(S.QUANT), 0) AS CAVG
		FROM Query_T1
		JOIN SALES AS S ON Query_T1.CUST != S.CUST
					   AND Query_T1.PROD = S.PROD
					   AND Query_T1.STATE = S.STATE
		GROUP BY Query_T1.CUST,
				 Query_T1.PROD,
				 Query_T1.STATE),
	Query_T3 AS
	(SELECT Query_T1.CUST,
			Query_T1.PROD,
			Query_T1.STATE,
			Round(AVG(S.QUANT), 0) AS PAVG
		FROM Query_T1
		JOIN SALES AS S ON Query_T1.CUST = S.CUST
					   AND Query_T1.PROD != S.PROD
					   AND Query_T1.STATE = S.STATE
		GROUP BY Query_T1.CUST,
				 Query_T1.PROD,
				 Query_T1.STATE),
	Query_T4 AS
	(SELECT Query_T1.CUST,
			Query_T1.PROD,
			Query_T1.STATE,
			Round(AVG(S.QUANT), 0) AS SAVG
		FROM Query_T1
		JOIN SALES AS S ON Query_T1.CUST = S.CUST
					   AND Query_T1.PROD = S.PROD
					   AND Query_T1.STATE != S.STATE
		GROUP BY Query_T1.CUST,
				 Query_T1.PROD,
				 Query_T1.STATE)
SELECT Query_T1.CUST AS "CUSTOMER",
	   Query_T1.PROD AS "PRODUCT",
	   Query_T1.STATE AS "STATE",
	   Query_T1.AVG_Quantity AS "PROD_AVG",
	   Query_T2.CAVG AS "OTHER_CUST_AVG",
	   Query_T3.PAVG AS "OTHER_PROD_AVG",
	   Query_T4.SAVG AS "OTHER_STATE_AVG"
	FROM Query_T1
	FULL OUTER JOIN Query_T2 ON Query_T1.CUST = Query_T2.CUST
				AND Query_T1.PROD = Query_T2.PROD
				AND Query_T1.STATE = Query_T2.STATE
	FULL OUTER JOIN Query_T3 ON Query_T1.CUST = Query_T3.CUST
				AND Query_T1.PROD = Query_T3.PROD
				AND Query_T1.STATE = Query_T3.STATE
	FULL OUTER JOIN Query_T4 ON Query_T1.CUST = Query_T4.CUST
				AND Query_T1.PROD = Query_T4.PROD
				AND Query_T1.STATE = Query_T4.STATE
	Order By Query_T1.CUST, 
		 	 Query_T1.PROD,
		 	 Query_T1.STATE