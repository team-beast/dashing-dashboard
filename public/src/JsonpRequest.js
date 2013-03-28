(function(){
	this.JsonpRequestFactory = function(){
		function create(uri){
			return new JsonpRequest({uri : uri});
		}

		return {
			create : create
		};
	}

	var JsonpRequest = function(options){	
		function send(){
			$.ajax({
				url : options.uri,
				dataType : 'JSONP'		
			});
		}

		return {
			send : send
		}
	};
})();