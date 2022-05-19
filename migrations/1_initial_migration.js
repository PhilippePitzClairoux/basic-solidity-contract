const OwnerManagement = artifacts.require("OwnerManagement");

module.exports = function (deployer) {
  deployer.deploy(OwnerManagement);
};
