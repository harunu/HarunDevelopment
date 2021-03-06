USE [master]
GO
/****** Object:  Database [HAYATIMIZFILM]    Script Date: 19.03.2013 14:48:01 ******/
CREATE DATABASE [HAYATIMIZFILM]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'HAYATIMIZFILM', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\HAYATIMIZFILM.mdf' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'HAYATIMIZFILM_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\HAYATIMIZFILM_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [HAYATIMIZFILM] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [HAYATIMIZFILM].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [HAYATIMIZFILM] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [HAYATIMIZFILM] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [HAYATIMIZFILM] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [HAYATIMIZFILM] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [HAYATIMIZFILM] SET ARITHABORT OFF 
GO
ALTER DATABASE [HAYATIMIZFILM] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [HAYATIMIZFILM] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [HAYATIMIZFILM] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [HAYATIMIZFILM] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [HAYATIMIZFILM] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [HAYATIMIZFILM] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [HAYATIMIZFILM] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [HAYATIMIZFILM] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [HAYATIMIZFILM] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [HAYATIMIZFILM] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [HAYATIMIZFILM] SET  DISABLE_BROKER 
GO
ALTER DATABASE [HAYATIMIZFILM] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [HAYATIMIZFILM] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [HAYATIMIZFILM] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [HAYATIMIZFILM] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [HAYATIMIZFILM] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [HAYATIMIZFILM] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [HAYATIMIZFILM] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [HAYATIMIZFILM] SET RECOVERY FULL 
GO
ALTER DATABASE [HAYATIMIZFILM] SET  MULTI_USER 
GO
ALTER DATABASE [HAYATIMIZFILM] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [HAYATIMIZFILM] SET DB_CHAINING OFF 
GO
ALTER DATABASE [HAYATIMIZFILM] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [HAYATIMIZFILM] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
EXEC sys.sp_db_vardecimal_storage_format N'HAYATIMIZFILM', N'ON'
GO
USE [HAYATIMIZFILM]
GO
/****** Object:  StoredProcedure [dbo].[PRCAdd2Cart]    Script Date: 19.03.2013 14:48:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PRCAdd2Cart]

	@ProductID int,
	@CustID int,
	@Quantity int,
	@Price decimal(18,2)

AS
BEGIN
	
	SET NOCOUNT ON;

	 declare @Consist int=0;
	 SET @Consist = (Select COUNT(TBCART.CARTID) from TBCART 
	 where CUSTID = @CustID and MOVIEID=@ProductID and ORDERID=0);

	 IF(@Consist > 0)
	 begin
		update TBCART SET QUANTITY = QUANTITY+1 where CUSTID = @CustID and MOVIEID=@ProductID and ORDERID=0;
	 end
	 else
	 BEGIN
		insert INTO TBCART(CUSTID,MOVIEID,ORDERID,QUANTITY,PRICE) VALUES(@CustID,@ProductID,0,@Quantity,@Price)
	 end;

END

GO
/****** Object:  StoredProcedure [dbo].[PRCMovieStatusUpdate]    Script Date: 19.03.2013 14:48:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PRCMovieStatusUpdate] 
	@MovieID int,
	@SuppId int,
	@Status bit
AS
BEGIN

	SET NOCOUNT ON;

	Update TBMOVIES SET ACTIVE = @Status where MOVIEID = @MovieID and SUPPID = @SuppID;
	
END

GO
/****** Object:  StoredProcedure [dbo].[PRCOder]    Script Date: 19.03.2013 14:48:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PRCOder]
	@CustID int,
	@Address varchar(150),
	@Notlar varchar(150)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	INSERT INTO TBORDER(ORDERDATE,ADDRESS,CUSTID,NOTES,ORDERSTATUS) VALUES(GETDATE(),@Address,@CustID,@Notlar,1);
	declare @ID int;
	SET @ID = (Select SCOPE_IDENTITY());

	Update TBCART SET ORDERID = @ID where CUSTID=@CustID and ORDERID=0;

	Select @ID;
END

GO
/****** Object:  StoredProcedure [dbo].[SPGiris]    Script Date: 19.03.2013 14:48:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SPGiris]
	@EPOSTA varchar(50),
	@PAROLA varchar(50)
AS
BEGIN
	
	SET NOCOUNT ON;
	declare @Ksayisi int;
	declare @Kullanici int=0;


   SET @KSayisi = (Select COUNT(CUSTID) from TBCUSTOMER where EMAIL = @EPOSTA);

   IF(@KSayisi >0)
   begin
		SET @Kullanici =(Select CUSTID from TBCUSTOMER where EMAIL=@EPOSTA and PASSWORD = @PAROLA);
   end;

   Select @Kullanici;
END

GO
/****** Object:  Table [dbo].[TBCART]    Script Date: 19.03.2013 14:48:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TBCART](
	[CARTID] [int] IDENTITY(1,1) NOT NULL,
	[CUSTID] [int] NULL,
	[MOVIEID] [int] NULL,
	[ORDERID] [int] NULL,
	[QUANTITY] [int] NULL,
	[PRICE] [decimal](18, 2) NULL,
	[SUPPLIED] [int] NULL,
 CONSTRAINT [PK_TBCART] PRIMARY KEY CLUSTERED 
(
	[CARTID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TBCATEGORIES]    Script Date: 19.03.2013 14:48:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TBCATEGORIES](
	[CATID] [int] IDENTITY(1,1) NOT NULL,
	[CATEGORYNAME] [varchar](50) NOT NULL,
 CONSTRAINT [PK_TBCATEGORIES] PRIMARY KEY CLUSTERED 
(
	[CATID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TBCUSTOMER]    Script Date: 19.03.2013 14:48:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TBCUSTOMER](
	[CUSTID] [int] IDENTITY(1,1) NOT NULL,
	[NAME] [varchar](50) NULL,
	[SURNAME] [varchar](50) NULL,
	[EMAIL] [varchar](50) NULL,
	[PASSWORD] [varchar](50) NULL,
	[PHONE] [varchar](50) NULL,
 CONSTRAINT [PK_TBCUSTOMER] PRIMARY KEY CLUSTERED 
(
	[CUSTID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TBMOVIES]    Script Date: 19.03.2013 14:48:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TBMOVIES](
	[MOVIEID] [int] IDENTITY(1,1) NOT NULL,
	[NAME] [varchar](50) NULL,
	[YEAR] [int] NULL,
	[TYPE] [varchar](50) NULL,
	[CATID] [int] NULL,
	[DESCRIPTION] [varchar](500) NULL,
	[PRICE] [decimal](18, 2) NULL,
	[POSTERIMAGE] [varchar](50) NULL,
	[ACTIVE] [bit] NULL,
	[SUPPID] [int] NULL,
 CONSTRAINT [PK_TBMOVIES] PRIMARY KEY CLUSTERED 
(
	[MOVIEID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TBORDER]    Script Date: 19.03.2013 14:48:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TBORDER](
	[ORDERID] [int] IDENTITY(1,1) NOT NULL,
	[ORDERDATE] [date] NULL,
	[ADDRESS] [varchar](500) NULL,
	[CUSTID] [int] NULL,
	[NOTES] [varchar](50) NULL,
	[ORDERSTATUS] [int] NULL,
 CONSTRAINT [PK_TBORDER] PRIMARY KEY CLUSTERED 
(
	[ORDERID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TBSUPPLIER]    Script Date: 19.03.2013 14:48:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TBSUPPLIER](
	[SUPPID] [int] IDENTITY(1,1) NOT NULL,
	[NAME] [varchar](50) NULL,
	[PASSWORD] [varchar](50) NULL,
 CONSTRAINT [PK_TBSUPPLIER] PRIMARY KEY CLUSTERED 
(
	[SUPPID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  View [dbo].[SRGMOVIES]    Script Date: 19.03.2013 14:48:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[SRGMOVIES]
AS
SELECT        dbo.TBCATEGORIES.CATEGORYNAME, dbo.TBMOVIES.*
FROM            dbo.TBCATEGORIES INNER JOIN
                         dbo.TBMOVIES ON dbo.TBCATEGORIES.CATID = dbo.TBMOVIES.CATID

GO
/****** Object:  View [dbo].[SRGOrderSupp]    Script Date: 19.03.2013 14:48:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[SRGOrderSupp]
AS
SELECT        dbo.TBCART.MOVIEID, dbo.TBCART.CARTID, dbo.TBCART.ORDERID, dbo.TBCART.QUANTITY, dbo.TBMOVIES.NAME, dbo.TBORDER.ORDERSTATUS, 
                         dbo.TBMOVIES.SUPPID
FROM            dbo.TBCART INNER JOIN
                         dbo.TBMOVIES ON dbo.TBCART.MOVIEID = dbo.TBMOVIES.MOVIEID INNER JOIN
                         dbo.TBORDER ON dbo.TBCART.ORDERID = dbo.TBORDER.ORDERID
WHERE        (dbo.TBORDER.ORDERSTATUS = 2)

GO
SET IDENTITY_INSERT [dbo].[TBCART] ON 

INSERT [dbo].[TBCART] ([CARTID], [CUSTID], [MOVIEID], [ORDERID], [QUANTITY], [PRICE], [SUPPLIED]) VALUES (1, 1, 2, 3, 7, CAST(5.00 AS Decimal(18, 2)), 0)
INSERT [dbo].[TBCART] ([CARTID], [CUSTID], [MOVIEID], [ORDERID], [QUANTITY], [PRICE], [SUPPLIED]) VALUES (2, 1, 4, 3, 1, CAST(10.00 AS Decimal(18, 2)), 0)
INSERT [dbo].[TBCART] ([CARTID], [CUSTID], [MOVIEID], [ORDERID], [QUANTITY], [PRICE], [SUPPLIED]) VALUES (4, 1, 3, 3, 1, CAST(10.00 AS Decimal(18, 2)), 0)
INSERT [dbo].[TBCART] ([CARTID], [CUSTID], [MOVIEID], [ORDERID], [QUANTITY], [PRICE], [SUPPLIED]) VALUES (5, 1, 4, 3, 1, CAST(10.00 AS Decimal(18, 2)), 0)
INSERT [dbo].[TBCART] ([CARTID], [CUSTID], [MOVIEID], [ORDERID], [QUANTITY], [PRICE], [SUPPLIED]) VALUES (6, 1, 5, 3, 2, CAST(11.00 AS Decimal(18, 2)), 0)
INSERT [dbo].[TBCART] ([CARTID], [CUSTID], [MOVIEID], [ORDERID], [QUANTITY], [PRICE], [SUPPLIED]) VALUES (7, 1, 2, 4, 1, CAST(5.00 AS Decimal(18, 2)), 0)
INSERT [dbo].[TBCART] ([CARTID], [CUSTID], [MOVIEID], [ORDERID], [QUANTITY], [PRICE], [SUPPLIED]) VALUES (8, 1, 4, 4, 1, CAST(10.00 AS Decimal(18, 2)), 0)
SET IDENTITY_INSERT [dbo].[TBCART] OFF
SET IDENTITY_INSERT [dbo].[TBCATEGORIES] ON 

INSERT [dbo].[TBCATEGORIES] ([CATID], [CATEGORYNAME]) VALUES (1, N'Macera')
INSERT [dbo].[TBCATEGORIES] ([CATID], [CATEGORYNAME]) VALUES (2, N'Korku')
INSERT [dbo].[TBCATEGORIES] ([CATID], [CATEGORYNAME]) VALUES (3, N'Drama')
INSERT [dbo].[TBCATEGORIES] ([CATID], [CATEGORYNAME]) VALUES (4, N'Bilim Kurgu')
INSERT [dbo].[TBCATEGORIES] ([CATID], [CATEGORYNAME]) VALUES (5, N'Romantik')
INSERT [dbo].[TBCATEGORIES] ([CATID], [CATEGORYNAME]) VALUES (6, N'Gerilim')
INSERT [dbo].[TBCATEGORIES] ([CATID], [CATEGORYNAME]) VALUES (7, N'Suç')
INSERT [dbo].[TBCATEGORIES] ([CATID], [CATEGORYNAME]) VALUES (8, N'Polisiye')
INSERT [dbo].[TBCATEGORIES] ([CATID], [CATEGORYNAME]) VALUES (9, N'Animasyon')
INSERT [dbo].[TBCATEGORIES] ([CATID], [CATEGORYNAME]) VALUES (10, N'Belgesel')
INSERT [dbo].[TBCATEGORIES] ([CATID], [CATEGORYNAME]) VALUES (11, N'Biyografi')
INSERT [dbo].[TBCATEGORIES] ([CATID], [CATEGORYNAME]) VALUES (12, N'Tarih')
INSERT [dbo].[TBCATEGORIES] ([CATID], [CATEGORYNAME]) VALUES (13, N'Gezi')
INSERT [dbo].[TBCATEGORIES] ([CATID], [CATEGORYNAME]) VALUES (14, N'Dizi')
SET IDENTITY_INSERT [dbo].[TBCATEGORIES] OFF
SET IDENTITY_INSERT [dbo].[TBCUSTOMER] ON 

INSERT [dbo].[TBCUSTOMER] ([CUSTID], [NAME], [SURNAME], [EMAIL], [PASSWORD], [PHONE]) VALUES (1, N'Kerim', N'Uslu', N'kerim@hotmail.com', N'1', N'11111')
SET IDENTITY_INSERT [dbo].[TBCUSTOMER] OFF
SET IDENTITY_INSERT [dbo].[TBMOVIES] ON 

INSERT [dbo].[TBMOVIES] ([MOVIEID], [NAME], [YEAR], [TYPE], [CATID], [DESCRIPTION], [PRICE], [POSTERIMAGE], [ACTIVE], [SUPPID]) VALUES (2, N'Hababam Sınıfııı', 1976, N'DVD', 1, N'Hababam Sınıfı" Rıfat Ilgaz''ın en önemli eserlerinden biridir. Günümüze kadar Türkiye''de yazılmış en iyi mizah kitaplarındandır. Bir süre sonra tiyatroya ve sinemaya da uyarlanmış, İnek Şabanıyla Güdük Necmisiyle Tulum Hayrisiyle Türk Sinemasında bir efsane olmuştur. Günümüzde yeni karakterlerle de üç film çekilmiştir.', CAST(5.00 AS Decimal(18, 2)), N'1.jpg', 1, 2)
INSERT [dbo].[TBMOVIES] ([MOVIEID], [NAME], [YEAR], [TYPE], [CATID], [DESCRIPTION], [PRICE], [POSTERIMAGE], [ACTIVE], [SUPPID]) VALUES (3, N'Matrix 2', 1999, N'DVD', 8, N'asdasd', CAST(10.00 AS Decimal(18, 2)), N'9.jpg', 1, 2)
INSERT [dbo].[TBMOVIES] ([MOVIEID], [NAME], [YEAR], [TYPE], [CATID], [DESCRIPTION], [PRICE], [POSTERIMAGE], [ACTIVE], [SUPPID]) VALUES (4, N'Pardon', 2013, N'CD', 3, N'asda', CAST(10.00 AS Decimal(18, 2)), N'3.jpg', 0, 1)
INSERT [dbo].[TBMOVIES] ([MOVIEID], [NAME], [YEAR], [TYPE], [CATID], [DESCRIPTION], [PRICE], [POSTERIMAGE], [ACTIVE], [SUPPID]) VALUES (5, N'Hokkabaz', 2007, N'DVD', 3, N'asadad', CAST(11.00 AS Decimal(18, 2)), N'2.jpg', 1, 1)
SET IDENTITY_INSERT [dbo].[TBMOVIES] OFF
SET IDENTITY_INSERT [dbo].[TBORDER] ON 

INSERT [dbo].[TBORDER] ([ORDERID], [ORDERDATE], [ADDRESS], [CUSTID], [NOTES], [ORDERSTATUS]) VALUES (1, NULL, N'asdasd', 1, N'1', 2)
INSERT [dbo].[TBORDER] ([ORDERID], [ORDERDATE], [ADDRESS], [CUSTID], [NOTES], [ORDERSTATUS]) VALUES (2, CAST(0xDE360B00 AS Date), N'Merkez Mah. Üsküdar İst', 1, N'1', 2)
INSERT [dbo].[TBORDER] ([ORDERID], [ORDERDATE], [ADDRESS], [CUSTID], [NOTES], [ORDERSTATUS]) VALUES (3, CAST(0xDE360B00 AS Date), N'Başka bir adres caddesi Numan sokak No:1', 1, N'Güzelce paketleyin, düzgünce gönderin', 2)
INSERT [dbo].[TBORDER] ([ORDERID], [ORDERDATE], [ADDRESS], [CUSTID], [NOTES], [ORDERSTATUS]) VALUES (4, CAST(0xDE360B00 AS Date), N'Kaçmaz Mah. Ceren Sokak No:12 Esenler  / İstanbul', 1, N'Gazete kağıdına sarın.', 2)
SET IDENTITY_INSERT [dbo].[TBORDER] OFF
SET IDENTITY_INSERT [dbo].[TBSUPPLIER] ON 

INSERT [dbo].[TBSUPPLIER] ([SUPPID], [NAME], [PASSWORD]) VALUES (1, N'TeleMovies LTD', N'1')
INSERT [dbo].[TBSUPPLIER] ([SUPPID], [NAME], [PASSWORD]) VALUES (2, N'Ani Movies', N'1')
SET IDENTITY_INSERT [dbo].[TBSUPPLIER] OFF
ALTER TABLE [dbo].[TBCART] ADD  CONSTRAINT [DF_TBCART_ORDERID]  DEFAULT ((0)) FOR [ORDERID]
GO
ALTER TABLE [dbo].[TBCART] ADD  CONSTRAINT [DF_TBCART_SUPPLIED]  DEFAULT ((0)) FOR [SUPPLIED]
GO
ALTER TABLE [dbo].[TBCART]  WITH CHECK ADD  CONSTRAINT [FK_TBCART_TBCUSTOMER] FOREIGN KEY([CUSTID])
REFERENCES [dbo].[TBCUSTOMER] ([CUSTID])
GO
ALTER TABLE [dbo].[TBCART] CHECK CONSTRAINT [FK_TBCART_TBCUSTOMER]
GO
ALTER TABLE [dbo].[TBCART]  WITH CHECK ADD  CONSTRAINT [FK_TBCART_TBCUSTOMER1] FOREIGN KEY([CUSTID])
REFERENCES [dbo].[TBCUSTOMER] ([CUSTID])
GO
ALTER TABLE [dbo].[TBCART] CHECK CONSTRAINT [FK_TBCART_TBCUSTOMER1]
GO
ALTER TABLE [dbo].[TBCART]  WITH CHECK ADD  CONSTRAINT [FK_TBCART_TBMOVIES] FOREIGN KEY([MOVIEID])
REFERENCES [dbo].[TBMOVIES] ([MOVIEID])
GO
ALTER TABLE [dbo].[TBCART] CHECK CONSTRAINT [FK_TBCART_TBMOVIES]
GO
ALTER TABLE [dbo].[TBCART]  WITH NOCHECK ADD  CONSTRAINT [FK_TBCART_TBORDER] FOREIGN KEY([ORDERID])
REFERENCES [dbo].[TBORDER] ([ORDERID])
GO
ALTER TABLE [dbo].[TBCART] NOCHECK CONSTRAINT [FK_TBCART_TBORDER]
GO
ALTER TABLE [dbo].[TBMOVIES]  WITH CHECK ADD  CONSTRAINT [FK_TBMOVIES_TBCATEGORIES] FOREIGN KEY([CATID])
REFERENCES [dbo].[TBCATEGORIES] ([CATID])
GO
ALTER TABLE [dbo].[TBMOVIES] CHECK CONSTRAINT [FK_TBMOVIES_TBCATEGORIES]
GO
ALTER TABLE [dbo].[TBMOVIES]  WITH CHECK ADD  CONSTRAINT [FK_TBMOVIES_TBSUPPLIER] FOREIGN KEY([SUPPID])
REFERENCES [dbo].[TBSUPPLIER] ([SUPPID])
GO
ALTER TABLE [dbo].[TBMOVIES] CHECK CONSTRAINT [FK_TBMOVIES_TBSUPPLIER]
GO
ALTER TABLE [dbo].[TBORDER]  WITH CHECK ADD  CONSTRAINT [FK_TBORDER_TBCUSTOMER] FOREIGN KEY([CUSTID])
REFERENCES [dbo].[TBCUSTOMER] ([CUSTID])
GO
ALTER TABLE [dbo].[TBORDER] CHECK CONSTRAINT [FK_TBORDER_TBCUSTOMER]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[21] 2[10] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "TBCATEGORIES"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 211
               Right = 221
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "TBMOVIES"
            Begin Extent = 
               Top = 6
               Left = 259
               Bottom = 135
               Right = 429
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 10
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'SRGMOVIES'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'SRGMOVIES'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[21] 2[8] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "TBCART"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 211
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "TBMOVIES"
            Begin Extent = 
               Top = 6
               Left = 246
               Bottom = 211
               Right = 416
            End
            DisplayFlags = 280
            TopColumn = 2
         End
         Begin Table = "TBORDER"
            Begin Extent = 
               Top = 6
               Left = 454
               Bottom = 211
               Right = 624
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'SRGOrderSupp'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'SRGOrderSupp'
GO
USE [master]
GO
ALTER DATABASE [HAYATIMIZFILM] SET  READ_WRITE 
GO
