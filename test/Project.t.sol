// SPDX-License-Identifier: AGPL

/**
 * Author: Lambdalf the White
 */

pragma solidity >=0.8.4 <0.9.0;

import {Project} from "../src/Project.sol";
import {ProjectFactory} from "../src/ProjectFactory.sol";
import {TestHelper} from "./TestHelper.sol";

contract Deployed is TestHelper {
	ProjectFactory factory;
	Project implementation;
	Project testContract;

	function setUp() public virtual override {
		super.setUp();
    implementation = new Project();
    factory = new ProjectFactory();
    testContract = Project(
      payable(
        factory.deployClone()
      )
    );
	}
}
