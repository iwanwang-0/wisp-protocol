pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/lightclient/BeaconLightClient.sol";
import "../src/crc-messages/CRCOutbox.sol";
import "../src/crc-messages/inbox/optimism/OptimismInbox.sol";
import "../src/crc-messages/ReceiverDemo.sol";
import "forge-std/console.sol";

contract Deploy is Script {

	function deployLC() public returns (address) {
		uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
		vm.startBroadcast(deployerPrivateKey);

		bytes32 goerliGenesisValidatorRoot = bytes32(0xd8ea171f3c94aea21ebc42a1ed61052acf3f9209c00e4efbaaddac09ed9b8078);
		uint256 goerliGenesisType = 1655733600;
		uint256 goerliSecondsPerSlot = uint256(12);
		bytes4 goerliForkVersion = bytes4(0x90000069);

		// Important! The following script will deploy a Goerli Beacon Light Client starting from Period 431
        // TODO The following 3 params are mock.
		uint256 goerliStartSyncCommitteePeriod = uint256(431);
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

        return address(lightClient);
	}

    function deployOutbox() public returns (address) {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        CRCOutbox outbox = new CRCOutbox();
        vm.stopBroadcast();

        return address(outbox);
    }

    function deployInbox(string memory network) public returns (address) {
        address _lightClient;
        address _outputOracle;
        if (keccak256(abi.encodePacked(network)) == keccak256(abi.encodePacked("optimism-sepolia"))) {
            _lightClient = vm.envAddress("OPTIMISM_SEPOLIA_LIGHT_CLIENT_ADDRESS");
            _outputOracle = vm.envAddress("BASE_SEPOLIA_OUTPUT_ORACLE");
        } else if (keccak256(abi.encodePacked(network)) == keccak256(abi.encodePacked("base-sepolia"))) {
            _lightClient = vm.envAddress("BASE_SEPOLIA_LIGHT_CLIENT_ADDRESS");
            _outputOracle = vm.envAddress("OPTIMISM_SEPOLIA_OUTPUT_ORACLE");
        } else {
            revert("Unknown network");
        }
        
        return _deployInbox(_lightClient, _outputOracle);
    }

    function _deployInbox(address _lightClient, address _outputOracle) internal returns (address) {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        OptimismInbox inbox = new OptimismInbox(_lightClient, _outputOracle);
        vm.stopBroadcast();

        return address(inbox);
    }

    function deployReceiverDemo() public returns (address) {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        ReceiverDemo receiver = new ReceiverDemo();
        vm.stopBroadcast();
        return address(receiver);
    }

    function run(string memory network) external {
        address _outputOracle;
        if (keccak256(abi.encodePacked(network)) == keccak256(abi.encodePacked("optimism-sepolia"))) {
            _outputOracle = vm.envAddress("BASE_SEPOLIA_OUTPUT_ORACLE");
        } else if (keccak256(abi.encodePacked(network)) == keccak256(abi.encodePacked("base-sepolia"))) {
            _outputOracle = vm.envAddress("OPTIMISM_SEPOLIA_OUTPUT_ORACLE");
        } else {
            revert("Unknown network");
        }

        address lightClient = deployLC();
        address outbox = deployOutbox();
        address inbox = _deployInbox(lightClient, _outputOracle);
        address receiver = deployReceiverDemo();

        console.log("lightClient: ", lightClient);
        console.log("outbox: ", outbox);
        console.log("inbox: ", inbox);
        console.log("receiver: ", receiver);
    }
}
