SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 
CREATE PROCEDURE [ORCID.].[cg2_ErrorLogEdit]

    @ErrorLogID  INT =NULL OUTPUT 
    , @InternalUsername  NVARCHAR(11) =NULL
    , @Exception  TEXT 
    , @OccurredOn  SMALLDATETIME 
    , @Processed  BIT 

AS


    DECLARE @intReturnVal INT 
    SET @intReturnVal = 0
    DECLARE @strReturn  Varchar(200) 
    SET @intReturnVal = 0
    DECLARE @intRecordLevelAuditTrailID INT 
    DECLARE @intFieldLevelAuditTrailID INT 
    DECLARE @intTableID INT 
    SET @intTableID = 3732
 
  
        UPDATE [ORCID.].[ErrorLog]
        SET
            [InternalUsername] = @InternalUsername
            , [Exception] = @Exception
            , [OccurredOn] = @OccurredOn
            , [Processed] = @Processed
        FROM
            [ORCID.].[ErrorLog]
        WHERE
        [ORCID.].[ErrorLog].[ErrorLogID] = @ErrorLogID

        
        SET @intReturnVal = @@error
        IF @intReturnVal <> 0
        BEGIN
            RAISERROR (N'An error occurred while editing the ErrorLog record.', 11, 11); 
            RETURN @intReturnVal 
        END



GO
