component hint="i am the remote SlideshowService" output="false"
{
	public function getComponent(){
		return application.factory.getBean('SlideshowService');
	}
	remote String function uploadAttachment(fileField,slideshowID){
		getComponent().checkSlideshowOwner(arguments.slideshowID);
		return getComponent().uploadAttachment(argumentCollection=arguments);
	}
	
	remote boolean function deleteAttachment(slideshowID){
		return getComponent().deleteAttachment(argumentCollection=arguments);
	}
	
	remote String function uploadSlideshow(fileField){
		return getComponent().uploadSlideshow(argumentCollection=arguments);
	}
	
	remote Array function convertSlideshow(String fileName){
		return getComponent().convertSlideshow(argumentCollection=arguments);
	}
	
	remote function saveSlideshowInfoAndConvert(fileName,id,data,createdByID,groupID){
		return getComponent().saveSlideshowInfoAndConvert(argumentCollection=arguments);
	}
	
	remote String function saveSlideshowInfo(id, data, groupID){
		getComponent().checkSlideshowOwner(arguments.id);
		return getComponent().saveSlideshowInfo(argumentCollection=arguments);
	}
	
	remote function saveSlideshow(target,noFlush){
		getComponent().checkSlideshowOwner(target.getID());
		return getComponent().saveSlideshow(argumentCollection=arguments);
	}
	
	private function readSlideshow(id){
		return  getComponent().readSlideshow(argumentCollection=arguments);
	}
	
	remote function deleteSlideshowByID(id,noFlush){
		getComponent().checkSlideshowOwner(arguments.id);
		return getComponent().deleteSlideshowByID(argumentCollection=arguments);
	}
	
	remote function listSlideshows(String whereClause, Array params){
		return getComponent().listSlideshows(argumentCollection=arguments);
	}
	
	remote function listUserSlideshowsAsQueryByUserID(userID){
		return  getComponent().listUserSlideshowsAsQueryByUserID(argumentCollection=arguments);
	}
	
	remote function getSlideshowByID(slideshowID){
		/*todo: need check for private slideshows*/
		return getComponent().getSlideshowByID(argumentCollection=arguments);
	}
	
	remote function listSlideshowsByUserID(userID){
		return getComponent().listSlideshowsByUserID(argumentCollection=arguments);
	}
	
	/*rankings*/
	
	remote function saveNewRanking(id, data){
		return getComponent().saveNewRanking(argumentCollection=arguments);
	}
	
	remote function saveRanking(target,noFlush){
		return getComponent().saveRanking(argumentCollection=arguments);
	}
	
	remote function listRankings(String whereClause, Array params){
		return getComponent().listRankings(argumentCollection=arguments);
	}
	
	/*comments*/
	
	remote function saveNewComment(id, data){
		return getComponent().saveNewComment(argumentCollection=arguments);
	}
	
	remote function saveComment(target,noFlush){
		return getComponent().saveComment(argumentCollection=arguments);
	}
	
	remote function deleteCommentByID(id,noFlush){
		var sID = getComponent().readComment(id).getSlideshow().getID();
		getComponent().checkSlideshowOwner(sID);
		return getComponent().deleteCommentByID(argumentCollection=arguments);
	}
	
	remote function listCommentsBySlideshowID(slideshowID){
		return getComponent().listCommentsBySlideshowID(argumentCollection=arguments);
	}
	
	remote function listComments(String whereClause, Array params){
		return getComponent().listComments(argumentCollection=arguments);	
	}
	
	/*views*/
	
	remote function saveNewView(data,slideshowID){
		return getComponent().saveNewView(argumentCollection=arguments);
	}
	
	remote function saveView(target,noFlush){
		return getComponent().saveView(argumentCollection=arguments);
	}

	remote function deleteViewByID(id,noFlush){
		return getComponent().deleteViewByID(argumentCollection=arguments);
	}
	
	remote function listViews(String whereClause, Array params){
		return getComponent().listViews(argumentCollection=arguments);
	}

	/*slides*/
	
	remote function saveNewSlide(id, data){
		return getComponent().saveNewSlide(argumentCollection=arguments);
	}
	
	remote function saveSlideInfo(id,data){
		return getComponent().saveSlideInfo(argumentCollection=arguments);
	}
	
	remote function saveSlide(target,noFlush){
		getComponent().checkSlideOwner(target.getID());
		return getComponent().saveSlide(argumentCollection=arguments);
	}
	
	private function readSlide(id){
		return getComponent().readSlide(argumentCollection=arguments);
	}
	
	remote function deleteSlideMediaBySlideID(id,noFlush){
		return getComponent().deleteSlideMediaBySlideID(argumentCollection=arguments);
	}
	
	remote function deleteSlideByID(id,noFlush){
		getComponent().checkSlideOwner(arguments.id);
		return getComponent().deleteSlideByID(argumentCollection=arguments);
	}
	
	remote function listSlides(String whereClause, Array params){
		return getComponent().listSlides(argumentCollection=arguments);
	}
	
	remote function listSlidesBySlideshowID(slideshowID){
		return getComponent().listSlidesBySlideshowID(argumentCollection=arguments);
	}
	
}