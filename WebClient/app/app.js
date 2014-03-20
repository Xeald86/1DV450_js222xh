
app.service('AuthService', function(){
    var Authenticated = false;
	var AuthUser = {
		email: "",
		password: "",
		id: null
	};

    this.setAuthentication = function(user, password, $http){
        AuthUser.email = user.email;
		AuthUser.id = user.id;
		Authenticated = true;
		this.setHeaderAuth(password, $http);
    };
	
	this.removeAuthentication = function(){
        Authenticated = false;
    };
	
	this.setHeaderAuth = function(password, $http) {
		$http.defaults.headers.common["x-email"] = AuthUser.email;
		$http.defaults.headers.common["x-password"] = password;
	}

    this.isUserAuthenticated = function(){
        return Authenticated;
    };
	
	this.isUser = function(userID){
        return (AuthUser.id == userID);
    };
});

app.directive("resourceShow", function() {
	return {
		restrict: 'E',
		scope: {
			resource: '='
		},
		templateUrl: "app/templates/resources/resource_preview.html",
		controller: function($scope) {
			
		}
	};
});

// APIService
app.factory("APIService", function ($resource, $http) {
	$http.defaults.headers.common["Content-Type"] = "application/json";
	
	var APIService = $resource(
        'http://js222xh-rails-76335.euw1.nitrousbox.com/:source/:id/:subsource',
        { key: "f9484d8959d53a49947238af8af01108" },
		{
			get: {
				method: 'get',
				params: {id: "@id" },
				isArray: false
			},
			query: {
				method: 'get',
				isArray: false
			},
			save: {
				method: 'POST'
			},
			update: { 
				method: 'PUT', 
				params: {id: "@id" }
			},
			delete: { method: 'DELETE', params: {id: '@id'} }
		}
    );
	
	return APIService;
});

//Preview-filter
app.filter('preview', function(limitToFilter) {
	return function(input, i) {
		if (input.length > i)
			return limitToFilter(input, i-3) + "...";
		else
			return input;
	};
});
