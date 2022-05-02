WITH QUERY_T1 AS
	(SELECT CUST,
			PROD,
			MONTH,
			SUM(QUANT) AS SUM_Q
		FROM SALES
		GROUP BY CUST,
				 PROD,
				 MONTH),
	QUERY_T2 AS
	(SELECT QUERY_T1.CUST,
			QUERY_T1.PROD,
			QUERY_T1.MONTH,
			SUM(TQUERY_T1.SUM_Q) AS CSUM_Q
		FROM QUERY_T1,
			QUERY_T1 AS TQUERY_T1
		WHERE QUERY_T1.CUST = TQUERY_T1.CUST
			AND QUERY_T1.PROD = TQUERY_T1.PROD
			AND QUERY_T1.MONTH >= TQUERY_T1.MONTH
		GROUP BY QUERY_T1.CUST,
			QUERY_T1.PROD,
			QUERY_T1.MONTH),
	QUERY_T3 AS
	(SELECT CUST,
			PROD,
			ROUND(SUM(SUM_Q) / 3, 0) AS TSUM_Q
		FROM QUERY_T1
		GROUP BY CUST,
				 PROD)
SELECT QUERY_T2.CUST AS "CUSTOMER",
	   QUERY_T2.PROD AS "PRODUCT",
	   MIN(QUERY_T2.MONTH) AS "1/3 PURCHASED BY MONTH"
	FROM QUERY_T2, QUERY_T3
	WHERE QUERY_T2.CUST = QUERY_T3.CUST
	  AND QUERY_T2.PROD = QUERY_T3.PROD
	  AND QUERY_T2.CSUM_Q >= QUERY_T3.TSUM_Q
	GROUP BY QUERY_T2.CUST,
			 QUERY_T2.PROD