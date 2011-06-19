/*
 * author: Bjoern Guenzel guenzel@blinker.net
 */


function EnergyIslands(map, islands, startPositions) {
    this.init(map, islands, startPositions);
}	    

EnergyIslands.PROBLEMS = [
    {"Dürre": ["Wasser", "Hydroingenieur"]},
    {"Waldbrand": ["Feuerwehr", "Sägen"]},
    {"Bildungsmangel":["Bücher", "Lehrer"]},
    {"Hunger": ["Reis", "Bauer"]}
];

EnergyIslands.prototype = {
    init: function(map, islands, startPositions) {
	this.map = map
	this.islands = islands

	this.ships = _.map(startPositions, this.initShip, this);
    },

    initShip: function(position) {
	return {
	    position: position,
	    cargo: null,
	    direction: "N",
	    speed: 0
	}
    },
}


