pragma solidity ^0.5.0;

import 'ERC20.sol';
import 'ERC20Detailed.sol';
import 'ERC20Burnable.sol';
import 'ERC20Mintable.sol';

contract OnurArdaBodur is ERC20, ERC20Detailed, ERC20Burnable, ERC20Mintable{
    constructor()public{
        ERC20Mintable.initialize(msg.sender);
        ERC20Detailed.initialize("[Onur Arda Bodur]","OAB",1);
    }
}
