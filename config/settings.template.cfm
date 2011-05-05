<cfscript>
	
/*
This file contains a number of important variables and settings for the application.
It should be saved as config/settings.cfm before running the app for the first time.
*/

coldspringDefaults = structNew();

/*
* storageType:
* **required
options are: 'local,s3'.  currently this is set once and can not be changed once the app is deployed
*/

coldspringDefaults.storageType = 'local';  

/*
* storageRootDir:
* **required
* the directory in which user data (images, attachments) is stored.
* this should be web accessible.  
* if using local storage this might look something like:
*	expandPath('/store/');
* if using s3 it might be:
*	's3://foo.com'; 
*/

coldspringDefaults.storageRootDir = expandPath('/store/');

/*
* storeBaseURL:
* **required
* the full base URL to the directory for storage
* local example:
*	'http://' & cgi.server_name & '/store/'
* s3 example:
*	'http://s3.amazonaws.com/foo.com'
*/

coldspringDefaults.storeBaseURL = 'http://' & cgi.server_name & '/store/';

/*
* s3ID:
* if using s3 this is your canonical ID (used for setting ACLs)
* see Ray's post for more info if needed: http://www.coldfusionjedi.com/index.cfm/2010/7/15/CF901-Guide-to-Amazon-S3-support-in-ColdFusion-901
*/

coldspringDefaults.s3ID = '';

/*
* appFriendlyName:
* **required
* this is used in various places like emails, etc
* ex:  'SlideSix'
*/

coldspringDefaults.appFriendlyName = '';

/*
* dsn:
* **required
* the name of the coldfusion dsn you set up for the app
*/

coldspringDefaults.dsn = '';

/*
* physicalTempRoot:
* **required
* a folder used for storing files temporarily
* if VFS is possible it will be utilized instead
* but certain tags/functions can not utilize VFS
* it's a really good idea to keep this outside of the
* webroot for security purposes
* ex:
*	getTempDirectory()
* ** will be created by the application if it does not exist **
*/

coldspringDefaults.physicalTempRoot = getTempDirectory();

/*
* virtualTempRoot:
* **required
* a folder used for storing files temporarily
* within the VFS.  VFS used whenever possible.
* ex:
* 'ram://' & this.name & '_temp/'
* ** will be created by the application if it does not exist **
*/

coldspringDefaults.virtualTempRoot = 'ram://' & this.name & '_temp/';

/*
* adminEmail:
* **required
* who should emails come from?
* ex:
*	admin@localhost.com
*/

coldspringDefaults.adminEmail = '';

/*
* emailType:
* **required
* 'html' or 'plain'
*/

coldspringDefaults.emailType = 'html';

/*
* mailServer:
* **required
* what server handles mail delivery? 
* used in <cfmail> tags
* **mail settings from cf admin are never used**
*/

coldspringDefaults.mailServer = '';

/*
* mailPort and mail credentials/options:
* **required
* ex: '25'
*/

coldspringDefaults.mailPort = '';
coldspringDefaults.mailUsername = '';
coldspringDefaults.mailPassword = '';
coldspringDefaults.useTLS = 'false';
coldspringDefaults.useSSL = 'false';

/* 
* emailDevelopmentModeEnabled:
* **required
* when true emails will never be delivered but will be spooled
* used to prevent dev server from sending unintenional emails
*/

coldspringDefaults.emailDevelopmentModeEnabled = true;

/*
* developmentEmailAddress:
* **required
* when emailDevelopmentModeEnabled = true
* the 'to' in the <cfmail> tag is auto replaced with this address
* use something like 'no-reply@localhost'
*/

coldspringDefaults.developmentEmailAddress = 'no-reply@localhost';

/*
* managementConsoleGatewayName:
* **required
* the name of a DataServicesMessaging Event Gateway configured in the 
* ColdFusion Administrator that handles notifications once presentation uploads
* are completed.
* point the gateway at:
* \slidesix_os\services\eventGateways\managementConsole\ManagementConsoleGateway.cfc
*/

coldspringDefaults.managementConsoleGatewayName = 'ManagementConsoleGateway';

/*
* decicatedRoomGatewayName:
* **required
* the name of a DataServicesMessaging Event Gateway configured in the 
* ColdFusion Administrator that handles messaging/chat between the desktop AIR
* application and the Dedicated Room for live streaming presentations
* point the gateway at:
* \slidesix_os\services\eventGateways\dedicatedRoom\DedicatedRoomService.cfc 
*/

coldspringDefaults.decicatedRoomGatewayName = 'DedicatedRoomGateway';

/*
* pathToOpenOffice
* ** required
* the full path to the location of soffice.exe (Open Office)
* which is used for converting uploaded PowerPoint and Open Office 
* presentations.
* this path **must not** contain spaces so it's a good idea to do a 
* dir /x from the command line to get the 'short name' on windows
* which should give you something like:
*	"C:/Progra~2/OpenOf~1.org/program/soffice"
*/

coldspringDefaults.pathToOpenOffice = '';

/*
* path to red5 for video recording.  
* this may be depracated, so I won't say much about it for now
*/

coldspringDefaults.pathToMediaServerRecordings = 'C:/Red5/webapps/messageRecorder/streams';

/*
* should import errors be logged, and if so what 
* should the log be called (without .log extension)?
*/

coldspringDefaults.logSlideshowImportErrors = true;
coldspringDefaults.slideshowImportErrorsLogName = 'SlideshowImportErrors';

/*
* should media delete errors be logged, and if so what 
* should the log be called (without .log extension)?
*/

coldspringDefaults.logFileDeleteErrors = true;
coldspringDefaults.fileDeleteErrorsLogName = 'MediaDeleteErrors';

/*
* related to the AIR app - more on that later
*/
coldspringDefaults.presenterCurrentVersion = '1.0 (Beta 6)';
coldspringDefaults.presenterDownloadURL = '';

/*
* the following settings are related to OpenOffice and other
* presentation conversions and should probably not be
* changed unless you really know what you're doing
*/

coldspringDefaults.ooExtensions = 'ppt,odp,sxi'; //used to flag which uploads use OpenOffice for conversion (services.convert.oo.Convert) - pps get automatically renamed to ppt
coldspringDefaults.pdfExtension = 'pdf'; //used to tell the app which uploads use services.convert.pdf.Convert
coldspringDefaults.slideShowThumbWidth = '150';
coldspringDefaults.ooWidth = '1024';
coldspringDefaults.ooCompression = '100%';  //reducing this will reduce file size at the cost of image quality
coldspringDefaults.ooExportNotes = 1; //boolean
coldspringDefaults.ooExportFilter = 'impress_html_Export';
coldspringDefaults.ooJpgExportFilter = 'impress_jpg_Export';

/*
* what extensions are acceptable for presos & attachments? 
*/

coldspringDefaults.validPresentationUploadExtensions = 'ppt,pps,odp,sxi,pdf';
coldspringDefaults.validAttachmentUploadExtensions = 'zip';

/*
* is SOLR search enabled?  if so, what is the collection name
* (collection must be created in CF Admin
*/

coldspringDefaults.isSearchEnabled = true;
coldspringDefaults.searchCollectionName = 'slidesix_solr_collection';

/*
* related to importing presentations from slidesix
*/
coldspringDefaults.slidesixAPIKey = '';
</cfscript>

