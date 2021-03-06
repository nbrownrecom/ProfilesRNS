SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Data].[List.GetSummary] 
	@UserID int
AS
BEGIN

	--declare @ListID int 
	--set @listid=5

	;WITH a AS (
		SELECT p.*
		FROM [Profile.Data].[List.Member] m 
			INNER JOIN [Profile.Cache].[Person] p 
				ON m.PersonID = p.PersonID AND m.UserID = @UserID 
	), b AS (
		SELECT 'Institution' Variable, InstitutionName Value, COUNT(*) n
			FROM a
			GROUP BY InstitutionName
		UNION ALL
		SELECT 'Department' Variable, DepartmentName Value, COUNT(*) n
			FROM a
			GROUP BY DepartmentName
		UNION ALL
		SELECT 'FacultyRank' Variable, FacultyRank Value, COUNT(*) n
			FROM a
			GROUP BY FacultyRank
	), c AS (
		SELECT Variable, ISNULL(NULLIF(Value,''),'Unknown') Value, n
		FROM b
	), d AS (
		SELECT Variable, Value, n,
			ROW_NUMBER() OVER (PARTITION BY Variable ORDER BY (CASE WHEN Value='Other' then 1 else 0 end), n desc, Value) k,
			COUNT(*) OVER (PARTITION BY Variable) m
		FROM c
	), e AS (
		SELECT Variable, (CASE WHEN k>10 THEN 'Other' WHEN k=10 AND m>10 THEN 'Other' ELSE Value END) Value, n
			FROM d
	)
	SELECT Variable, Value, sum(n) n
		FROM e
		GROUP BY Variable, Value
		ORDER BY (CASE Variable WHEN 'Institution' THEN 0 WHEN 'Department' THEN 1 ELSE 2 END),
			(CASE WHEN Value='Other' then 1 else 0 end), n desc

END

GO
