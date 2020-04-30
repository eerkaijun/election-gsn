pragma solidity ^0.5.0;

import "@openzeppelin/contracts-ethereum-package/contracts/GSN/GSNRecipient.sol";

contract Election is GSNRecipient {

  struct Candidate{
    uint id;
    string name;
    uint voteCount;
  }

  //mapping is sort of like an array
  //with the key being the iterable
  mapping(uint => Candidate) public candidates;
  mapping(address => bool) public voters;

  //no way to iterate through a mapping that's why needed a count mechanism
  uint public candidatesCount;

  constructor() public {
    addCandidate("Eer Kai Jun");
    addCandidate("Lim Zhi Hsuan");
  }

  function addCandidate(string memory _name) private {
    candidatesCount++;
    candidates[candidatesCount] = Candidate(candidatesCount, _name, 0);
  }

  function vote(uint _candidateId) public {
    require(!voters[msg.sender]);
    require(_candidateId > 0 && _candidateId <= candidatesCount);
    voters[msg.sender] = true;
    candidates[_candidateId].voteCount++;
  }

  event votedEvent(uint indexed _candidateId);

  function acceptRelayedCall(
        address relay,
        address from,
        bytes calldata encodedFunction,
        uint256 transactionFee,
        uint256 gasPrice,
        uint256 gasLimit,
        uint256 nonce,
        bytes calldata approvalData,
        uint256 maxPossibleCharge
    ) external view returns (uint256, bytes memory) {
        return _approveRelayedCall();
    }

  function _preRelayedCall(bytes memory context) internal returns (bytes32) {
  }

  function _postRelayedCall(bytes memory context, bool, uint256 actualCharge, bytes32) internal {
  }

}
