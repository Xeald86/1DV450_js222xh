app.config(
	function ($routeProvider) {
		$routeProvider.when('/home', {
			controller: 'homeController',
			templateUrl: 'app/partials/home.html',
			requireLogin: false
		})
		.when('/licences', {
			controller: 'licenceController',
			templateUrl: 'app/partials/licences/index.html',
			requireLogin: false
		})
		.when('/licences/:id', {
			controller: 'licenceController',
			templateUrl: 'app/partials/licences/show.html',
			requireLogin: false
		})
		.when('/types', {
			controller: 'typeController',
			templateUrl: 'app/partials/types/index.html',
			requireLogin: false
		})
		.when('/types/:id', {
			controller: 'typeController',
			templateUrl: 'app/partials/types/show.html',
			requireLogin: false
		})
		.when('/users', {
			controller: 'userController',
			templateUrl: 'app/partials/users/index.html',
			requireLogin: false
		})
		.when('/users/:id', {
			controller: 'userController',
			templateUrl: 'app/partials/users/show.html',
			requireLogin: false
		})
		.when('/tags', {
			controller: 'tagController',
			templateUrl: 'app/partials/tags/index.html',
			requireLogin: false
		})
		.when('/tags/:id', {
			controller: 'tagController',
			templateUrl: 'app/partials/tags/show.html',
			requireLogin: false
		})
		.when('/resources/all', {
			controller: 'resourceController',
			templateUrl: 'app/partials/resources/index.html',
			requireLogin: false
		})
		.when('/resources', {
			controller: 'resourceController',
			templateUrl: 'app/partials/resources/index.html',
			requireLogin: false
		})
		.when('/resources/search/:searchword', {
			controller: 'searchController',
			templateUrl: 'app/partials/resources/search.html',
			requireLogin: false
		})
		.when('/resources/edit/:id', {
			controller: 'resourceController',
			templateUrl: 'app/partials/resources/edit.html',
			requireLogin: true
		})
		.when('/resources/show/:id', {
			controller: 'resourceController',
			templateUrl: 'app/partials/resources/show.html',
			requireLogin: false
		})
		.when('/resources/create', {
			controller: 'resourceController',
			templateUrl: 'app/partials/resources/create.html',
			requireLogin: true
		})
		.when('/404', {
			controller: 'homeController',
			templateUrl: 'app/partials/404.html',
			requireLogin: false
		})
		.when('/login', {
			controller: 'authController',
			templateUrl: 'app/partials/login.html',
			requireLogin: false
		})
		.otherwise({redirectTo: '/404'});
	}
);