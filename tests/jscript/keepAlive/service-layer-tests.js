(function(){
	module("Service layer tests");
	test("When woken up, Then jsonp request created with services uri", function(){
		var receivedUri = "",
			servicesUri = "http://teambeastservices.herokuapp.com/pipelines",
			mockjsonpRequestFactory = {
				create : function(uri){
					receivedUri = uri
					return {
						send : function(){}
					};
				}
			};
		new ServiceLayer(mockjsonpRequestFactory).wakeUp();
		equal(servicesUri, receivedUri);
	});	

	test("When woken up, Then jsonp request sent", function(){
		var jsonpRequestSent = false,
			mockJsonpRequest = {
				send : function(){
					jsonpRequestSent = true;
				}
			},
			fakeJsonpRequestFactory = {
				create : function(){
					return mockJsonpRequest;
				}
			};
		new ServiceLayer(fakeJsonpRequestFactory).wakeUp();
		equal(jsonpRequestSent, true);
	});

	test("When not woken up, Then jsonp request not sent", function(){
		var jsonpRequestSent = false,
			mockJsonpRequest = {
				send : function(){
					jsonpRequestSent = true;
				}
			},
			fakeJsonpRequestFactory = {
				create : function(){
					return mockJsonpRequest;
				}
			};
		new ServiceLayer(fakeJsonpRequestFactory);
		equal(jsonpRequestSent, false);
	});
})();

(function(){
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