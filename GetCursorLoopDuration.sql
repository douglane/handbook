
WITH cte AS 
(
SELECT ROW_NUMBER() OVER (ORDER BY RowNumber) AS LoopNum
, RowNumber AS BeginRow
, LEAD(RowNumber, 1, 0) OVER (ORDER BY RowNumber) - 1 AS EndRow 
FROM dbo.TraceTable
WHERE ObjectName = 'sp_cursorfetch' AND HostName = @HostName
)

SELECT LoopNum, SUM(cpu)/1000.0 AS CPUMS, SUM(Duration)/1000.0 AS DurationMS, SUM(Reads) AS Reads
FROM dbo.TraceTable AS tt
JOIN cte ON tt.RowNumber BETWEEN cte.BeginRow AND cte.EndRow
WHERE (HostName = @HostName)
GROUP BY LoopNum




