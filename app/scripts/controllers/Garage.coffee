'use strict'

class GarageCtrl
	constructor: (GoogleMaps, MapCtrl) ->
			@position = new GoogleMaps.LatLng MapCtrl.getMap().getCenter()
			@draw()
	
	draw: ->
		@marker = new GoogleMaps.Marker
			map: MapService.getMap()
			position: @position


GarageCtrl.$inject = ['GoogleMaps', 'MapService']

angular.module('NetTalk.Controllers')
	.controller 'GarageCtrl', GarageCtrl


