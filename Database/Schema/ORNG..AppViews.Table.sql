SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ORNG.].[AppViews](
	[AppID] [int] NOT NULL,
	[Page] [nvarchar](50) NULL,
	[View] [nvarchar](50) NULL,
	[ChromeID] [nvarchar](50) NULL,
	[Visibility] [nvarchar](50) NULL,
	[DisplayOrder] [int] NULL,
	[OptParams] [nvarchar](255) NULL
) ON [PRIMARY]

GO
ALTER TABLE [ORNG.].[AppViews]  WITH CHECK ADD  CONSTRAINT [FK_orng_app_views_apps] FOREIGN KEY([AppID])
REFERENCES [ORNG.].[Apps] ([AppID])
GO
ALTER TABLE [ORNG.].[AppViews] CHECK CONSTRAINT [FK_orng_app_views_apps]
GO
