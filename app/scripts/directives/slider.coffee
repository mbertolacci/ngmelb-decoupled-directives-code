'use strict';

angular.module('demoApp')
  .directive('slider', () ->
    template: """
        <div class="slider">
            <div class="nib"></div>
        </div>
    """
    scope:
        value: '=ngModel'
    replace: true
    restrict: 'E'
    link: ($scope, $element, $attrs) ->
        return
  )
