pragma solidity >=0.8.4 <0.9.0;

import {Test} from "forge-std/Test.sol";

contract Accounts is Test {
  // Default token owner
  Account public ALICE;
  // Other token owner
  Account public BOB;
  // Default approved operator
  Account public OPERATOR;
  // Default transaction recipient
  Account public RECIPIENT;
  // Default royalty recipient
  Account public ROYALTY_RECIPIENT;

  /// @dev Generates a user, labels its address, and funds it with test assets.
  function _createUser(string memory name) internal returns (Account memory account) {
    account = makeAccount(name);
    vm.deal({account: account.addr, newBalance: 100 ether});
  }
}

contract Constants {
  string public constant NAME = "NFT Collection";
  string public constant SYMBOL = "NFT";
  string public constant CONTRACT_URI = "api.example.com/contract";
  string public constant BASE_URI = "https://api.example.com/";
  string public constant NEW_BASE_URI = "https://example.com/api/";
  uint256 public constant FIRST_TOKEN = 0;
  uint256 public constant TARGET_TOKEN = 3;
  uint256 public constant TARGET_INDEX = 3;
  uint256 public constant NONEXISTANT_TOKEN = 100;
  uint256 public constant NONEXISTANT_INDEX = 100;
  uint256 public constant BOB_TOKEN = 6;
  uint256 public constant ALICE_INIT_SUPPLY = 6;
  uint256 public constant ALICE_MORE_SUPPLY = 3;
  uint256 public constant ALICE_SUPPLY = ALICE_INIT_SUPPLY + ALICE_MORE_SUPPLY;
  uint256 public constant BOB_SUPPLY = 1;
  uint256 public constant MINTED_SUPPLY = ALICE_SUPPLY + BOB_SUPPLY;
  uint256 public constant BURNED_SUPPLY = 1;
  uint96 public constant ROYALTY_BASE = 10_000;
  uint96 public constant ROYALTY_RATE = 100;
  bytes4 public constant RETVAL = 0x000d0b74;
  bytes public constant DATA = "0x000d0b7417742123dfd8";
}

abstract contract TestHelper is Constants, Accounts {
  function setUp() public virtual {
    ALICE = _createUser("Alice");
    BOB = _createUser("Bob");
    OPERATOR = _createUser("Operator");
    RECIPIENT = _createUser("Recipient");
    ROYALTY_RECIPIENT = _createUser("RoyaltyRecipient");
  }
}
