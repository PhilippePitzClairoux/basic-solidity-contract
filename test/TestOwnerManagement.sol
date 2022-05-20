// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;


import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/OwnerManagement.sol";
import "./utils/ThrowProxy.sol";

contract TestOwnerManagement {

    function testInitialOwners() public {
        OwnerManagement owners = new OwnerManagement();

        Assert.equal(owners.getOwners().length, 1, "Should only have 1 single owner");
    }

    function testAddOwner() public {
        OwnerManagement ownerContract = new OwnerManagement();

        ownerContract.addNewOwner(address(0xE31Ddd251DD512A4916f7A6F6Ef42bAdc37b6912));

        Assert.equal(ownerContract.getOwners().length, 2, "Should be 2 owners");
    }

    function testBigRedButton() public {
        OwnerManagement ownerContract = new OwnerManagement();
        ThrowProxy throwProxy = new ThrowProxy(address(ownerContract));

        ownerContract.bigRedButton();
        OwnerManagement(address(throwProxy)).getOwners();
        bool doesNotThrow = throwProxy.execute();

        Assert.equal(doesNotThrow, false, "Should throw an error if we call contract after destruction");
    }

}

