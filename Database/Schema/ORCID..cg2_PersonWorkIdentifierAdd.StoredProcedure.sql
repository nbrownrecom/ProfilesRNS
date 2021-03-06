SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 
CREATE PROCEDURE [ORCID.].[cg2_PersonWorkIdentifierAdd]

    @PersonWorkIdentifierID  INT =NULL OUTPUT 
    , @PersonWorkID  INT 
    , @WorkExternalTypeID  INT 
    , @Identifier  VARCHAR(250) 

AS


    DECLARE @intReturnVal INT 
    SET @intReturnVal = 0
    DECLARE @strReturn  Varchar(200) 
    SET @intReturnVal = 0
    DECLARE @intRecordLevelAuditTrailID INT 
    DECLARE @intFieldLevelAuditTrailID INT 
    DECLARE @intTableID INT 
    SET @intTableID = 3615
 
  
        INSERT INTO [ORCID.].[PersonWorkIdentifier]
        (
            [PersonWorkID]
            , [WorkExternalTypeID]
            , [Identifier]
        )
        (
            SELECT
            @PersonWorkID
            , @WorkExternalTypeID
            , @Identifier
        )
   
        SET @intReturnVal = @@error
        SET @PersonWorkIdentifierID = @@IDENTITY
        IF @intReturnVal <> 0
        BEGIN
            RAISERROR (N'An error occurred while adding the PersonWorkIdentifier record.', 11, 11); 
            RETURN @intReturnVal 
        END



GO
