SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [ORCID.].[cg2_FieldLevelAuditTrailsGet]
 
AS
 
    SELECT TOP 100 PERCENT
        [ORCID.].[FieldLevelAuditTrail].[FieldLevelAuditTrailID]
        , [ORCID.].[FieldLevelAuditTrail].[RecordLevelAuditTrailID]
        , [ORCID.].[FieldLevelAuditTrail].[MetaFieldID]
        , [ORCID.].[FieldLevelAuditTrail].[ValueBefore]
        , [ORCID.].[FieldLevelAuditTrail].[ValueAfter]
    FROM
        [ORCID.].[FieldLevelAuditTrail]



GO
