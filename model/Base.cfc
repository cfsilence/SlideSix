component mappedSuperClass="true" output="false"{
	property name="id" fieldtype="id" generator="identity";
	property name="createdOn" ormtype="timestamp" update="false" notnull="true";
	property name="updatedOn" ormtype="timestamp" notnull="true";
	
	public void function populate(Struct data){
		var meta = getMetaData(this);
		var props = meta.properties;
		for(var i = 1; i<=arrayLen(props); i++){
			var n = props[i].name;
			var v = '';
			var method = '';
			
			if(structKeyExists(arguments.data, n)){
				v = isSimpleValue(arguments.data[n]) ? trim(htmlEditFormat(arguments.data[n])) : arguments.data[n];
				method = this['set' & n];
				if(isNull(v) || (isSimpleValue(v) && !len(trim(v)))){
					method(javacast('null', ''));
				}	
				else{
					method(v);
				}
			}
		}
	}
	
}