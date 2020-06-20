pragma solidity >0.4.0;

contract DiceGame{
    
    //address of the house is kept inside the contract for future uses such as calling the User structure of house.
    //gasCost = 552
    address public house;//After this contract is deployed,this variable would be immutable.
    
    //Table for holding the User accounts regarding to their address.
    mapping(address=>User) UserTable;
    
    //struct of User which is for holding the specific information of the users.
    struct User{
        string username;
        uint age;
        uint balance;
        bool isExist;
    }

    //constructor which is called when the contract is deployed.Initializes the house as the sender of the contract.
    constructor() public payable{
        house = msg.sender;
        UserTable[house] = User("house",0,msg.value,true);

    }

    //function for adding users to dice game.Necessary to be called in order to play the games.
    //the User struct also contains a parameter for isExist which is for tracking whether a user exists or not.
    //gasCost = infinite due to unknown sized string (transactionCost(23866),executioCost(1378)) 
    function AddAccount(string memory username, uint age)public payable{
        //if user does not exists add it to the UserTable.
        if(UserTable[msg.sender].isExist==false)
            UserTable[msg.sender] = User(username,age,msg.value,true);
    }
    
    //function for giving money to the users account.
    //gasCost=20812
    function DepositMoney()public payable{
        //User must exist in UserTable in order to deposit money to dice game.
        require(UserTable[msg.sender].isExist ,"You don't own an account,please create an account first.");
        //Soon as the function is valled the value is sent to the account of contract.
        //The balance of the user is changed regarding to the value sent to the contract.
        UserTable[msg.sender].balance+=msg.value;
    }
    
    //function for taking money back to the user account.
    //gasCost = transactionCost(26067),executioCost(4667)
    function WithdrawMoney(uint value)public payable{
       
        //There are 2 requirements for the function to work properly.
        //User must exist in UserTable in order to withdraw money from the dice game.
        require(UserTable[msg.sender].isExist ,"You don't own an account,please create an account first.");
       
        //Users balance(balance hold in User struct,not the balance of the account.) must be bigger or equal to the value stated.
        require(UserTable[msg.sender].balance>=value,"Value stated is above your balance of account.");
       
        //If the requirements doesnt throw an exception for the call of the function then the users balance(User->balance) is changed.
        UserTable[msg.sender].balance-=value;
       
        //Since the user calls the function,the stated value is sent to user.
        msg.sender.transfer(value);
    }
    
    /*
    There are some security issues regarding to the RNG since smart contracts are public ,the users(players) can detect the 
    method which the RNG is used in the contract in order to estimate or calculate the result of RNG.One possible security
    measurement can be done via using oraclize,a tool which allows the users to access remote data outside of blockchain.
    */
    //gasCost = (transactionCost(21991),executioCost(719))
    function random() public payable returns (uint) {
        return (uint(keccak256(abi.encodePacked(now, msg.sender))) % 6) + 1;
    }

    //function for betting.User states the valueToBet in order to bet.
    //gasCost = dependent on the condition
    function Bet(uint valueToBet) public payable {
    
    //There are 3 rules in order to bet.
    
    //1.User must exist in the dice game.
    require(UserTable[msg.sender].isExist,"User must be signed to the system first.");
    
    //2.Users balance must be bigger or equals to the valueToBet since a user might try to bet a value bigger than balance.
    require(valueToBet<=UserTable[msg.sender].balance && valueToBet<=0.1 ether && valueToBet>=0);
    
    //3.House must also own money enough to make the bet possible
    //There can be a better implementation be done by adding a protocol for finding when the UserTable[house].balance
    //is exceeded and transfer money from the house address to the contract's balance.
    require(UserTable[house].balance>valueToBet,"House can not manage to make the bet due to lack of money.");
    
    //random number generator
    uint diceRolled = random();
    
    //check the generated number whether it is bigger than 4 or not
    if(diceRolled>4){
    
        //User wins which would end up adding the bet to users balance.
        UserTable[msg.sender].balance+=valueToBet;
    
        //House would loose the value bet.
        UserTable[house].balance-=valueToBet;
    }
    else{
    
        //User looses the bet,value is transfered from the users account.
        UserTable[msg.sender].balance-=valueToBet;
    
        //House wins which would end up adding the bet to the balance of the house.
        UserTable[house].balance+=valueToBet;
    }
  }
}