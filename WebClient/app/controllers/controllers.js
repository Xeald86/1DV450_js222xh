app.controller("homeController", function homeController($scope, AuthService, $rootScope) {
	$scope.authenticated = AuthService.isUserAuthenticated();
});

app.controller("menuController", function userController($scope, $route, $location) {
	
	$scope.mainMenu = null;

	$scope.$on('$routeChangeSuccess', function() {
		var path = $location.path();
		$scope.path = path;
	});
});


app.controller("authController", function authController($scope) {
});

app.controller("searchFormController", function searchFormController($scope, $location) {
	$scope.search = function(isValid) {
		if (isValid) {
			$location.path("/resources/search/"+$scope.searchword);
		}
	}
});


app.controller("loginFormController", function loginFormController($scope, $http, $location, APIService, AuthService) {

	$scope.tryUser = new APIService;
	$scope.errorMessage = null;
	var password = "";
	
	$scope.login = function(isValid) {
		if (isValid) {
			password = $scope.tryUser.password;
			$scope.APIResponse = null;
			this.tryUser.$save({source: 'userAuth'},
				function(successResult) {
					AuthService.setAuthentication($scope.tryUser.user, password, $http);
					$location.path( "/home" );
				},
				function(errorResult) {
					AuthService.removeAuthentication();
					$scope.tryUser.email = "";
					$scope.tryUser.password = "";
					$scope.errorMessage = "Authentication failed! Please check your email and password!";
				}
			);
		}
    }
});


app.controller("resourceFormController", function resourceFormController($scope, $location, $routeParams, APIService) {
	
	$scope.newResource = new APIService;
	$scope.newResource.tags = [];
	$scope.APIResponse = null;
	
	//Data from API
	$scope.APIContent = {
		licences: null,
		resourceTypes: null
	};
	
	$scope.APIContent.licences = APIService.query({source: 'licences'});
	$scope.APIContent.resourceTypes = APIService.query({source: 'resource_types'});
	
	
	//Add new tag (also adds to newResource-object)
	$scope.addTag = function() {
		tag = new APIService;
		tag.tagName = $scope.newTag;
		tag.$save({source: 'tags'},
		function(successResult) {
			if($routeParams.id != null)
				$scope.selected.tags.push({ id: successResult.tag.id, tag: successResult.tag.tag});
			else
				$scope.newResource.tags.push({ id: successResult.tag.id, tagName: successResult.tag.tag});
			
			$scope.APIResponse = null;
		},
		function(errorResult) {
			if(errorResult.status === 409) {
				if($routeParams.id != null)
					$scope.selected.tags.push({ id: errorResult.data.tag.id, tag: errorResult.data.tag.tag});
				else
					$scope.newResource.tags.push({ id: errorResult.data.tag.id, tagName: errorResult.data.tag.tag});
				
				$scope.APIResponse = null;
			}
			else if(errorResult.status === 404) {
					alert('No response from TOERH-API');
				}
			else {
				$scope.APIResponse = {
					message: errorResult.data.message,
					errors: errorResult.data.errors
				};
			}
		}
		);
		
		$scope.newTag = '';
	}
	
	
	//Update Resource
	$scope.updateResource = function() {
		$scope.APIResponse = null;
        $scope.selected.$update({id:$routeParams.id, source: 'resources'},
			function(successResult) {
				alert(successResult.message);
			},
			function(errorResult) {
				if(errorResult.status === 404) {
					alert('No response from TOERH-API');
				}
				else {
					$scope.APIResponse = {
						message: errorResult.data.message,
						errors: errorResult.data.errors
					};
				}
			}
		);
	}
	
	//Create new resource
	$scope.createResource = function(isValid) {
		if (isValid) {
			$scope.APIResponse = null;
			this.newResource.$save({source: 'resources'},
				function(successResult) {
					alert(successResult.message);
				},
				function(errorResult) {
					if(errorResult.status === 404) {
						alert('No response from TOERH-API');
					}
					else {
						$scope.APIResponse = {
							message: errorResult.data.message,
							errors: errorResult.data.errors
						};
					}
				}
			);
		}
    }
});

