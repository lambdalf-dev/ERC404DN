pragma solidity 0.8.24;

import {IImmutableCreate2Factory} from "./../src/interfaces/IImmutableCreate2Factory.sol";
import {Project} from "./../src/Project.sol";
import {ProjectFactory} from "./../src/ProjectFactory.sol";
import {Script} from "forge-std/Script.sol";

contract DeployScript is Script {
  IImmutableCreate2Factory CREATE2 = IImmutableCreate2Factory(0x0000000000FFe8B47B3e2130213B802212439497);

  function run() external {
    uint256 deployerPrivateKey = vm.envUint("TEST_DEV_PRIVATE_KEY");

    bytes32 projectSalt = bytes32(0x00) & bytes12(keccak256(abi.encodePacked("PROJECT")));
    bytes memory projectCode = abi.encodePacked(type(Project).creationCode);
    bytes memory projectFactoryCode = abi.encodePacked(type(ProjectFactory).creationCode);

    vm.startBroadcast(deployerPrivateKey);

    address projectImpl = CREATE2.safeCreate2(projectSalt, projectCode);
    address projectFactory = CREATE2.safeCreate2(projectSalt, projectFactoryCode);

    vm.stopBroadcast();
  }
}
