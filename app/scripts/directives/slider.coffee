'use strict';

clamp = (value, min, max) ->
    return Math.max min, (Math.min max, value)

parseFloatDefault = (value, defaultValue) ->
    value = parseFloat value
    if isNaN(value)
        value = defaultValue
    return value

angular.module('demoApp')
  .directive('slider', () ->
    template: """
        <div class="slider">
            <div class="nib"
                 ng-style="nibStyle()">
            </div>
        </div>
    """
    scope:
        value: '=ngModel'
    replace: true
    restrict: 'E'
    link: ($scope, $element, $attrs) ->
        $scope.nibStyle = () ->
            value = parseFloatDefault $scope.value, 0
            
            proportion = clamp(value, 0, 1)
            return {
                marginLeft: "#{100 * proportion}%"
            }
  )
