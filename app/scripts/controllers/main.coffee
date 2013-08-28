
angular.module('demoApp')
.controller('MainCtrl', ($scope) ->
	$scope.digits = 10
	$scope.min = 1
	$scope.max = 100

	$scope.log = (x) ->
		return Math.log(x)
	$scope.exp = (x) ->
		return Math.exp(x)
);
