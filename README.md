# Solidity
# อธิบายโค้ดที่ป้องกันการ lock เงินไว้ใน contract
 if (timeUnit.elapsedSeconds() > 7200) {
    payable(msg.sender).transfer(reward);
 }
 ถ้าผู้เล่นอีกฝ่ายไม่ทำการเลือกภายใน 30 นาที ผู้เล่นที่เลือกจะได้เงิน

#อธิบายโค้ดส่วนที่ทำการซ่อน choice และ commit
 mapping (address => uint) private  player_choice; 
 เปลี่ยนจาก public player_choice เป็น private

# อธิบายโค้ดส่วนที่จัดการกับความล่าช้าที่ผู้เล่นไม่ครบทั้งสองคนเสียที
 function EndGame() public{

        require(numPlayer == 2);
        require(player_not_played[msg.sender] == false);
        require(timeUnit.elapsedSeconds() > 1800);

        if (timeUnit.elapsedSeconds() > 1800) {
            payable(msg.sender).transfer(reward);
        }
        numPlayer = 0;
        reward = 0;
        numInput = 0;
        delete players;

    }
    ถ้าผู้เล่นใดผู้เล่นไม่เลือกภายใน 30 นาที ฝ่ายที่เลือกจะได้รับเงินแล้วรีเซ็ตเกมใหม่

   # อธิบายโค้ดส่วนทำการ reveal และนำ choice มาตัดสินผู้ชนะ 
    function _checkWinnerAndPay() private {
        uint p0Choice = player_choice[players[0]];
        uint p1Choice = player_choice[players[1]];
        address payable account0 = payable(players[0]);
        address payable account1 = payable(players[1]);


        if (   ตั้งว่าถ้า p0เลือกออะไรมา p1 ต้องเลือกอะไร
            (p0Choice == 0 && (p1Choice == 1 || p1Choice == 4)) || // Rock แพ้ Paper, Spock
            (p0Choice == 1 && (p1Choice == 2 || p1Choice == 3)) || // Paper แพ้ Scissors, Lizard
            (p0Choice == 2 && (p1Choice == 0 || p1Choice == 4)) || // Scissors แพ้ Rock, Spock
            (p0Choice == 3 && (p1Choice == 0 || p1Choice == 2)) || // Lizard แพ้ Rock, Scissors
            (p0Choice == 4 && (p1Choice == 1 || p1Choice == 3))    // Spock แพ้ Paper, Lizard  
        ){
            account1.transfer(reward);
        }
          ตั้งว่าถ้า p1 เลือกออะไรมา p0 ต้องเลือกอะไร
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
