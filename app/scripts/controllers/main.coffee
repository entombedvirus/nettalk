class MainCtrl
	NUM_CARS = 3

	constructor: (@GoogleMaps, @mapService, @TWEEN, AnimationLoopManager, @carFactory) ->
		AnimationLoopManager.reset()
		@map = mapService.getMap()
		@centerMarker = mapService.pinMarker @map.getCenter()

#		newCar = carFactory.generate()
#		mapService.addToMap newCar
#		mapService.animateMarker newCar, @centerMarker

		@bindEvents()

	bindEvents: ->
		@mapService.on "rightclick", (e) =>
			e.stop()
			newCar = @carFactory.generate()
			newCar.setPosition e.latLng
			dispObj = @mapService.addToMap newCar
#			@mapService.animateMarker dispObj, @centerMarker.getPosition()


MainCtrl.$inject = [
	'GoogleMaps', 'MapService', 'TWEEN', 'AnimationLoopManager', 'CarFactory'
]
angular.module('NetTalk.Controllers')
	.controller 'MainCtrl', MainCtrl
