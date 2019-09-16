var app = angular.module('painel', ['io.service']);
 app.run(function (io) {
        io.init({
            ioServer: 'http://localhost:3000',
            apiServer: 'http://localhost:8080/api',
            ioEvent: 'io.response'
        });
    });
app.controller('myCtrl', function($scope) {
	
  //this.IP = getIp(this.IP);
  this.IP = '127.0.0.1';
  
      $scope.$watch('question', function (newValue, oldValue) {
            if (newValue != oldValue) {
                io.emit({item: 'question', newValue: newValue, oldValue: oldValue});
            }
        });
 
        io.watch('answer', function (data) {
            $scope.answer = data.value;
            $scope.$apply();
        });

  
});