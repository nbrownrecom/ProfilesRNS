SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [ORCID.].[cg2_PersonURLDelete]
 
    @PersonURLID  INT 

 
AS
 
    DECLARE @intReturnVal INT 
    SET @intReturnVal = 0
 
 
        DELETE FROM [ORCID.].[PersonURL] WHERE         [ORCID.].[PersonURL].[PersonURLID] = @PersonURLID

 
        SET @intReturnVal = @@error
        IF @intReturnVal <> 0
        BEGIN
            RAISERROR (N'An error occurred while deleting the PersonURL record.', 11, 11); 
            RETURN @intReturnVal 
        END
    RETURN @intReturnVal



GO
