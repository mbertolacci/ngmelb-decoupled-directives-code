'use strict'

describe 'Directive: slider', () ->
  beforeEach module 'demoApp'

  element = {}

  it 'should make hidden element visible', inject ($rootScope, $compile) ->
    element = angular.element '<slider></slider>'
    element = $compile(element) $rootScope
    expect(element.text()).toBe 'this is the slider directive'
