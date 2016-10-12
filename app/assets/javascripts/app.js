var app = angular.module('boardGame', ['ui.router', 'ngStorage']);

app.config(['$stateProvider', '$urlRouterProvider',function($stateProvider, $urlRouterProvider) {
    $urlRouterProvider.otherwise('/dashboard');
    $stateProvider.state('dashboard', {
        url: '/dashboard',
        templateUrl: '/assets/dashboard.html'
    });
    $stateProvider.state('dashboard.index', {
        url: '/index',
        templateUrl: '/assets/home.html'
    });
    $stateProvider.state('dashboard.newGame', {
        url: '/new_game',
        templateUrl: '/assets/new_game.html'
    });
    $stateProvider.state('dashboard.joinGame', {
        url: '/join_game',
        templateUrl: '/assets/join_game.html'
    });
}]);

app.service('websocketService', [function () {
    var websocketService = {};
    var dispatcher;
    var connect = function () {
        if (!dispatcher) {
            dispatcher = new WebSocketRails(window.location.host + "/websocket");
        }
        return dispatcher;
    };
    websocketService.connect = connect;
    return websocketService;
}]);

app.controller("gameCtrl", ["$scope", "websocketService", "$localStorage","$state","$interval", function($scope, websocketService, $localStorage, $state, $interval) {
    var dispatcher = websocketService.connect();
    
    $scope.newGame = {};
    $scope.game = {};
    $scope.game.playerName = {};
    $scope.game.playerNameRequired = false;
    dispatcher.on_open = function(data) {
        console.log("Hii there", data);
    };
    dispatcher.on_close =  function(data) {
        console.log("closed");
    };

    var setGameBlockTime = function(time) {
        if (time) {
            $localStorage.blockTime = time;
        }
        $scope.game.blockTime = $localStorage.blockTime;
    };

    var clearGameBlockTime = function() {
        $localStorage.blockTime = 0;
        $scope.game.blockTime = 0;
    };

    var setChannel = function(channel_name) {
        $localStorage.channel_name = channel_name;
        $scope.game.channel_name = channel_name;
    };

    var setGrid = function(grid) {
        if (grid) {
            $localStorage.grid = grid;
        }
        $scope.game.grid = $localStorage.grid;
    };

    var setPlayer = function(player) {
        if (!$localStorage.player) {
            $localStorage.player = player;
        }
        $scope.game.player = $localStorage.player;
    };

    var getGridDimensions = function(game_data) {
        var dimension_x = parseInt(game_data.dimension_x, 10);
        var dimension_y = parseInt(game_data.dimension_y, 10);
        var totalCells = dimension_x * dimension_y;
        return {x: dimension_x, y: dimension_y, total: totalCells};
    };

    var setCellWidth = function(width) {
        if (width) {
            $localStorage.cellWidth = width;
        }
        $scope.game.cellWidth = $localStorage.cellWidth;
    };

    var showGameGrid = function(status) {
        if (status) {
            $localStorage.showGame = true;
        }
        $scope.game.showGame = $localStorage.showGame;
    };

    var setActiveGame = function(game) {
        if (game) {
            $localStorage.activeGame = game;
        }
        $scope.game.activeGame = $localStorage.activeGame;
    };

    var setWinner = function(winner) {
        if (winner) {
            $localStorage.winner = winner;
        }
        $scope.game.winner = $localStorage.winner;
    };

    var clearWinner = function() {
        $localStorage.winner = "";
        $scope.game.winner = $localStorage.winner;
    };

    var setServerError = function(errorMessage) {
        $scope.game.errorMessage = errorMessage;
    };

    var clearServerError = function() {
        $scope.game.errorMessage = "";
    };

    var timer;
    $scope.game.gameBlocked = false;
    var blockGame = function(time) {
        if (angular.isDefined(timer)) return;
        timer = setInterval(function() {
            console.log('inside timer');
            $scope.game.gameBlocked = true;
            if ($scope.game.blockTime <= 0){
                clearInterval(timer);
                $scope.game.gameBlocked = false;
                $scope.game.blockTime = undefined;
            }
            else {
                $scope.game.blockTime--;
            }
            $scope.$apply();
        }, 1000);
    };

    var bindClient = function(channel_name) {
        $scope.game.channel = dispatcher.subscribe(channel_name);
        console.log('the $scope.game.channel is: ', $scope.game.channel);
        var persistentData = "";
        // $scope.div_width = $localStorage.div_width;
        // $scope.showGame = $localStorage.grid? true: false;
        // $scope.player = $localStorage.player;
        // $scope.ActiveGameId = $localStorage.game_id;
        // $scope.grid = $localStorage.grid;
        setCellWidth();
        setPlayer();
        setActiveGame();
        setGrid();
        showGameGrid();
        setWinner();
        $scope.game.channel.bind('move_info', function (data) {
            // $localStorage.grid = data.grid;
            // $scope.grid = $localStorage.grid;
            setGrid(data.grid);
            setPlayerStats(data.player_stats);
            console.log('game block time: ', $scope.game.blockTime);
            setGameBlockTime();
            blockGame($scope.game.blockTime);
            $scope.$apply();
        });
        // $scope.game.channel.bind('player_required', function(data) {
        //     setServerError(data.message);
        // });
        $scope.game.channel.bind('winner', function (data) {
            setWinner(data.winner);
            console.log('the winner is: ', data);
        });
        $scope.game.channel.bind('start_game', function (data) {
            console.log('starting game', data);
            if (data.status === 'failure') {
                setServerError(data.message);
                $scope.$apply();
            }
            else {
                clearServerError();
                if(data.winner) {
                    clearWinner();
                    setWinner(data.winner);
                }   
                clearGameBlockTime();
                setGameBlockTime(data.game_details.block_time);
                clearPlayerStats();
                setPlayerStats(data.player_stats);
                // 
                // $localStorage.player_color = data.player_details.color;
                // if (!$localStorage.player) {
                //     $localStorage.player = data.player_details
                // }
                // $localStorage.channel_name = data.game_details.channel_name;
                // $localStorage.game_id = data.game_details.id;
                // $localStorage.grid = data.grid;
                // console.log('the grid is: ', data.grid);
                // var dimension_x = parseInt(data.game_details.dimension_x, 10);
                // var dimension_y = parseInt(data.game_details.dimension_y, 10);
                // var total_square = dimension_x * dimension_y;
                // $localStorage.div_width = 12 / dimension_y;
                // console.log('the div_widht_is: ', $localStorage.div_width);
                // $scope.div_width = $localStorage.div_width;
                // $scope.showGame = $localStorage.game_status;
                // $scope.player = $localStorage.player;
                // $scope.ActiveGameId = $localStorage.game_id;
                setPlayer(data.player_details);
                setGrid(data.grid);
                var gridDimensions = getGridDimensions(data.game_details);
                var divWidth = parseInt((12 / gridDimensions.y), 10);
                setCellWidth(divWidth);
                // getCellCount(gridDimensions.total);
                // setCellCount(count);
                showGameGrid(true);
                setActiveGame(data.game_details);
                $scope.$apply();
                $state.go('dashboard.index');
            }
        });
    };

    var getPlayer = function() {
        return $localStorage.player;
    };

    var newGameSuccess = function (response) {
        setPlayer(response.player_details);
        console.log("New Game creation successful!", response);
        $scope.$apply();
        $state.go('dashboard.index');
    };
    var newGameFailure = function (response) {
        setServerError(response.message);
        $scope.$apply();
        console.log("New Game creation failure!", response);
    };

    $scope.createNewGame = function () {
        setChannel($scope.newGame.game_name);
        console.log('the $scope.game.channel is: ', $scope.newGame.game_name);
        bindClient($scope.game.channel_name);
        var blockTime = $scope.newGame.blockTime ? parseInt($scope.newGame.blockTime, 10) : 5 ;
        setGameBlockTime(blockTime);
        $scope.newGame.block_time = $scope.game.blockTime;
        if ($scope.playerPresent()) {
            $scope.newGame.player_name = getPlayer().name;
        }
        dispatcher.trigger('create_game', $scope.newGame, newGameSuccess, newGameFailure);
    };

    var listGameSuccess = function (response) {
        console.log("success!", response);
        $scope.game.currentGames = response.current_games;
        $scope.$apply();
        // $state.go('index.joinGame');
    };
    var listGameFailure = function (response) {
        console.log('failure from current game!');
    };

    $scope.listGames = function() {
        dispatcher.trigger('current_games', {}, listGameSuccess, listGameFailure);
    };


    var joinGameSuccess = function (response) {
        console.log('success join game!');
    };
    var joinGameFailure = function (response) {
        setServerError(response.message);
        console.log('Failure from joining game!');
    };

    $scope.joinGame = function (game) {
        console.log('the channel_name is: ', game.channel_name);
        console.log('the game is: ', game);
        setChannel(game.channel_name);  
        bindClient($scope.game.channel_name);
        var data = {
            game_id: game.id
        };
        if (!$localStorage.player && !$scope.game.playerName[game.id]) {
            $scope.game.playerNameRequired = true;
        }
        else {
            if($localStorage.player) {
                $scope.game.playerNameRequired = false;
                data.player_name = $localStorage.player.name;
            }
            else if ($scope.game.playerName[game.id]) {
                data.player_name = $scope.game.playerName[game.id];
            }
            dispatcher.trigger('join_game', data, joinGameSuccess, joinGameFailure);
            $state.go('dashboard.index');
        }
    };

    var setPlayerStats = function(stats) {
        if (stats) {
            $localStorage.playerStats = stats;
        }
        $scope.game.playerStats = $localStorage.playerStats;
        console.log('the player stats is: ', $scope.game.playerStats);
    };

    var clearPlayerStats = function() {
        $localStorage.playerStats = "";
        $scope.game.playerStats = "";
    };

    $scope.fillSquares = function () {
        $('.active').css({background: '#'+$localStorage.player.color});
    };
    $scope.emptySquares = function () {
        $('.active').css({background: 'white'});
    };
    var acquireSuccess = function (response) {
        // console.log('the respones is: ', response);
        // setGrid(response.grid);
        // setPlayerStats(response.player_stats);
        // $scope.$apply();
        console.log('success!');
    };
    var acquireFailure = function (response) {
        console.log('failure!');
    };
    $scope.acquireSquare = function (cell) {
        if (cell.occupied) return;
        console.log('the div index is: ', cell);
        var data = {
            player_id: $scope.game.player.id,
            cell_id: cell.id,
            game_id: $scope.game.activeGame.id
        };
        dispatcher.trigger('play', data, acquireSuccess, acquireFailure);
    };

    $scope.playerPresent = function() {
        player = getPlayer();
        console.log('the player is: ', player);
        if (player && player.name)
            return true;
        return false;
    };

    $scope.listGames();
}]);
