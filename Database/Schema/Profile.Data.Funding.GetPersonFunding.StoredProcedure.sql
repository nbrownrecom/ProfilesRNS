SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Profile.Data].[Funding.GetPersonFunding]
	@PersonID INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT
		ISNULL(a.Abstract,'') Abstract,
		ISNULL(a.AgreementLabel,'') AgreementLabel,
		ISNULL(a.EndDate,'1/1/1900') EndDate,
		ISNULL(a.Source,'') Source,
		ISNULL(a.FundingID,'') FundingID,
		ISNULL(a.FundingID2,'') FundingID2,
		ISNULL(a.GrantAwardedBy,'') GrantAwardedBy,
		ISNULL(r.FundingRoleID,'') FundingRoleID,
		ISNULL(r.PersonID,'') PersonID,
		ISNULL(a.PrincipalInvestigatorName,'') PrincipalInvestigatorName,
		ISNULL(r.RoleDescription,'') RoleDescription,
		ISNULL(r.RoleLabel,'') RoleLabel,
		ISNULL(a.StartDate,'1/1/1900') StartDate,
		'' SponsorAwardID
	FROM [Profile.Data].[Funding.Role] r 
		INNER JOIN [Profile.Data].[Funding.Agreement] a
			ON r.FundingAgreementID = a.FundingAgreementID
				AND r.PersonID = @PersonID
	ORDER BY StartDate desc, EndDate desc, FundingID

END

GO
