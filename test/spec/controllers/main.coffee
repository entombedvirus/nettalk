"use strict"
describe "Controller: MainCtrl", ->
  
  MainCtrl = undefined
  google = undefined
  Geolocation = undefined
  scope = undefined
  
  # load the controller's module
  beforeEach module("NetTalk.Controllers")

  # Initialize the controller and a mock scope
  beforeEach inject(($controller, $rootScope) ->
    scope = $rootScope.$new()
    google = maps: jasmine.createSpyObj("maps", ["LatLng", "MapTypeId", "Map", "Marker", "Circle"])
    Geolocation = jasmine.createSpyObj("Geolocation", ["getCurrentPosition"])
    MainCtrl = $controller("MainCtrl",
      $scope: scope
      google: google
      Geolocation: Geolocation
    )
  )

  it "should use Google Maps visual refresh mode", ->
    expect(google.maps.visualRefresh).toBe true

  it "should use Geolocaltion.getCurrentPosition", ->
    expect(Geolocation.getCurrentPosition).toHaveBeenCalled()
