var app = angular.module('app', ['ngRoute', 'ngResource']);

app.config(['$httpProvider', function($httpProvider) {
        $httpProvider.defaults.useXDomain = true;
        delete $httpProvider.defaults.headers.common['X-Requested-With'];
    }
]);


app.run(function($rootScope, $location, AuthService){
    $rootScope.$on("$routeChangeStart", function(event, next, current) {
		if(next.requireLogin && !AuthService.isUserAuthenticated()) {
			$location.path( "/login" );
			event.preventDefault();
		}
	});
});