app.controller("resourceController", function resourceController($scope, $routeParams, $resource, $location, APIService, AuthService) {

	$scope.response = null;
	$scope.selected = null;
	$scope.resources = null;
	$scope.page = 1;
	$scope.totalPages = 1;
	$scope.authed = null;

	
	//getResources
	$scope.getResources = function (page) {
		$scope.page = page;
		var limit = 10;
		var offset = (page * limit) - 10;
		
		$scope.response = APIService.query({source: 'resources', limit: limit, offset: offset}, function(){
			$scope.resources = $scope.response.items;
			$scope.totalPages = Math.ceil($scope.response.count / 10);
		});
	}
	
	// Check if Show or Index of resource
	if($routeParams.id != null)
		$scope.selected = APIService.get({id:$routeParams.id, source: 'resources'},
		function() {
			$scope.authed = AuthService.isUser($scope.selected.user_id);
		});
	else {
		$scope.getResources(1);
	}
	
	//Delete Resource
	$scope.deleteResource = function (resourceID) {
		 APIService.delete({id:resourceID, source: 'resources'}, function() {
			alert('The resource has been deleted');
			$location.path("/resources");
		},
		function() {
			alert('The resource could not be deleted');
		});
	}

});


app.controller("searchController", function searchController($scope, $routeParams, $resource, $location, APIService) {

	$scope.response = null;
	$scope.selected = null;
	$scope.resources = null;
	$scope.searchword = $routeParams.searchword;
	$scope.page = 1;
	$scope.totalPages = 1;

	
	//getResources
	$scope.getResources = function (page) {
		$scope.page = page;
		var limit = 10;
		var offset = (page * limit) - 10;
		
		$scope.response = APIService.query({source: 'search', search: $scope.searchword, limit: limit, offset: offset}, function(){
			$scope.resources = $scope.response.items;
			$scope.totalPages = Math.ceil($scope.response.count / 10);
		});
	}

	$scope.getResources(1);
});


app.controller("licenceController", function licenceController($scope, $routeParams, $resource, APIService) {

	$scope.response = null;

	// Check if Show or Index
	if($routeParams.id != null) {
		$scope.selected = APIService.get({id:$routeParams.id, source: 'licences'},
			function() {
				$scope.response = APIService.query({id:$routeParams.id, source: 'licences', subsource: 'resources'}, function() {
					$scope.resources = $scope.response.items;
				});
			}
		);
		
	}
	else {
		$scope.response = APIService.query({source: 'licences'}, function() {
			$scope.licences = $scope.response.items;
		});
		
	}

});


app.controller("typeController", function typeController($scope, $routeParams, $resource, APIService) {

	$scope.response = null;

	// Check if Show or Index
	if($routeParams.id != null) {
		$scope.selected = APIService.get({id:$routeParams.id, source: 'resource_types'},
			function() {
				$scope.response = APIService.query({id:$routeParams.id, source: 'resource_types', subsource: 'resources'}, function() {
					$scope.resources = $scope.response.items;
				});
			}
		);
		
	}
	else {
		$scope.response = APIService.query({source: 'resource_types'}, function() {
			$scope.types = $scope.response.items;
		});
	}

});


app.controller("userController", function userController($scope, $routeParams, $resource, APIService) {

	$scope.response = null;

	// Check if Show or Index
	if($routeParams.id != null) {
		$scope.selected = APIService.get({id:$routeParams.id, source: 'users'},
			function() {
				$scope.response = APIService.query({id:$routeParams.id, source: 'users', subsource: 'resources'}, function() {
					$scope.resources = $scope.response.items;
				});
			});
	}
	else {
		$scope.response = APIService.query({source: 'users'}, function() {
		$scope.users = $scope.response.items;
		});
	}

});


app.controller("tagController", function tagController($scope, $routeParams, $resource, APIService) {

	$scope.response = null;
	$scope.page = 1;
	$scope.totalPages = 1;
	
	//getResources
	$scope.getResources = function (page) {
		$scope.page = page;
		var limit = 10;
		var offset = (page * limit) - 10;
		
		$scope.selected = APIService.get({id:$routeParams.id, source: 'tags'},
			function() {
				$scope.response = APIService.query({id:$routeParams.id, source: 'tags', subsource: 'resources', limit: limit, offset: offset}, function() {
					$scope.resources = $scope.response.items;
					$scope.totalPages = Math.ceil($scope.response.count / 10);
				});
			}
		);
	}
	
	
	//getResources
	$scope.getTags = function (page) {
		$scope.page = page;
		var limit = 20;
		var offset = (page * limit) - 20;
		
		$scope.response = APIService.query({source: 'tags', limit: limit, offset: offset}, function() {
			$scope.tags = $scope.response.items;
			$scope.totalPages = Math.ceil($scope.response.count / 20);
		});
	}
	
	// Check if Show or Index
	if($routeParams.id != null) {
		$scope.getResources(1);
	}
	else {
		$scope.getTags(1);
	}

});