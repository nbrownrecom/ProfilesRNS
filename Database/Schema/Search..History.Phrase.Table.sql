SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Search.].[History.Phrase](
	[SearchHistoryPhraseID] [int] IDENTITY(0,1) NOT NULL,
	[SearchHistoryQueryID] [int] NULL,
	[PhraseID] [int] NULL,
	[ThesaurusMatch] [bit] NULL,
	[Phrase] [varchar](max) NULL,
	[EndDate] [datetime] NULL,
	[IsBot] [bit] NULL,
	[NumberOfConnections] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[SearchHistoryPhraseID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [IDX_QueryID] ON [Search.].[History.Phrase] 
(
	[SearchHistoryQueryID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO