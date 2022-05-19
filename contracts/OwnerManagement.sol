// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.4.22 <0.9.0;

contract OwnerManagement {
    address[] private _owners;
    address payable private creator;

    //Owner Events

    event OwnerAdded(
        address indexed newOwner
    );

    event OwnerRemoved(
        address indexed removedOwner
    );

    //Owner Modifiers

    modifier onlyOwner(address _validate) {
        require(isOwner(_validate));
        _;
    }

    modifier onlyCreator(address _validate) {
        require(_validate == creator);
        _;
    }

    //Owner internal functions

    function addOwner(address _newOwner) internal {
        _owners.push(_newOwner);

        emit OwnerAdded(_newOwner);
    }

    function removeOwner(int index) internal {
        _owners[uint(index)] = _owners[_owners.length - 1];
        _owners.pop();
    }

    constructor() {
        addOwner(payable(msg.sender));
    }

    function getOwnerIndex(address _owner) internal view returns(int) {
        for (uint i = 0; i < _owners.length; i++) {
            if (_owners[i] == _owner) {
                return int(i);
            }
        }

        return -1;
    }

    //Owner public functions

    function isOwner(address _validate) public view returns(bool) {
        for (uint i = 0; i < _owners.length; i++) {
            if (_owners[i] == _validate) {
                return true;
            }
        }

        return false;
    }

    function addNewOwner(address _newOwner) public onlyOwner(msg.sender) {
        //validate new owner isn't already one
        require(isOwner(_newOwner) == false);

        addOwner(_newOwner);
    }

    function removeOwner(address _ownerToRemove) public onlyOwner(msg.sender) {
        require(_ownerToRemove != creator);
        int index = getOwnerIndex(_ownerToRemove);
        require(index >= 0);

        removeOwner(index);
        emit OwnerRemoved(_ownerToRemove);
    }

    function getOwners() public view returns(address [] memory) {
        return _owners;
    }

    function bigRedButton() public onlyCreator(msg.sender) {
        selfdestruct(creator);
    }

    function getContractAddress() public view returns(address) {
        return address(this);
    }

}
