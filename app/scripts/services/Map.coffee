'use strict'

class MapService
	DEFAULT_ZOOM_LEVEL = 15
	constructor: (@GoogleMaps) ->
		# Enable the visual refresh
		GoogleMaps.visualRefresh = true

		@map = new GoogleMaps.Map(
			document.getElementById("map-canvas")
		,
			center: new GoogleMaps.LatLng 37.78317372823109, 237.5632660095215
			zoom: DEFAULT_ZOOM_LEVEL
			mapTypeId: GoogleMaps.MapTypeId.ROADMAP
		)

	on: (eventName, cb) ->
		@GoogleMaps.event.addListener @map, eventName, cb

	getMap: ->
		@map
			
MapService.$inject = ['GoogleMaps']

angular.module('NetTalk.Services')
	.factory 'MapService', (GoogleMaps) ->
		new MapService GoogleMaps