'use strict'

class MapService
	constructor: (@GoogleMaps, @TWEEN) ->
		# Enable the visual refresh
		GoogleMaps.visualRefresh = true

		@directionService = new GoogleMaps.DirectionsService()
		@map = new GoogleMaps.Map(
			document.getElementById("map-canvas")
		,
			center: new GoogleMaps.LatLng 37.78317372823109, 237.5632660095215
			zoom: DEFAULT_ZOOM_LEVEL
			mapTypeId: GoogleMaps.MapTypeId.ROADMAP
		)

	on: (eventName, cb) ->
		@GoogleMaps.event.addListener @map, eventName, cb

	addToMap: (obj) ->
		@pinMarker obj.position

	animateMarker: (marker, toPosition) ->
		req =
			origin: marker.getPosition()
			destination: toPosition
			travelMode: @GoogleMaps.TravelMode.DRIVING

		@directionService.route req, (res, status) =>
			unless res?
				# Add the final tween to destination
				res.routes[0].overview_path.push req.destination
				tweenMarker.call @, marker, res, status

	pinMarker: (position) ->
		new @GoogleMaps.Marker
			map: @map
			position: position

	getMap: ->
		@map
			
MapService.$inject = ['GoogleMaps']


ANIMATION_DURATION_MILLIS = 1500
WAYPOINT_DISTANCE_THRESHOLD = 60
DEFAULT_ZOOM_LEVEL = 15

tweenMarker = (marker, res, status) ->
	return unless status is @GoogleMaps.DirectionsStatus.OK

	renderer = new @GoogleMaps.DirectionsRenderer
		directions: res
		map: @map
		suppressMarkers: true
		preserveViewport: true

	pos =
		lat: marker.getPosition().lat()
		lng: marker.getPosition().lng()
	tween = new @TWEEN.Tween pos

	curTween = tween
	prevWayPoint = marker.getPosition()

	path = res.routes[0].overview_path
	for wayPoint in path
		distanceToWayPoint = @GoogleMaps.geometry.spherical.computeDistanceBetween(
			prevWayPoint,
			wayPoint
		)
		continue if wayPoint != path[path.length - 1] && distanceToWayPoint < WAYPOINT_DISTANCE_THRESHOLD
		#			@pinMarker wayPoint
		duration = Math.min(
			1500,
			(Math.max(0, distanceToWayPoint) / 1500) * ANIMATION_DURATION_MILLIS
		)
		#console.log("distance to next wayPoint", distanceToWayPoint, duration)
		curTween.onUpdate =>
			#console.log("onUpdate chain", pos, @)
			marker.setPosition new @GoogleMaps.LatLng(pos.lat, pos.lng)

		tweenStep = new @TWEEN.Tween(pos).to(
			lat: wayPoint.lat()
			lng: wayPoint.lng()
		,
			duration
		)

		curTween.chain tweenStep
		curTween = tweenStep
		prevWayPoint = wayPoint

	tween.start()

angular.module('NetTalk.Services')
	.factory 'MapService', (GoogleMaps, TWEEN) ->
		new MapService GoogleMaps, TWEEN