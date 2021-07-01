// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract Vote is Ownable {

  using SafeMath for uint;

  struct Candidate {
    string Name;
    uint voteCount;
  }

  constructor() {
    addCandidate("Donald Trump");
    addCandidate("Kanye West");
  }

  uint candidatesCount = 0;
  mapping(uint => Candidate) public candidates;
  mapping(address => bool) public voters;

  function addCandidate(string memory _name) private {
    candidates[candidatesCount] = Candidate(_name, 0);
    candidatesCount++;
  }

  function vote(uint _candidateID) public {
    require(!voters[msg.sender]);
    require(_candidateID >= 0 && _candidateID < candidatesCount);
    voters[msg.sender] = true;
    candidates[_candidateID].voteCount++;
  }

}
