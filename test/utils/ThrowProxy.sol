//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;


contract ThrowProxy {
    address public target;
    bytes data;

    constructor(address _target) {
        target = _target;
    }

    fallback() external {
    data = msg.data;
    }


    function execute() public returns (bool) {
        bool value;
        (value,) = target.call(data);

        return value;
    }

}




