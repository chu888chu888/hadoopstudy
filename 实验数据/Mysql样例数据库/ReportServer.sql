/*
Navicat MySQL Data Transfer

Source Server         : 192.168.1.178
Source Server Version : 50544
Source Host           : 192.168.1.178:3306
Source Database       : ReportServer

Target Server Type    : MYSQL
Target Server Version : 50544
File Encoding         : 65001

Date: 2016-03-23 15:28:08
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for `ActiveSubscriptions`
-- ----------------------------
DROP TABLE IF EXISTS `ActiveSubscriptions`;
CREATE TABLE `ActiveSubscriptions` (
  `ActiveID` varchar(38) CHARACTER SET utf8 NOT NULL,
  `SubscriptionID` varchar(38) CHARACTER SET utf8 NOT NULL,
  `TotalNotifications` int(11) DEFAULT NULL,
  `TotalSuccesses` int(11) NOT NULL,
  `TotalFailures` int(11) NOT NULL,
  PRIMARY KEY (`ActiveID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of ActiveSubscriptions
-- ----------------------------

-- ----------------------------
-- Table structure for `Batch`
-- ----------------------------
DROP TABLE IF EXISTS `Batch`;
CREATE TABLE `Batch` (
  `BatchID` varchar(38) CHARACTER SET utf8 NOT NULL,
  `AddedOn` datetime NOT NULL,
  `Action` varchar(32) CHARACTER SET utf8 NOT NULL,
  `Item` text CHARACTER SET utf8,
  `Parent` text CHARACTER SET utf8,
  `Param` text CHARACTER SET utf8,
  `BoolParam` bit(1) DEFAULT NULL,
  `Content` longblob,
  `Properties` longtext CHARACTER SET utf8,
  KEY `IX_Batch` (`BatchID`,`AddedOn`),
  KEY `IX_Batch_1` (`AddedOn`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of Batch
-- ----------------------------

-- ----------------------------
-- Table structure for `CachePolicy`
-- ----------------------------
DROP TABLE IF EXISTS `CachePolicy`;
CREATE TABLE `CachePolicy` (
  `CachePolicyID` varchar(38) CHARACTER SET utf8 NOT NULL,
  `ReportID` varchar(38) CHARACTER SET utf8 NOT NULL,
  `ExpirationFlags` int(11) NOT NULL,
  `CacheExpiration` int(11) DEFAULT NULL,
  PRIMARY KEY (`CachePolicyID`),
  UNIQUE KEY `IX_CachePolicyReportID` (`ReportID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of CachePolicy
-- ----------------------------

-- ----------------------------
-- Table structure for `Catalog`
-- ----------------------------
DROP TABLE IF EXISTS `Catalog`;
CREATE TABLE `Catalog` (
  `ItemID` varchar(38) CHARACTER SET utf8 NOT NULL,
  `Path` text CHARACTER SET utf8 NOT NULL,
  `Name` text CHARACTER SET utf8 NOT NULL,
  `ParentID` varchar(38) CHARACTER SET utf8 DEFAULT NULL,
  `Type` int(11) NOT NULL,
  `Content` longblob,
  `Intermediate` varchar(38) CHARACTER SET utf8 DEFAULT NULL,
  `SnapshotDataID` varchar(38) CHARACTER SET utf8 DEFAULT NULL,
  `LinkSourceID` varchar(38) CHARACTER SET utf8 DEFAULT NULL,
  `Property` longtext CHARACTER SET utf8,
  `Description` text CHARACTER SET utf8,
  `Hidden` bit(1) DEFAULT NULL,
  `CreatedByID` varchar(38) CHARACTER SET utf8 NOT NULL,
  `CreationDate` datetime NOT NULL,
  `ModifiedByID` varchar(38) CHARACTER SET utf8 NOT NULL,
  `ModifiedDate` datetime NOT NULL,
  `MimeType` text CHARACTER SET utf8,
  `SnapshotLimit` int(11) DEFAULT NULL,
  `Parameter` longtext CHARACTER SET utf8,
  `PolicyID` varchar(38) CHARACTER SET utf8 NOT NULL,
  `PolicyRoot` bit(1) NOT NULL,
  `ExecutionFlag` int(11) NOT NULL,
  `ExecutionTime` datetime DEFAULT NULL,
  PRIMARY KEY (`ItemID`),
  KEY `IX_Link` (`LinkSourceID`),
  KEY `IX_Parent` (`ParentID`),
  KEY `IX_SnapshotDataId` (`SnapshotDataID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of Catalog
-- ----------------------------
INSERT INTO `Catalog` VALUES ('{D9830078-1148-48C4-B344-94AFA1FBC13B}', '', '', null, '1', null, null, null, null, null, null, null, '{61C4C208-F297-4E31-A3FC-277E6E2C56E4}', '2016-03-21 19:07:19', '{61C4C208-F297-4E31-A3FC-277E6E2C56E4}', '2016-03-21 19:07:19', null, null, null, '{5F5A7A8E-788C-406A-8E68-05F7E6FA8225}', '', '1', null);

-- ----------------------------
-- Table structure for `ChunkData`
-- ----------------------------
DROP TABLE IF EXISTS `ChunkData`;
CREATE TABLE `ChunkData` (
  `ChunkID` varchar(38) CHARACTER SET utf8 NOT NULL,
  `SnapshotDataID` varchar(38) CHARACTER SET utf8 NOT NULL,
  `ChunkFlags` tinyint(3) unsigned DEFAULT NULL,
  `ChunkName` text CHARACTER SET utf8,
  `ChunkType` int(11) DEFAULT NULL,
  `Version` smallint(6) DEFAULT NULL,
  `MimeType` text CHARACTER SET utf8,
  `Content` longblob,
  PRIMARY KEY (`ChunkID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of ChunkData
-- ----------------------------

-- ----------------------------
-- Table structure for `ChunkSegmentMapping`
-- ----------------------------
DROP TABLE IF EXISTS `ChunkSegmentMapping`;
CREATE TABLE `ChunkSegmentMapping` (
  `ChunkId` varchar(38) CHARACTER SET utf8 NOT NULL,
  `SegmentId` varchar(38) CHARACTER SET utf8 NOT NULL,
  `StartByte` bigint(20) NOT NULL,
  `LogicalByteCount` int(11) NOT NULL,
  `ActualByteCount` int(11) NOT NULL,
  PRIMARY KEY (`ChunkId`,`SegmentId`),
  UNIQUE KEY `UNIQ_ChunkId_StartByte` (`ChunkId`,`StartByte`),
  KEY `IX_ChunkSegmentMapping_SegmentId` (`SegmentId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of ChunkSegmentMapping
-- ----------------------------

-- ----------------------------
-- Table structure for `ConfigurationInfo`
-- ----------------------------
DROP TABLE IF EXISTS `ConfigurationInfo`;
CREATE TABLE `ConfigurationInfo` (
  `ConfigInfoID` varchar(38) CHARACTER SET utf8 NOT NULL,
  `Name` text CHARACTER SET utf8 NOT NULL,
  `Value` longtext CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`ConfigInfoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of ConfigurationInfo
-- ----------------------------
INSERT INTO `ConfigurationInfo` VALUES ('{0D145A87-B02E-4935-814D-0E86346E1FCE}', 'ExternalImagesTimeout', '600');
INSERT INTO `ConfigurationInfo` VALUES ('{235188D3-553E-43F1-9D5C-84153359230E}', 'EnableMyReports', 'False');
INSERT INTO `ConfigurationInfo` VALUES ('{2C05385E-B9E2-4EC7-B07C-3EF8B73E35A2}', 'SystemSnapshotLimit', '-1');
INSERT INTO `ConfigurationInfo` VALUES ('{4633DC1E-6C4F-45A5-9BB7-EAFF3C279CC5}', 'SessionTimeout', '600');
INSERT INTO `ConfigurationInfo` VALUES ('{4721AA63-4BC8-4050-95D2-B8A733C4553D}', 'StoredParametersThreshold', '1500');
INSERT INTO `ConfigurationInfo` VALUES ('{4AB1ECC2-A8E4-49D7-AC38-1867CFE561F9}', 'EnableLoadReportDefinition', 'True');
INSERT INTO `ConfigurationInfo` VALUES ('{5FE922E0-A42F-4014-AE7B-C133BD86DE6D}', 'EnableRemoteErrors', 'False');
INSERT INTO `ConfigurationInfo` VALUES ('{63C172D8-DD90-4EA0-9AC6-BD758FE1EC34}', 'EnableExecutionLogging', 'True');
INSERT INTO `ConfigurationInfo` VALUES ('{66BB6AE4-A94F-4E4E-ABC6-0926C2D92743}', 'ExecutionLogDaysKept', '60');
INSERT INTO `ConfigurationInfo` VALUES ('{66F3167D-00A6-463D-9D68-51BDF6EDC719}', 'EnableClientPrinting', 'True');
INSERT INTO `ConfigurationInfo` VALUES ('{7AAFB2F0-950B-461A-9FCD-7C7B02CE58D4}', 'SharePointIntegrated', 'False');
INSERT INTO `ConfigurationInfo` VALUES ('{836045D1-0C14-4FAE-808E-9D46FED8D81C}', 'EnableIntegratedSecurity', 'true');
INSERT INTO `ConfigurationInfo` VALUES ('{9AAF7317-089F-4D66-A368-6087B8AA391B}', 'UseSessionCookies', 'true');
INSERT INTO `ConfigurationInfo` VALUES ('{A4EAB470-5F0A-4DB8-B1ED-429A0136D8B6}', 'SnapshotCompression', 'SQL');
INSERT INTO `ConfigurationInfo` VALUES ('{A85C98E7-C072-48D4-8D89-FA186F9B778E}', 'MyReportsRole', '我的报表');
INSERT INTO `ConfigurationInfo` VALUES ('{C0137D39-3426-4E9A-8955-1089BBDE0EBC}', 'EnableReportDesignClientDownload', 'True');
INSERT INTO `ConfigurationInfo` VALUES ('{C9374949-2985-4EEC-AA0E-432112875446}', 'ReportBuilderLaunchURL', '');
INSERT INTO `ConfigurationInfo` VALUES ('{DA2DCD7C-DE56-41C2-8605-77BDE4099EA1}', 'StoredParametersLifetime', '180');
INSERT INTO `ConfigurationInfo` VALUES ('{F6E70610-2356-47F4-808F-EF720DE19AAE}', 'SiteName', 'SQL Server Reporting Services');
INSERT INTO `ConfigurationInfo` VALUES ('{FCF8093A-6488-456F-B70C-20A2D2997BEF}', 'SystemReportTimeout', '1800');

-- ----------------------------
-- Table structure for `DataSource`
-- ----------------------------
DROP TABLE IF EXISTS `DataSource`;
CREATE TABLE `DataSource` (
  `DSID` varchar(38) CHARACTER SET utf8 NOT NULL,
  `ItemID` varchar(38) CHARACTER SET utf8 DEFAULT NULL,
  `SubscriptionID` varchar(38) CHARACTER SET utf8 DEFAULT NULL,
  `Name` text CHARACTER SET utf8,
  `Extension` text CHARACTER SET utf8,
  `Link` varchar(38) CHARACTER SET utf8 DEFAULT NULL,
  `CredentialRetrieval` int(11) DEFAULT NULL,
  `Prompt` longtext CHARACTER SET utf8,
  `ConnectionString` longblob,
  `OriginalConnectionString` longblob,
  `OriginalConnectStringExpressionBased` bit(1) DEFAULT NULL,
  `UserName` longblob,
  `Password` longblob,
  `Flags` int(11) DEFAULT NULL,
  `Version` int(11) NOT NULL,
  PRIMARY KEY (`DSID`),
  KEY `IX_DataSourceItemID` (`ItemID`),
  KEY `IX_DataSourceSubscriptionID` (`SubscriptionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of DataSource
-- ----------------------------

-- ----------------------------
-- Table structure for `Event`
-- ----------------------------
DROP TABLE IF EXISTS `Event`;
CREATE TABLE `Event` (
  `EventID` varchar(38) CHARACTER SET utf8 NOT NULL,
  `EventType` text CHARACTER SET utf8 NOT NULL,
  `EventData` text CHARACTER SET utf8,
  `TimeEntered` datetime NOT NULL,
  `ProcessStart` datetime DEFAULT NULL,
  `ProcessHeartbeat` datetime DEFAULT NULL,
  `BatchID` varchar(38) CHARACTER SET utf8 DEFAULT NULL,
  PRIMARY KEY (`EventID`),
  KEY `IX_Event_TimeEntered` (`TimeEntered`),
  KEY `IX_Event2` (`ProcessStart`),
  KEY `IX_Event3` (`TimeEntered`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of Event
-- ----------------------------

-- ----------------------------
-- Table structure for `ExecutionLogStorage`
-- ----------------------------
DROP TABLE IF EXISTS `ExecutionLogStorage`;
CREATE TABLE `ExecutionLogStorage` (
  `LogEntryId` bigint(20) NOT NULL AUTO_INCREMENT,
  `InstanceName` varchar(38) CHARACTER SET utf8 NOT NULL,
  `ReportID` varchar(38) CHARACTER SET utf8 DEFAULT NULL,
  `UserName` text CHARACTER SET utf8,
  `ExecutionId` varchar(64) CHARACTER SET utf8 DEFAULT NULL,
  `RequestType` bit(1) NOT NULL,
  `Format` varchar(26) CHARACTER SET utf8 DEFAULT NULL,
  `Parameters` longtext CHARACTER SET utf8,
  `ReportAction` tinyint(3) unsigned DEFAULT NULL,
  `TimeStart` datetime NOT NULL,
  `TimeEnd` datetime NOT NULL,
  `TimeDataRetrieval` int(11) NOT NULL,
  `TimeProcessing` int(11) NOT NULL,
  `TimeRendering` int(11) NOT NULL,
  `Source` tinyint(3) unsigned NOT NULL,
  `Status` varchar(40) CHARACTER SET utf8 NOT NULL,
  `ByteCount` bigint(20) NOT NULL,
  `RowCount` bigint(20) NOT NULL,
  `AdditionalInfo` longtext CHARACTER SET utf8,
  PRIMARY KEY (`LogEntryId`),
  KEY `IX_ExecutionLog` (`TimeStart`,`LogEntryId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of ExecutionLogStorage
-- ----------------------------

-- ----------------------------
-- Table structure for `History`
-- ----------------------------
DROP TABLE IF EXISTS `History`;
CREATE TABLE `History` (
  `HistoryID` varchar(38) CHARACTER SET utf8 NOT NULL,
  `ReportID` varchar(38) CHARACTER SET utf8 NOT NULL,
  `SnapshotDataID` varchar(38) CHARACTER SET utf8 NOT NULL,
  `SnapshotDate` datetime NOT NULL,
  PRIMARY KEY (`HistoryID`),
  UNIQUE KEY `IX_History` (`ReportID`,`SnapshotDate`),
  KEY `IX_SnapshotDataID` (`SnapshotDataID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of History
-- ----------------------------

-- ----------------------------
-- Table structure for `Keys`
-- ----------------------------
DROP TABLE IF EXISTS `Keys`;
CREATE TABLE `Keys` (
  `MachineName` text CHARACTER SET utf8,
  `InstallationID` varchar(38) CHARACTER SET utf8 NOT NULL,
  `InstanceName` varchar(32) CHARACTER SET utf8 DEFAULT NULL,
  `Client` int(11) NOT NULL,
  `PublicKey` longblob,
  `SymmetricKey` longblob,
  PRIMARY KEY (`InstallationID`,`Client`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of Keys
-- ----------------------------
INSERT INTO `Keys` VALUES (null, '{00000000-0000-0000-0000-000000000000}', null, '-1', null, null);
INSERT INTO `Keys` VALUES ('WIN-ESSN6PRNLGJ', '{6928A122-9989-4A63-B997-4795147FF058}', 'MSSQLSERVER', '1', 0x0602000000A4000052534131000400000100010059624B45FE4C5D3EC66E4CFE50B511250DE6A63DEC1623D6D2506D7203B587DAE77A067F8C9BA75633F22D8CB73D477E58839C12BFD1C7DEA317E96844D6074C2707E465A89349CB15D5DF2ED7DE3CDEF9450CFD7A6EFE5807ABE91762FE2D1D1E6FD464ED416A71CD36F78237E62332BA8CB16748FDDDD7D6D812E1A2CAC3C5, 0x010200000366000000A40000F77295EA7F397B0260F626ECC68F77E43E26D70BF3F96EB50A74EEEB95A22467B70353D170CFD99977A750457C227751DD5B069CA46592742ED96FE79B60643A121CF487188E2A724156545B686B98DA3BC01EBB06FE22688D86E7490D3840121398637581395764417E11E83191ABE0B43D7C072C1623F5F36B911A9F042971);

-- ----------------------------
-- Table structure for `ModelDrill`
-- ----------------------------
DROP TABLE IF EXISTS `ModelDrill`;
CREATE TABLE `ModelDrill` (
  `ModelDrillID` varchar(38) CHARACTER SET utf8 NOT NULL,
  `ModelID` varchar(38) CHARACTER SET utf8 NOT NULL,
  `ReportID` varchar(38) CHARACTER SET utf8 NOT NULL,
  `ModelItemID` text CHARACTER SET utf8 NOT NULL,
  `Type` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`ModelDrillID`),
  UNIQUE KEY `IX_ModelDrillModelID` (`ModelID`,`ReportID`,`ModelDrillID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of ModelDrill
-- ----------------------------

-- ----------------------------
-- Table structure for `ModelItemPolicy`
-- ----------------------------
DROP TABLE IF EXISTS `ModelItemPolicy`;
CREATE TABLE `ModelItemPolicy` (
  `ID` varchar(38) CHARACTER SET utf8 NOT NULL,
  `CatalogItemID` varchar(38) CHARACTER SET utf8 NOT NULL,
  `ModelItemID` text CHARACTER SET utf8 NOT NULL,
  `PolicyID` varchar(38) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of ModelItemPolicy
-- ----------------------------

-- ----------------------------
-- Table structure for `ModelPerspective`
-- ----------------------------
DROP TABLE IF EXISTS `ModelPerspective`;
CREATE TABLE `ModelPerspective` (
  `ID` varchar(38) CHARACTER SET utf8 NOT NULL,
  `ModelID` varchar(38) CHARACTER SET utf8 NOT NULL,
  `PerspectiveID` longtext CHARACTER SET utf8 NOT NULL,
  `PerspectiveName` longtext CHARACTER SET utf8,
  `PerspectiveDescription` longtext CHARACTER SET utf8,
  KEY `IX_ModelPerspective` (`ModelID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of ModelPerspective
-- ----------------------------

-- ----------------------------
-- Table structure for `Notifications`
-- ----------------------------
DROP TABLE IF EXISTS `Notifications`;
CREATE TABLE `Notifications` (
  `NotificationID` varchar(38) CHARACTER SET utf8 NOT NULL,
  `SubscriptionID` varchar(38) CHARACTER SET utf8 NOT NULL,
  `ActivationID` varchar(38) CHARACTER SET utf8 DEFAULT NULL,
  `ReportID` varchar(38) CHARACTER SET utf8 NOT NULL,
  `SnapShotDate` datetime DEFAULT NULL,
  `ExtensionSettings` longtext CHARACTER SET utf8 NOT NULL,
  `Locale` varchar(128) CHARACTER SET utf8 NOT NULL,
  `Parameters` longtext CHARACTER SET utf8,
  `ProcessStart` datetime DEFAULT NULL,
  `NotificationEntered` datetime NOT NULL,
  `ProcessAfter` datetime DEFAULT NULL,
  `Attempt` int(11) DEFAULT NULL,
  `SubscriptionLastRunTime` datetime NOT NULL,
  `DeliveryExtension` text CHARACTER SET utf8 NOT NULL,
  `SubscriptionOwnerID` varchar(38) CHARACTER SET utf8 NOT NULL,
  `IsDataDriven` bit(1) NOT NULL,
  `BatchID` varchar(38) CHARACTER SET utf8 DEFAULT NULL,
  `ProcessHeartbeat` datetime DEFAULT NULL,
  `Version` int(11) NOT NULL,
  PRIMARY KEY (`NotificationID`),
  KEY `IX_Notifications` (`ProcessAfter`),
  KEY `IX_Notifications2` (`ProcessStart`),
  KEY `IX_Notifications3` (`NotificationEntered`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of Notifications
-- ----------------------------

-- ----------------------------
-- Table structure for `Policies`
-- ----------------------------
DROP TABLE IF EXISTS `Policies`;
CREATE TABLE `Policies` (
  `PolicyID` varchar(38) CHARACTER SET utf8 NOT NULL,
  `PolicyFlag` tinyint(3) unsigned DEFAULT NULL,
  PRIMARY KEY (`PolicyID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of Policies
-- ----------------------------
INSERT INTO `Policies` VALUES ('{42BDF7AD-613C-4B00-A617-069473CBCD7A}', '1');
INSERT INTO `Policies` VALUES ('{5F5A7A8E-788C-406A-8E68-05F7E6FA8225}', '0');

-- ----------------------------
-- Table structure for `PolicyUserRole`
-- ----------------------------
DROP TABLE IF EXISTS `PolicyUserRole`;
CREATE TABLE `PolicyUserRole` (
  `ID` varchar(38) CHARACTER SET utf8 NOT NULL,
  `RoleID` varchar(38) CHARACTER SET utf8 NOT NULL,
  `UserID` varchar(38) CHARACTER SET utf8 NOT NULL,
  `PolicyID` varchar(38) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `IX_PolicyUserRole` (`RoleID`,`UserID`,`PolicyID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of PolicyUserRole
-- ----------------------------
INSERT INTO `PolicyUserRole` VALUES ('{2D9D6DF3-816E-4FA3-B4FF-493C0301FB04}', '{2A4E242C-0A95-4C55-B7C2-F32195041D6E}', '{896F21C2-DA8E-4E2A-9DCA-A8E06B3DE14D}', '{5F5A7A8E-788C-406A-8E68-05F7E6FA8225}');
INSERT INTO `PolicyUserRole` VALUES ('{64A9F151-8673-4D89-9D90-DF29E02C1273}', '{472C7AD4-75C3-4424-909C-615E4B87B988}', '{4B07A6F0-4B95-4EC0-A1F4-DEE61163F6AD}', '{5F5A7A8E-788C-406A-8E68-05F7E6FA8225}');
INSERT INTO `PolicyUserRole` VALUES ('{BF3D5CD0-3B71-4839-B767-9CB25FD4761E}', '{9ACCE1BC-AFC1-44A3-9843-6790561198E9}', '{4B07A6F0-4B95-4EC0-A1F4-DEE61163F6AD}', '{42BDF7AD-613C-4B00-A617-069473CBCD7A}');
INSERT INTO `PolicyUserRole` VALUES ('{B32EBFFB-7C69-4CA3-8E2E-A27036EBB83A}', '{CCF8041E-8FF7-4103-9DAB-A29378A4AC4B}', '{896F21C2-DA8E-4E2A-9DCA-A8E06B3DE14D}', '{42BDF7AD-613C-4B00-A617-069473CBCD7A}');

-- ----------------------------
-- Table structure for `ReportSchedule`
-- ----------------------------
DROP TABLE IF EXISTS `ReportSchedule`;
CREATE TABLE `ReportSchedule` (
  `ScheduleID` varchar(38) CHARACTER SET utf8 NOT NULL,
  `ReportID` varchar(38) CHARACTER SET utf8 NOT NULL,
  `SubscriptionID` varchar(38) CHARACTER SET utf8 DEFAULT NULL,
  `ReportAction` int(11) NOT NULL,
  KEY `IX_ReportSchedule_ReportID` (`ReportID`),
  KEY `IX_ReportSchedule_ScheduleID` (`ScheduleID`),
  KEY `IX_ReportSchedule_SubscriptionID` (`SubscriptionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of ReportSchedule
-- ----------------------------

-- ----------------------------
-- Table structure for `Roles`
-- ----------------------------
DROP TABLE IF EXISTS `Roles`;
CREATE TABLE `Roles` (
  `RoleID` varchar(38) CHARACTER SET utf8 NOT NULL,
  `RoleName` text CHARACTER SET utf8 NOT NULL,
  `Description` text CHARACTER SET utf8,
  `TaskMask` varchar(32) CHARACTER SET utf8 NOT NULL,
  `RoleFlags` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`RoleID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of Roles
-- ----------------------------
INSERT INTO `Roles` VALUES ('{2A4E242C-0A95-4C55-B7C2-F32195041D6E}', '浏览者', '可以查看文件夹、报表和订阅报表。', '0010101001000100', '0');
INSERT INTO `Roles` VALUES ('{338BF366-F893-4AE3-BF29-D4375C383877}', '模型项浏览者', '允许用户查看特定模型中的模型项。', '1', '2');
INSERT INTO `Roles` VALUES ('{39CAF1BD-414B-43CB-AF65-4859099D8FBA}', '发布者', '可以将报表和链接报表发布到报表服务器。', '0101010100001010', '0');
INSERT INTO `Roles` VALUES ('{472C7AD4-75C3-4424-909C-615E4B87B988}', '内容管理员', '可以管理报表服务器中的内容，包括文件夹、报表和资源。', '1111111111111111', '0');
INSERT INTO `Roles` VALUES ('{74E40DCC-E7D4-4C82-9B76-9FFB93802334}', '我的报表', '可以发布报表和链接报表；管理用户的“我的报表”文件夹中的文件夹、报表和资源。', '0111111111011000', '0');
INSERT INTO `Roles` VALUES ('{9ACCE1BC-AFC1-44A3-9843-6790561198E9}', '系统管理员', '查看和修改系统角色分配、系统角色定义、系统属性和共享计划。', '110101011', '1');
INSERT INTO `Roles` VALUES ('{CC3256E9-0172-4482-A44A-789121091858}', '报表生成器', '可以查看报表定义。', '0010101001000101', '0');
INSERT INTO `Roles` VALUES ('{CCF8041E-8FF7-4103-9DAB-A29378A4AC4B}', '系统用户', '查看系统属性和共享计划。', '001010001', '1');

-- ----------------------------
-- Table structure for `RunningJobs`
-- ----------------------------
DROP TABLE IF EXISTS `RunningJobs`;
CREATE TABLE `RunningJobs` (
  `JobID` varchar(32) CHARACTER SET utf8 NOT NULL,
  `StartDate` datetime NOT NULL,
  `ComputerName` varchar(32) CHARACTER SET utf8 NOT NULL,
  `RequestName` text CHARACTER SET utf8 NOT NULL,
  `RequestPath` text CHARACTER SET utf8 NOT NULL,
  `UserId` varchar(38) CHARACTER SET utf8 NOT NULL,
  `Description` longtext CHARACTER SET utf8,
  `Timeout` int(11) NOT NULL,
  `JobAction` smallint(6) NOT NULL,
  `JobType` smallint(6) NOT NULL,
  `JobStatus` smallint(6) NOT NULL,
  PRIMARY KEY (`JobID`),
  KEY `IX_RunningJobsStatus` (`ComputerName`,`JobType`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of RunningJobs
-- ----------------------------

-- ----------------------------
-- Table structure for `Schedule`
-- ----------------------------
DROP TABLE IF EXISTS `Schedule`;
CREATE TABLE `Schedule` (
  `ScheduleID` varchar(38) CHARACTER SET utf8 NOT NULL,
  `Name` text CHARACTER SET utf8 NOT NULL,
  `StartDate` datetime NOT NULL,
  `Flags` int(11) NOT NULL,
  `NextRunTime` datetime DEFAULT NULL,
  `LastRunTime` datetime DEFAULT NULL,
  `EndDate` datetime DEFAULT NULL,
  `RecurrenceType` int(11) DEFAULT NULL,
  `MinutesInterval` int(11) DEFAULT NULL,
  `DaysInterval` int(11) DEFAULT NULL,
  `WeeksInterval` int(11) DEFAULT NULL,
  `DaysOfWeek` int(11) DEFAULT NULL,
  `DaysOfMonth` int(11) DEFAULT NULL,
  `Month` int(11) DEFAULT NULL,
  `MonthlyWeek` int(11) DEFAULT NULL,
  `State` int(11) DEFAULT NULL,
  `LastRunStatus` text CHARACTER SET utf8,
  `ScheduledRunTimeout` int(11) DEFAULT NULL,
  `CreatedById` varchar(38) CHARACTER SET utf8 NOT NULL,
  `EventType` text CHARACTER SET utf8 NOT NULL,
  `EventData` text CHARACTER SET utf8,
  `Type` int(11) NOT NULL,
  `ConsistancyCheck` datetime DEFAULT NULL,
  `Path` text CHARACTER SET utf8,
  PRIMARY KEY (`ScheduleID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of Schedule
-- ----------------------------

-- ----------------------------
-- Table structure for `SecData`
-- ----------------------------
DROP TABLE IF EXISTS `SecData`;
CREATE TABLE `SecData` (
  `SecDataID` varchar(38) CHARACTER SET utf8 NOT NULL,
  `PolicyID` varchar(38) CHARACTER SET utf8 NOT NULL,
  `AuthType` int(11) NOT NULL,
  `XmlDescription` longtext CHARACTER SET utf8 NOT NULL,
  `NtSecDescPrimary` longblob NOT NULL,
  `NtSecDescSecondary` longtext CHARACTER SET utf8,
  PRIMARY KEY (`SecDataID`),
  UNIQUE KEY `IX_SecData` (`PolicyID`,`AuthType`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of SecData
-- ----------------------------
INSERT INTO `SecData` VALUES ('{4A45D988-C982-4310-BE00-81501EE3A941}', '{5F5A7A8E-788C-406A-8E68-05F7E6FA8225}', '1', '<Policies><Policy><GroupUserName>BUILTIN\\Administrators</GroupUserName><GroupUserId>AQIAAAAAAAUgAAAAIAIAAA==</GroupUserId><Roles><Role><Name>内容管理员</Name></Role></Roles></Policy></Policies>', 0x06050054000000020100048034000000440000000000000014000000020020000100000000041800FF00060001020000000000052000000020020000010200000000000520000000200200000102000000000005200000002002000054000000030100048034000000440000000000000014000000020020000100000000041800FFFF3F00010200000000000520000000200200000102000000000005200000002002000001020000000000052000000020020000540000000401000480340000004400000000000000140000000200200001000000000418001D000000010200000000000520000000200200000102000000000005200000002002000001020000000000052000000020020000540000000501000480340000004400000000000000140000000200200001000000000418001F000600010200000000000520000000200200000102000000000005200000002002000001020000000000052000000020020000540000000601000480340000004400000000000000140000000200200001000000000418001F00060001020000000000052000000020020000010200000000000520000000200200000102000000000005200000002002000054000000070100048034000000440000000000000014000000020020000100000000041800FF010600010200000000000520000000200200000102000000000005200000002002000001020000000000052000000020020000, null);
INSERT INTO `SecData` VALUES ('{95E2CFB3-F5F0-4EDB-83F0-3F5E0E9DE6DE}', '{42BDF7AD-613C-4B00-A617-069473CBCD7A}', '1', '<Policies><Policy><GroupUserName>BUILTIN\\Administrators</GroupUserName><GroupUserId>AQIAAAAAAAUgAAAAIAIAAA==</GroupUserId><Roles><Role><Name>系统管理员</Name></Role></Roles></Policy></Policies>', 0x01050054000000010100048034000000440000000000000014000000020020000100000000041800BF3F0600010200000000000520000000200200000102000000000005200000002002000001020000000000052000000020020000, null);

-- ----------------------------
-- Table structure for `Segment`
-- ----------------------------
DROP TABLE IF EXISTS `Segment`;
CREATE TABLE `Segment` (
  `SegmentId` varchar(38) CHARACTER SET utf8 NOT NULL DEFAULT 'newsequentialid()',
  `Content` longblob,
  PRIMARY KEY (`SegmentId`),
  UNIQUE KEY `IX_SegmentMetadata` (`SegmentId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of Segment
-- ----------------------------

-- ----------------------------
-- Table structure for `SegmentedChunk`
-- ----------------------------
DROP TABLE IF EXISTS `SegmentedChunk`;
CREATE TABLE `SegmentedChunk` (
  `ChunkId` varchar(38) CHARACTER SET utf8 NOT NULL DEFAULT 'newsequentialid()',
  `SnapshotDataId` varchar(38) CHARACTER SET utf8 NOT NULL,
  `ChunkFlags` tinyint(3) unsigned NOT NULL,
  `ChunkName` text CHARACTER SET utf8 NOT NULL,
  `ChunkType` int(11) NOT NULL,
  `Version` smallint(6) NOT NULL,
  `MimeType` text CHARACTER SET utf8,
  `SegmentedChunkId` bigint(20) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`SegmentedChunkId`),
  KEY `IX_ChunkId_SnapshotDataId` (`ChunkId`,`SnapshotDataId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of SegmentedChunk
-- ----------------------------

-- ----------------------------
-- Table structure for `ServerParametersInstance`
-- ----------------------------
DROP TABLE IF EXISTS `ServerParametersInstance`;
CREATE TABLE `ServerParametersInstance` (
  `ServerParametersID` varchar(32) CHARACTER SET utf8 NOT NULL,
  `ParentID` varchar(32) CHARACTER SET utf8 DEFAULT NULL,
  `Path` text CHARACTER SET utf8 NOT NULL,
  `CreateDate` datetime NOT NULL,
  `ModifiedDate` datetime NOT NULL,
  `Timeout` int(11) NOT NULL,
  `Expiration` datetime NOT NULL,
  `ParametersValues` longblob NOT NULL,
  PRIMARY KEY (`ServerParametersID`),
  KEY `IX_ServerParametersInstanceExpiration` (`Expiration`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of ServerParametersInstance
-- ----------------------------

-- ----------------------------
-- Table structure for `SnapshotData`
-- ----------------------------
DROP TABLE IF EXISTS `SnapshotData`;
CREATE TABLE `SnapshotData` (
  `SnapshotDataID` varchar(38) CHARACTER SET utf8 NOT NULL,
  `CreatedDate` datetime NOT NULL,
  `ParamsHash` int(11) DEFAULT NULL,
  `QueryParams` longtext CHARACTER SET utf8,
  `EffectiveParams` longtext CHARACTER SET utf8,
  `Description` text CHARACTER SET utf8,
  `DependsOnUser` bit(1) DEFAULT NULL,
  `PermanentRefcount` int(11) NOT NULL,
  `TransientRefcount` int(11) NOT NULL,
  `ExpirationDate` datetime NOT NULL,
  `PageCount` int(11) DEFAULT NULL,
  `HasDocMap` bit(1) DEFAULT NULL,
  `PaginationMode` smallint(6) DEFAULT NULL,
  `ProcessingFlags` int(11) DEFAULT NULL,
  PRIMARY KEY (`SnapshotDataID`),
  KEY `IX_SnapshotCleaning` (`PermanentRefcount`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of SnapshotData
-- ----------------------------

-- ----------------------------
-- Table structure for `Subscriptions`
-- ----------------------------
DROP TABLE IF EXISTS `Subscriptions`;
CREATE TABLE `Subscriptions` (
  `SubscriptionID` varchar(38) CHARACTER SET utf8 NOT NULL,
  `OwnerID` varchar(38) CHARACTER SET utf8 NOT NULL,
  `Report_OID` varchar(38) CHARACTER SET utf8 NOT NULL,
  `Locale` varchar(128) CHARACTER SET utf8 NOT NULL,
  `InactiveFlags` int(11) NOT NULL,
  `ExtensionSettings` longtext CHARACTER SET utf8,
  `ModifiedByID` varchar(38) CHARACTER SET utf8 NOT NULL,
  `ModifiedDate` datetime NOT NULL,
  `Description` text CHARACTER SET utf8,
  `LastStatus` text CHARACTER SET utf8,
  `EventType` text CHARACTER SET utf8 NOT NULL,
  `MatchData` longtext CHARACTER SET utf8,
  `LastRunTime` datetime DEFAULT NULL,
  `Parameters` longtext CHARACTER SET utf8,
  `DataSettings` longtext CHARACTER SET utf8,
  `DeliveryExtension` text CHARACTER SET utf8,
  `Version` int(11) NOT NULL,
  PRIMARY KEY (`SubscriptionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of Subscriptions
-- ----------------------------

-- ----------------------------
-- Table structure for `SubscriptionsBeingDeleted`
-- ----------------------------
DROP TABLE IF EXISTS `SubscriptionsBeingDeleted`;
CREATE TABLE `SubscriptionsBeingDeleted` (
  `SubscriptionID` varchar(38) CHARACTER SET utf8 NOT NULL,
  `CreationDate` datetime NOT NULL,
  PRIMARY KEY (`SubscriptionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of SubscriptionsBeingDeleted
-- ----------------------------

-- ----------------------------
-- Table structure for `UpgradeInfo`
-- ----------------------------
DROP TABLE IF EXISTS `UpgradeInfo`;
CREATE TABLE `UpgradeInfo` (
  `Item` text CHARACTER SET utf8 NOT NULL,
  `Status` text CHARACTER SET utf8
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of UpgradeInfo
-- ----------------------------
INSERT INTO `UpgradeInfo` VALUES ('MigrateExecutionLog', 'True');

-- ----------------------------
-- Table structure for `Users`
-- ----------------------------
DROP TABLE IF EXISTS `Users`;
CREATE TABLE `Users` (
  `UserID` varchar(38) CHARACTER SET utf8 NOT NULL,
  `Sid` longblob,
  `UserType` int(11) NOT NULL,
  `AuthType` int(11) NOT NULL,
  `UserName` text CHARACTER SET utf8,
  PRIMARY KEY (`UserID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of Users
-- ----------------------------
INSERT INTO `Users` VALUES ('{4B07A6F0-4B95-4EC0-A1F4-DEE61163F6AD}', 0x01020000000000052000000020020000, '1', '1', 'BUILTIN\\Administrators');
INSERT INTO `Users` VALUES ('{61C4C208-F297-4E31-A3FC-277E6E2C56E4}', 0x010100000000000512000000, '0', '1', 'NT AUTHORITY\\SYSTEM');
INSERT INTO `Users` VALUES ('{896F21C2-DA8E-4E2A-9DCA-A8E06B3DE14D}', 0x010100000000000100000000, '1', '1', 'Everyone');
