pragma solidity ^0.8.0;

import "./OwnerManagement.sol";

//errors
error InsufficientBalance(uint256 available, uint256 required);
error BadRequest(string errorMessage);


contract EthTransferManagement is OwnerManagement {

    mapping (address => uint) private balance;

    event ReceivedFunds(address user, uint amount);
    event UserBailout(address user, uint amount);

    constructor(){}

    receive() external payable {
        if (msg.value < 0) {
            revert BadRequest(
                "Value is below 0..."
            );
        }

        balance[msg.sender] += msg.value;
        emit ReceivedFunds(msg.sender, msg.value);
    }

    function withdraw(uint _requestedAmount) external {
        if (_requestedAmount > balance[msg.sender]) {
            revert BadRequest(
                "You're trying to withdraw more coins than you own..."
            );
        }

        address(msg.sender).transfer(_requestedAmount);
        balance[msg.sender] -= _requestedAmount;
    }

    function userBailout() external {
        uint value = balance[msg.sender];
        require(value > 0);

        address(msg.sender).transfer(value);
        emit UserBailout(msg.sender, value);
    }

    function greedyBailout() external onlyCreator(msg.sender) {
        address _contract = address(this);
        address(_creator).transfer(_contract.balance);
    }

}
