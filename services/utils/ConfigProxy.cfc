component displayname="ConfigProxy" hint="i give the application config to flex if it needs it"{
	remote function getConfig(){
		return application.factory.getBean('FlexConfig').getConfig();
	}			
}  