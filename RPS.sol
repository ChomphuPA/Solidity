// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./CommitReveal.sol";
import "./TimeUnit.sol";

contract RPS {

    TimeUnit public timeUnit = new TimeUnit();
    CommitReveal public commitReveal = new CommitReveal();

    
    constructor () {
        timeUnit.setStartTime();
    }

    uint public numPlayer = 0; 
    uint public reward = 0;
    mapping (address => uint) private  player_choice; 
    mapping(address => bool) public player_not_played;

    address[] public players;

    uint public numInput = 0;

    address[4] private Allow_Players = [
        0x5B38Da6a701c568545dCfcB03FcB875f56beddC4,
        0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2,
        0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db,
        0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB
    ];


    function addPlayer() public payable {
        require(numPlayer < 2);
        if (numPlayer > 0) {
            require(msg.sender != players[0]);
        }
        require(msg.value == 1 ether);
        reward += msg.value;
        player_not_played[msg.sender] = true;
        players.push(msg.sender);
        numPlayer++;
    }

    function input(uint choice) public  {
        require(numPlayer == 2);
        require(player_not_played[msg.sender]);
        require(choice == 0 || choice == 1 || choice == 2 || choice == 3 || choice == 4  );
        player_choice[msg.sender] = choice;
        player_not_played[msg.sender] = false;
        numInput++;
        if (numInput == 2) {
            _checkWinnerAndPay();
        }
    }

    function _checkWinnerAndPay() private {
        uint p0Choice = player_choice[players[0]];
        uint p1Choice = player_choice[players[1]];
        address payable account0 = payable(players[0]);
        address payable account1 = payable(players[1]);


        if (
            (p0Choice == 0 && (p1Choice == 1 || p1Choice == 4)) || // Rock แพ้ Paper, Spock
            (p0Choice == 1 && (p1Choice == 2 || p1Choice == 3)) || // Paper แพ้ Scissors, Lizard
            (p0Choice == 2 && (p1Choice == 0 || p1Choice == 4)) || // Scissors แพ้ Rock, Spock
            (p0Choice == 3 && (p1Choice == 0 || p1Choice == 2)) || // Lizard แพ้ Rock, Scissors
            (p0Choice == 4 && (p1Choice == 1 || p1Choice == 3))    // Spock แพ้ Paper, Lizard  
        ){
            account1.transfer(reward);
        }
    


       /* if ((p0Choice + 1) % 3 == p1Choice) {
            // to pay player[1]
            //account1.transfer(reward);
        }*/
        else if ( (p1Choice == 0 && (p0Choice == 1 || p0Choice == 4)) || // Rock แพ้ Paper, Spock
            (p1Choice == 1 && (p0Choice == 2 || p0Choice == 3)) || // Paper แพ้ Scissors, Lizard
            (p1Choice == 2 && (p0Choice == 0 || p1Choice == 4)) || // Scissors แพ้ Rock, Spock
            (p1Choice == 3 && (p0Choice == 0 || p0Choice == 2)) || // Lizard แพ้ Rock, Scissors
            (p1Choice == 4 && (p0Choice == 1 || p0Choice == 3)) )   // Spock แพ้ Paper, Lizard  ) 
         {   // to pay player[0]
            account0.transfer(reward);    
        }
        else {
            // to split reward
            account0.transfer(reward / 2);
            account1.transfer(reward / 2);
        }
    }

    function EndGame() public{

        require(numPlayer == 2);
        require(player_not_played[msg.sender] == false);
        require(timeUnit.elapsedSeconds() > 7200);

        if (timeUnit.elapsedSeconds() > 7200) {
            payable(msg.sender).transfer(reward);
        }
        numPlayer = 0;
        reward = 0;
        numInput = 0;
        delete players;



    }





}
