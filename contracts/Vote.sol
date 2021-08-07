// SPDX-License-Identifier: MIT

pragma solidity ^0.7.6;

import "./Identity.sol";

contract Vote is Identity {

  struct Candidate {
    string name;
    uint voteCount;
  }

  constructor() {
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

}
