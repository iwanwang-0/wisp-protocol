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

		bytes32 goerliGenesisValidatorRoot = bytes32(0x043db0d9a83813551ee2f33450d23797757d430911a9320530ad8a0eabc43efb);
		uint256 goerliGenesisType = 1616508000;
		uint256 goerliSecondsPerSlot = uint256(12);
		bytes4 goerliForkVersion = bytes4(0x02001020);

		// Important! The following script will deploy a Goerli Beacon Light Client starting from Period 831
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
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address _lightClient;
        address _outputOracle;
        if (keccak256(abi.encodePacked(network)) == keccak256(abi.encodePacked("optimism-goerli"))) {
            _lightClient = vm.envAddress("OPTIMISM_GOERLI_LIGHT_CLIENT_ADDRESS");
            _outputOracle = vm.envAddress("OPTIMISM_GOERLI_OUTPUT_ORACLE");
        } else if (keccak256(abi.encodePacked(network)) == keccak256(abi.encodePacked("base-goerli"))) {
            _lightClient = vm.envAddress("BASE_GOERLI_LIGHT_CLIENT_ADDRESS");
            _outputOracle = vm.envAddress("BASE_GOERLI_OUTPUT_ORACLE");
        } else {
            revert("Unknown network");
        }
        
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
        address lightClient = deployLC();
        address outbox = deployOutbox();
        address inbox = deployInbox(network);
        address receiver = deployReceiverDemo();

        console.log("lightClient: ", lightClient);
        console.log("outbox: ", outbox);
        console.log("inbox: ", inbox);
        console.log("receiver: ", receiver);
    }
}
