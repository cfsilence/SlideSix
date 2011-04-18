component  implements="CFIDE.orm.IEventHandler"{

	public void function postLoad(any entity){
		
	}

	public void function preInsert(any entity){
		arguments.entity.setCreatedOn(now());
		arguments.entity.setUpdatedOn(now());
	}

	public void function postInsert(any entity){

	}

	public void function postUpdate(any entity){

	}

	public void function preLoad(any entity){

	}

	public void function preUpdate(any entity, Struct oldData){
		arguments.entity.setUpdatedOn(now());
	}

	public void function preDelete(any entity){

	}

	public void function postDelete(any entity){

	}

}