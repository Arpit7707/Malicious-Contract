//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "./Helper.sol";

contract Good {
    Helper helper;
    constructor(address _helper) payable {
        helper = Helper(_helper);
    }

    function isUserEligible() public view returns(bool) {
        return helper.isUserEligible(msg.sender);
    }

    function addUserToList() public  {
        helper.setUserEligible(msg.sender);
    }

    fallback() external {}

}

// You will notice that the fact about Malicious.sol is that it will generate the same ABI as Helper.sol even though it has different code 
//within it. This is because ABI only contains function definitions for public variables, functions and events. So Malicious.sol can be 
//typecasted as Helper.sol.

// Now because Malicious.sol can be typecasted as Helper.sol, a malicious owner can deploy Good.sol with the address of Malicious.sol 
//instead of Helper.sol and users will believe that he is indeed using Helper.sol to create the eligibility list.

// In our case, the scam will happen as follows. The scammer will first deploy Good.sol with the address of Malicious.sol. Then when the user 
//will enter the eligibility list using addUserToList function which will work fine because the code for this function is same within 
//Helper.sol and Malicious.sol.

// The true colours will be observed when the user will try to call isUserEligible with his address because now this function will always 
//return false because it calls Malicious.sol's isUserEligible function which always returns false except when its the owner itself, 
//which was not supposed to happen.