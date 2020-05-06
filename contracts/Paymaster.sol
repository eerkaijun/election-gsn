pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

import "@opengsn/gsn/contracts/BasePaymaster.sol";

contract Paymaster is BasePaymaster {

  function acceptRelayedCall(
        GSNTypes.RelayRequest calldata relayRequest,
        bytes calldata approvalData,
        uint256 maxPossibleGas
    )
    external
    view
    returns (bytes memory) {
  }


  function preRelayedCall(bytes calldata context) external returns (bytes32) {
  }

  function postRelayedCall(
        bytes calldata context,
        bool success,
        bytes32 preRetVal,
        uint256 gasUseWithoutPost,
        GSNTypes.GasData calldata gasData
    ) external {}



}
