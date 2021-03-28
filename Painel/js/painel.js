	angular.module("painel",[]);
	angular.module("painel").controller("myCtrl", function ($scope) {
		//$scope.IP = "127.0.0.1";
		$scope.IP = getIPs();

	});