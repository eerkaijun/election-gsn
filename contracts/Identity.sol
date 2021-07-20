// SPDX-License-Identifier: MIT

pragma solidity ^0.7.6;

contract Identity {

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
    _identityVerifier = msg.sender;
  }

  modifier onlyOwner() {
    require(msg.sender == _identityVerifier, "Caller is not the identity verifier");
    _;
  }

  function register(string memory _name, string memory _nationalID) public returns(bool) {
    require(!voters[msg.sender].registered);
    voters[msg.sender] = Voter(_name, _nationalID, true, false, false);
    return true;
  }

  function verify(address _voterAddress) public onlyOwner returns(bool) {
    voters[_voterAddress].verified = true;
    return true;
  }
}
