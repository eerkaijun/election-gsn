// SPDX-License-Identifier: MIT

pragma solidity ^0.7.6;

import "@opengsn/contracts/src/BaseRelayRecipient.sol";

contract Identity is BaseRelayRecipient{

  address private _identityVerifier;
  mapping(address => Voter) voters;

  struct Voter {
    string name;
    string ID;
    bool registered;
    bool verified;
    bool voted;
  }

  constructor() {
    trustedForwarder = 0x9399BB24DBB5C4b782C70c2969F58716Ebbd6a3b; //Biconomy Matic Mumbai forwarder
    _identityVerifier = _msgSender();
  }

  modifier onlyOwner() {
    require(_msgSender() == _identityVerifier, "Caller is not the identity verifier");
    _;
  }

  function setTrustedForwarder(address _trustedForwarder) public onlyOwner {
    trustedForwarder = _trustedForwarder;
  }

  function register(string memory _name, string memory _nationalID) public returns(bool) {
    require(!voters[_msgSender()].registered);
    voters[_msgSender()] = Voter(_name, _nationalID, true, false, false);
    return true;
  }

  function verify(address _voterAddress) public onlyOwner returns(bool) {
    voters[_voterAddress].verified = true;
    return true;
  }

  function versionRecipient() external pure override returns (string memory) {
    return "2.2.0";
  }
}
