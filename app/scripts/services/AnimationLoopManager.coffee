'use strict'

angular.module('NetTalk.Services')
  .factory 'AnimationLoopManager', ($window, TWEEN) ->
		paused = false
		startTime = new Date()

		{
			animate: ->
				return if paused
				$window.requestAnimationFrame(animate);
				TWEEN.update()
			
			reset: ->
				paused = false
				startTime = new Date
		}
		
