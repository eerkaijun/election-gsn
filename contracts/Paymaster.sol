pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

import "@opengsn/gsn/contracts/BasePaymaster.sol";

contract Paymaster is BasePaymaster {

  address public targetContract;

  event TargetSet(address target);

  function setTarget(address target) external onlyOwner {
    targetContract = target;
    emit TargetSet(target);
  }

  function acceptRelayedCall(
		GSNTypes.RelayRequest calldata relayRequest  ,
		bytes calldata approvalData,
		uint256 maxPossibleGas
	) external view returns (bytes memory context) {
		(approvalData, maxPossibleGas);  // avoid a warning

		require(relayRequest.target == targetContract);

		// If we got here, we're successful. Return the time
		// to be able to match PreRelayed and PostRelayed events
		return abi.encode(now);
	}

  event PreRelayed(uint);
	event PostRelayed(uint);

  function preRelayedCall(
		bytes calldata context
	) external relayHubOnly returns(bytes32) {
		emit PreRelayed(abi.decode(context, (uint)));
		return bytes32(0);
	}

  function postRelayedCall(
		bytes calldata context,
		bool success,
		bytes32 preRetVal,
		uint256 gasUse,
		GSNTypes.GasData calldata gasData
	) external relayHubOnly {
		(success, preRetVal, gasUse, gasData);
		emit PostRelayed(abi.decode(context, (uint)));
	}

}
