// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.7.6;

contract Lottery {

    address public manager; // Admin de los sorteos
    address payable[] public players; // Jugadores que van a participar

    constructor() {
        manager = msg.sender;
    }

    // Función que permite a los jugadores participar en el sorteo.
    function enter() public payable {
        require(msg.value > .01 ether, "Send more than 0.01 Ether");

        players.push(msg.sender);
    }

    // Genera un número pseudo-random.
    function random() private view returns(uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players)));
    }

    // Función modifier que nos permite restringir a una función a la gente que no sea manager.
    modifier onlyOwner() {
        require(msg.sender == manager, "Only the manager can pick a winner"); 
        _;
    }

    // Función que elige al ganador del sorteo
    function pickWinner() public onlyOwner {
        uint index = random() % players.length;
        players[index].transfer(address(this).balance);
        players = new address payable[](0);
    }

    // Función la cual nos permite recoger los participantes del sorteo.
    function getPlayers() public view returns(address payable[] memory) {
        return players;
    }

}