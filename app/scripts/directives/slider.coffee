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
                 ng-style="nibStyle()"
                 ng-mousedown="startSliding($event)">
            </div>
        </div>
    """
    scope:
        value: '=ngModel'
        minValue: '@'
        maxValue: '@'
        slideStart: '&'
        slideStop: '&'
    replace: true
    restrict: 'E'
    link: ($scope, $element, $attrs) ->
        sliding = false
        sliderWidth = null
        startMoveValue = -1
        startX = -1

        $scope.nibStyle = () ->
            value = parseFloatDefault $scope.value, 0
            minValue = parseFloatDefault $scope.minValue, 0
            maxValue = parseFloatDefault $scope.maxValue, 1

            proportion = clamp (value - minValue) / (maxValue - minValue), 0, 1

            return {
                marginLeft: "#{100 * proportion}%"
            }

        $scope.startSliding = (event) ->
            sliding = true
            startX = event.x
            sliderWidth = $element.prop('clientWidth')
            startMoveValue = parseFloatDefault $scope.value, 0

            $scope.slideStart()

        # Bind mouse events to the document
        $document = angular.element(document)

        $document
        .bind 'mousemove', (event) ->
            return if not sliding

            distance = event.x - startX

            minValue = parseFloatDefault $scope.minValue, 0
            maxValue = parseFloatDefault $scope.maxValue, 1

            newValue = startMoveValue + (distance / sliderWidth) * (maxValue - minValue)
            newValue = clamp newValue, minValue, maxValue

            $scope.$apply () ->
                $scope.value = newValue
        .bind 'mouseup', () ->
            sliding = false
            $scope.$apply () ->
                $scope.slideStop()


  )
