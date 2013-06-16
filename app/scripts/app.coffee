'use strict'

#= require components/angular/angular.js
#= require controllers/main.ctrl.coffee
#= require channel.coffee
#= require position.coffee
#= require user.coffee


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
	.service

