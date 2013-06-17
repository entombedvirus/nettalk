'use strict'

describe 'Controller: GarageCtrl', () ->

  # load the controller's module
  beforeEach module 'NetTalkApp'

  GarageCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    GarageCtrl = $controller 'GarageCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', () ->
    expect(scope.awesomeThings.length).toBe 3;
