// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

contract Vote is Ownable {

  using SafeMath for uint;

  struct Candidate {
    string Name;
    uint voteCount;
  }

  constructor() {
    addCandidate("Kanye West");
  }

  uint candidatesCount = 0;
  mapping(uint => Candidate) public candidates;

  function addCandidate(string memory _name) private {
    candidates[candidatesCount] = Candidate(_name, 0);
    candidatesCount++;
  }

}
