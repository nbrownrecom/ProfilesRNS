SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [ORNG.].[RemoveAppFromPerson]
@SubjectID BIGINT=NULL, @SubjectURI NVARCHAR(255)=NULL, @AppID INT, @DeleteType tinyint = 1, @SessionID UNIQUEIDENTIFIER=NULL, @Error BIT=NULL OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @ApplicationInstanceNodeID  BIGINT
	DECLARE @TripleID BIGINT
	DECLARE @PersonID INT
	DECLARE @InternalID nvarchar(100)	
	DECLARE @InternalType nvarchar(300)
	DECLARE @PERSON_FILTER_ID INT
	DECLARE @InternalUserName NVARCHAR(50)
	DECLARE @PersonFilter NVARCHAR(50)

	IF (@SubjectID IS NULL)
		SET @SubjectID = [RDF.].fnURI2NodeID(@SubjectURI)
	
	-- Lookup the PersonID
	SELECT @InternalID = InternalID, @InternalType = InternalType
		FROM [RDF.Stage].[InternalNodeMap]
		WHERE NodeID = @SubjectID
	
	IF @InternalType = 'Person'
	BEGIN
		-- Lookup the App Instance's NodeID
		SELECT @ApplicationInstanceNodeID  = NodeID
			FROM [RDF.Stage].[InternalNodeMap]
			WHERE Class = 'http://orng.info/ontology/orng#ApplicationInstance' AND InternalType = 'ORNG Application Instance'
				AND InternalID = @InternalID + '-' + CAST(@AppID AS VARCHAR(50))
	END
	ELSE IF @InternalType = 'Group'
	BEGIN
		-- Lookup the App Instance's NodeID
		SELECT @ApplicationInstanceNodeID  = NodeID
			FROM [RDF.Stage].[InternalNodeMap]
			WHERE Class = 'http://orng.info/ontology/orng#ApplicationInstance' AND InternalType = 'ORNG Application Instance'
				AND InternalID = @InternalID + '-GROUP-' + CAST(@AppID AS VARCHAR(50))
	END
		
	-- there is only ONE link from the person to the application object, so grab it	
	SELECT @TripleID = [TripleID] FROM [RDF.].Triple 
		WHERE [Subject] = @SubjectID
		AND [Object] = @ApplicationInstanceNodeID

	-- now delete it
	BEGIN TRAN

		EXEC [RDF.].DeleteTriple @TripleID = @TripleID, 
								 @SessionID = @SessionID, 
								 @Error = @Error

		IF (@DeleteType = 0) -- true delete, remove the now orphaned application instance
		BEGIN
			EXEC [RDF.].DeleteNode @NodeID = @ApplicationInstanceNodeID, 
							   @DeleteType = @DeleteType,
							   @SessionID = @SessionID, 
							   @Error = @Error OUTPUT
		END							   

		-- remove any filters
		SELECT @PERSON_FILTER_ID = (SELECT PersonFilterID FROM Apps WHERE AppID = @AppID)
		IF (@PERSON_FILTER_ID IS NOT NULL) 
			BEGIN
				SELECT @PersonID = CAST(InternalID AS INT) FROM [RDF.Stage].[InternalNodeMap]
					WHERE [NodeID] = @SubjectID AND Class = 'http://xmlns.com/foaf/0.1/Person'
				IF (@PersonID IS NOT NULL)
					BEGIN
						SELECT @InternalUserName = InternalUserName FROM [Profile.Data].[Person] WHERE PersonID = @PersonID
						SELECT @PersonFilter = PersonFilter FROM [Profile.Data].[Person.Filter] WHERE PersonFilterID = @PERSON_FILTER_ID

						DELETE FROM [Profile.Import].[PersonFilterFlag] WHERE InternalUserName = @InternalUserName AND personfilter = @PersonFilter
						DELETE FROM [Profile.Data].[Person.FilterRelationship] WHERE PersonID = @PersonID AND personFilterId = @PERSON_FILTER_ID
					END
			END
	COMMIT
END
GO
