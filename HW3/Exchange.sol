pragma solidity ^0.5.0;

import "./OnurArdaBodur.sol";
import "./BodurOnurArda.sol";

contract Exchanger is OnurArdaBodur,BodurOnurArda{
    
    address owner;
    constructor()public{
        owner = msg.sender;
    }
    
    function transfer(address from_addrs,address to_addrs,uint256 amount)public{
        //call tokens
        //check for the balances
        require(owner==msg.sender,"Owner is only allowed to call this contract.");
        OnurArdaBodur ERC20InterfaceFrom = OnurArdaBodur(from_addrs);
        BodurOnurArda ERC20InterfaceTo = BodurOnurArda(to_addrs);
        require(ERC20InterfaceFrom.balanceOf(msg.sender)>amount,"Balance of the from address not holding");
        
        //burn the first token
        ERC20InterfaceFrom.burnFrom(msg.sender,amount);
        //mint the second token
        ERC20InterfaceTo.mint(msg.sender,amount);
    }
}
