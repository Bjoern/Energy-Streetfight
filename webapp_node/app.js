var _ = require('underscore')

var app = require('express').createServer()
var islands= require('./islands/IslandsSim.js')


var sim = new islands.IslandsSim(
    1000,//mapWidth,
    600,//mapHeight,
    100,//fogOfWarChunkSize,
    40,//numberOfIslands,
    10,//minIslandSize,
    50,//maxIslandSize,
    10,//numberOfProblemTypes,
    30,//numberOfProblemOccurances,
    2,//resourceTypesPerProblem,
    30,//numberOfShips,
    30,//playersPerWeek,
    false,//isMassStart,
    1,//shipCapacity,
    30//fractionOfExplorers
)

app.get('/', function(req, res){
  res.send('hello world');
});

app.get('/islands', function(req, res){
    //res.send(sim.islands)
})

app.get('/island/:id', function(req, res){

})

app.get('/ships', function(req, res) {

})

app.post('/ship/:id/vote', function(req, res){

    })



app.listen(3000);
