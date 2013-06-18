'use strict'

# Define the service and controller modules and their dependency to each other
services = angular.module('NetTalk.Services', [])
controllers = angular.module('NetTalk.Controllers', ['NetTalk.Services'])

app = angular.module 'NetTalk', [
	'NetTalk.Controllers'
	'NetTalk.Services'
]

app.config ['$routeProvider', ($routeProvider) ->
		$routeProvider.when '/', 
			templateUrl: 'views/partials/map.html'
			controller: 'MainCtrl'
		$routeProvider.otherwise
			redirectTo: '/'
	]

app
	.constant('google', google ? null)
	.constant('TWEEN', TWEEN ? null)
	.constant('GoogleMaps', google?.maps)