USE [SNL]
GO

/****** Object:  Table [GC-PAD].[Groups]    Script Date: 12/27/2018 5:51:24 PM ******/
DROP TABLE [GC-PAD].[Groups]
GO

/****** Object:  Table [GC-PAD].[Groups]    Script Date: 12/27/2018 5:51:24 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [GC-PAD].[Groups](
	[Entity_Name ] [varchar](255) NULL,
	[NAICCode ] [int] NOT NULL,
 CONSTRAINT [PK_Groups_NaicCode] PRIMARY KEY CLUSTERED 
(
	[NAICCode ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


