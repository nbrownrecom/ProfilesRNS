SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [ORCID.].[cg2_PersonMessagesGet]
 
AS
 
    SELECT TOP 100 PERCENT
        [ORCID.].[PersonMessage].[PersonMessageID]
        , [ORCID.].[PersonMessage].[PersonID]
        , [ORCID.].[PersonMessage].[XML_Sent]
        , [ORCID.].[PersonMessage].[XML_Response]
        , [ORCID.].[PersonMessage].[ErrorMessage]
        , [ORCID.].[PersonMessage].[HttpResponseCode]
        , [ORCID.].[PersonMessage].[MessagePostSuccess]
        , [ORCID.].[PersonMessage].[RecordStatusID]
        , [ORCID.].[PersonMessage].[PermissionID]
        , [ORCID.].[PersonMessage].[RequestURL]
        , [ORCID.].[PersonMessage].[HeaderPost]
        , [ORCID.].[PersonMessage].[UserMessage]
        , [ORCID.].[PersonMessage].[PostDate]
    FROM
        [ORCID.].[PersonMessage]



GO
