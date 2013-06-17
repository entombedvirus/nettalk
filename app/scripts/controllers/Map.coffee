'use strict'

class MapCtrl
	DEFAULT_ZOOM_LEVEL = 15
	constructor: (GoogleMaps) ->
		# Enable the visual refresh
		GoogleMaps.visualRefresh = true

		@map = new GoogleMaps.Map(
			document.getElementById("map-canvas")
		,
			center: new @google.maps.LatLng 37.7789, -122.3917
			zoom: DEFAULT_ZOOM_LEVEL
			mapTypeId: GoogleMaps.MapTypeId.ROADMAP
		)

	getMap: ->
		@map
			
MapCtrl.$inject = ['GoogleMaps']

angular.module('NetTalk.Controllers')
	.controller 'MapCtrl', MapCtrl

