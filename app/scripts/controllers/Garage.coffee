'use strict'

class GarageCtrl
	constructor: (GoogleMaps, MapCtrl) ->
			@position = new GoogleMaps.LatLng MapCtrl.getMap().getCenter()
			@draw()
	
	draw: ->
		@marker = new GoogleMaps.Marker
			map: MapCtrl.getMap()
			position: @position


GarageCtrl.$inject = ['GoogleMaps', MapCtrl]

angular.module('NetTalk.Controllers')
	.controller 'GarageCtrl', GarageCtrl


