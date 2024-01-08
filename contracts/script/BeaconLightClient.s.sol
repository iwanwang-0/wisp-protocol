pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/lightclient/BeaconLightClient.sol";


contract DeployLightClient is Script {

	function run() external {
		uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
		vm.startBroadcast(deployerPrivateKey);

		bytes32 goerliGenesisValidatorRoot = bytes32(0x043db0d9a83813551ee2f33450d23797757d430911a9320530ad8a0eabc43efb);
		uint256 goerliGenesisType = 1616508000;
		uint256 goerliSecondsPerSlot = uint256(12);
		bytes4 goerliForkVersion = bytes4(0x02001020);

		// Important! The following script will deploy a Goerli Beacon Light Client starting from Period 622 (1 March 2023)
		uint256 goerliStartSyncCommitteePeriod = uint256(831);
		bytes32 goerliStartSyncCommitteeRoot = 0x5858a9647c2f929796a25ffed7c546fe706a31c7c21ab9312dbd42d85ad0e95f;
		bytes32 goerliStartSyncCommitteePoseidon = bytes32(uint256(0x210c51c58414c1befc439e1a142f96023545a5d215da4d40e98dfe180a113357));

		BeaconLightClient lightClient = new BeaconLightClient(
			goerliGenesisValidatorRoot,
			goerliGenesisType,
			goerliSecondsPerSlot,
			goerliForkVersion,
			goerliStartSyncCommitteePeriod,
			goerliStartSyncCommitteeRoot,
			goerliStartSyncCommitteePoseidon);

		vm.stopBroadcast();
	}
}
