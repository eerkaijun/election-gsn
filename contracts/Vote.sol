// SPDX-License-Identifier: MIT

pragma solidity ^0.7.6;

import "@opengsn/contracts/src/BaseRelayRecipient.sol";
import "./Identity.sol";

contract Vote is BaseRelayRecipient, Identity {

  struct Candidate {
    string name;
    uint voteCount;
  }

  constructor() {
    //trustedForwarder = 0xeB230bF62267E94e657b5cbE74bdcea78EB3a5AB; // Ropsten testnet
    trustedForwarder = 0x4d4581c01A457925410cd3877d17b2fd4553b2C5; // Mumbai testnet
    addCandidate("Donald Trump");
    addCandidate("Kanye West");
  }

  uint candidatesCount = 0;
  mapping(uint => Candidate) public candidates;
  //mapping(address => bool) public voters;

  function addCandidate(string memory _name) private {
    candidates[candidatesCount] = Candidate(_name, 0);
    candidatesCount++;
  }

  function vote(uint _candidateID) public {
    require(voters[_msgSender()].verified);
    require(!voters[_msgSender()].voted);
    require(_candidateID >= 0 && _candidateID < candidatesCount);
    voters[_msgSender()].voted = true;
    candidates[_candidateID].voteCount++;
  }

  function getCandidateName(uint _candidateID) public view returns (string memory) {
    return candidates[_candidateID].name;
  }

  function getVoteCount(uint _candidateID) public view returns (uint){
    return candidates[_candidateID].voteCount;
  }

  function versionRecipient() external pure override returns (string memory) {
    return "2.2.0";
  }

}
