SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Profile.Data].[Publication.Group.MyPub.CopyExistingPublication]
	@GroupID INT,
	@MPID nvarchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int,@proc VARCHAR(200),@date DATETIME,@auditid UNIQUEIDENTIFIER 
	SELECT @proc = OBJECT_NAME(@@PROCID),@date=GETDATE() 	
	 
	DECLARE @newmpid nvarchar(50)
	SET @newmpid = cast(NewID() as nvarchar(50))

	DECLARE @pubid nvarchar(50)
	SET @pubid = cast(NewID() as nvarchar(50))
	BEGIN TRY
	BEGIN TRANSACTION

		INSERT INTO [Profile.Data].[Publication.Group.MyPub.General]
		        (
			mpid,
			GroupID,
			HmsPubCategory,
			PubTitle,
			ArticleTitle,
			ConfEditors,
			ConfLoc,
			EDITION,
			PlaceOfPub,
			VolNum,
			PartVolPub,
			IssuePub,
			PaginationPub,
			AdditionalInfo,
			Publisher,
			ConfNm,
			ConfDts,
			ReptNumber,
			ContractNum,
			DissUnivNM,
			NewspaperCol,
			NewspaperSect,
			PublicationDT,
			ABSTRACT,
			AUTHORS,
			URL,
			CreatedBy,
			CreatedDT,
			UpdatedBy,
			UpdatedDT,
			CopiedMPID
		) select
			@newmpid,
			@GroupID,
			HmsPubCategory,
			PubTitle,
			ArticleTitle,
			ConfEditors,
			ConfLoc,
			EDITION,
			PlaceOfPub,
			VolNum,
			PartVolPub,
			IssuePub,
			PaginationPub,
			AdditionalInfo,
			Publisher,
			ConfNm,
			ConfDts,
			ReptNumber,
			ContractNum,
			DissUnivNM,
			NewspaperCol,
			NewspaperSect,
			PublicationDT,
			ABSTRACT,
			AUTHORS,
			URL,
			CreatedBy,
			CreatedDT,
			UpdatedBy,
			UpdatedDT,
			@MPID
			from [Profile.Data].[Publication.MyPub.General]
			where MPID = @MPID

		INSERT INTO [Profile.Data].[Publication.Group.Include]
		        ( PubID, GroupID,   MPID )
			VALUES (@pubid, @GroupID, @newmpid)


	COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		--Check success
		IF @@TRANCOUNT > 0  ROLLBACK
		SELECT @date=GETDATE()
		EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName =@proc,@ProcessEndDate=@date,@error = 1,@insert_new_record=1
		--Raise an error with the details of the exception
		SELECT @ErrMsg = ERROR_MESSAGE(), @ErrSeverity = ERROR_SEVERITY()
		RAISERROR(@ErrMsg, @ErrSeverity, 1)
	END CATCH

END

GO
