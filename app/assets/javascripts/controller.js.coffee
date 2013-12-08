app = angular.module('App', ['ngRoute']);

app.controller 'pettaiReportController', ($scope) ->
  $scope.barGraphData = [{key: "foo", value: 23}, {key: "boo", value: 34}, {key: "moo", value: 24}];
