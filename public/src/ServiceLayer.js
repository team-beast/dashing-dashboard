(function(){
	this.ServiceLayer = function(jsonpRequestFactory){
		var SERVICE_URI = "http://teambeastservices.herokuapp.com/pipelines",
			jsonpRequest = jsonpRequestFactory.create(SERVICE_URI);
		function wakeUp(){
			jsonpRequest.send();
		}
		return{
			wakeUp : wakeUp
		};
	};
})();
