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
        scaleValue: '&'
        scaleProportion: '&'
    replace: true
    restrict: 'E'
    link: ($scope, $element, $attrs) ->
        sliding = false
        sliderWidth = null
        startMoveProportion = -1
        startX = -1

        getProportion = () ->
            value = parseFloatDefault $scope.value, 0
            minValue = parseFloatDefault $scope.minValue, 0
            maxValue = parseFloatDefault $scope.maxValue, 1

            if $attrs.scaleValue
                value = $scope.scaleValue({ value: value })
                minValue = $scope.scaleValue({ value: minValue })
                maxValue = $scope.scaleValue({ value: maxValue })

            proportion = (value - minValue) / (maxValue - minValue)

            return clamp proportion, 0, 1

        $scope.nibStyle = () ->
            return {
                marginLeft: "#{100 * getProportion()}%"
            }

        $scope.startSliding = (event) ->
            sliding = true
            startX = event.x
            sliderWidth = $element.prop('clientWidth')
            startMoveProportion = getProportion()

            $scope.slideStart()

        # Bind mouse events to the document
        $document = angular.element(document)

        $document
        .bind 'mousemove', (event) ->
            return if not sliding

            distance = event.x - startX

            newProportion = startMoveProportion + distance / sliderWidth
            newProportion = clamp newProportion, 0, 1

            minValue = parseFloatDefault $scope.minValue, 0
            maxValue = parseFloatDefault $scope.maxValue, 1

            if $attrs.scaleValue
                scaledMinValue = $scope.scaleValue({ value: minValue })
                scaledMaxValue = $scope.scaleValue({ value: maxValue })

            newValue = scaledMinValue + (scaledMaxValue - scaledMinValue) * newProportion
            if $attrs.scaleProportion
                newValue = $scope.scaleProportion({ proportion: newValue })
            newValue = clamp newValue, minValue, maxValue

            $scope.$apply () ->
                $scope.value = newValue
        .bind 'mouseup', () ->
            sliding = false
            $scope.$apply () ->
                $scope.slideStop()


  )
