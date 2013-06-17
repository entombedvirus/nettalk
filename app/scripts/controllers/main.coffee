class MainCtrl
	ANIMATION_DURATION_MILLIS = 1500
	WAYPOINT_DISTANCE_THRESHOLD = 190

	constructor: (@GoogleMaps, MapsCtrl, @TWEEN, AnimationLoopManager) ->
		console.log("animation loop manager", AnimationLoopManager)
		AnimationLoopManager.reset()
		@map = MapsCtrl.getMap()
		@directionService = new GoogleMaps.DirectionsService()
		@centerMarker = @pinMarker @map.getCenter()
		@bindEvents()

	bindEvents: ->
		@GoogleMaps.event.addListener @map, "rightclick", (e) =>
			e.stop()
			marker = @pinMarker e.latLng
			@getDirectionsFromTo marker, @centerMarker, (res, status) =>
				@animateMarker marker, res, status

	pinMarker: (position, animation) ->
		new @GoogleMaps.Marker
			map: @map
			position: position
	
	getDirectionsFromTo: (fromMarker, toMarker, cb) ->
		req =
			origin: fromMarker.getPosition()
			destination: toMarker.getPosition()
			travelMode: @GoogleMaps.TravelMode.DRIVING

		@directionService.route req, cb
		
	animateMarker: (marker, res, status) =>
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

		for wayPoint in res.routes[0].overview_path
			distanceToWayPoint = @GoogleMaps.geometry.spherical.computeDistanceBetween(
				prevWayPoint,
				wayPoint
			)
			continue unless distanceToWayPoint > WAYPOINT_DISTANCE_THRESHOLD
			@pinMarker wayPoint
			duration = Math.min(
				1500,
				(Math.max(0, distanceToWayPoint) / 1500) * ANIMATION_DURATION_MILLIS
			)
			#console.log("distance to next wayPoint", distanceToWayPoint, duration)
			curTween.onUpdate ->
				#console.log("onUpdate chain", pos, @)
				fromMarker.setPosition new maps.LatLng(@lat, @lng)

			tweenStep = new @TWEEN.Tween(pos).to
				lat: wayPoint.lat()
				lng: wayPoint.lng()
			,
				duration

			curTween.chain tweenStep
			curTween = tweenStep
			prevWayPoint = wayPoint

		tween.start()

angular.module('NetTalk.Controllers')
	.controller 'MainCtrl', [
		'GoogleMaps', 'MapsCtrl', 'TWEEN', 'AnimationLoopManager', MainCtrl
	]
