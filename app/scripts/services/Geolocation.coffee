'use strict'

angular.module('NetTalk.Services', [])
	.factory 'Geolocation', ($window) ->
		$window.navigator.geolocation ? null
