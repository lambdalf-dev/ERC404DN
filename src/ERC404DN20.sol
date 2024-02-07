// SPDX-License-Identifier: MIT

/**
* Author: Lambdalf the White
*/

pragma solidity >=0.8.4 <0.9.0;

import {IERC165} from '@lambdalf-dev/ethereum-contracts/contracts/interfaces/IERC165.sol';
import {IERC721} from '@lambdalf-dev/ethereum-contracts/contracts/interfaces/IERC721.sol';
import {IERC20} from '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import {IERC20Metadata} from '@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol';

contract ERC404DN20 {
  // **************************************
  // *****           ERRORS           *****
  // **************************************
  // **************************************

  // **************************************
  // *****    BYTECODE  VARIABLES     *****
  // **************************************
    string public constant name = "ERC404 Dual Nexus 20";
    string public constant symbol = "ERC404DN20";
    uint8 public constant decimals = 18;
		uint public constant WAD = 10 ** 18;
		IERC721 public immutable COUNTERPART;
  // **************************************

  // **************************************
  // *****     STORAGE VARIABLES      *****
  // **************************************
  	uint256 public totalSupply;
		mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
  // **************************************

	constructor(address counterpart_) {
		COUNTERPART = IERC721(counterpart_);
	}

  // **************************************
  // *****          FALLBACK          *****
  // **************************************
	  fallback() external payable {} // solhint-disable no-empty-blocks
	  receive() external payable {} // solhint-disable no-empty-blocks
  // **************************************

  // **************************************
  // *****          MODIFIER          *****
  // **************************************
  // **************************************

  // **************************************
  // *****           PUBLIC           *****
  // **************************************
    function approve(address spender_, uint256 amount_) external override returns (bool) {
    	_allowances[msg.sender][spender_] = amount_;
    	return true;
    }

    function transfer(address to_, uint256 amount_) external override returns (bool) {
    	return true;
    }

    function transferFrom(address from_, address to_, uint256 amount_) external override returns (bool) {
    	return true;
    }
  // **************************************

  // **************************************
  // *****       CONTRACT_OWNER       *****
  // **************************************
  // **************************************

  // **************************************
  // *****            VIEW            *****
  // **************************************
    function allowance(address owner_, address spender_) external view override returns (uint256 amountAllowed) {
    	amountAllowed = _allowances[owner_][spender_];
    }

    function balanceOf(address account_) external view override returns (uint256 balance) {
    	balance = _balances[account_];
    }

	  function supportsInterface(bytes4 interfaceId_) public pure override returns (bool) {
	    return interfaceId_ == type(IERC20).interfaceId || interfaceId_ == type(IERC20Metadata).interfaceId
	    	|| interfaceId_ == type(IERC165).interfaceId;
	  }
  // **************************************

  // **************************************
  // *****          INTERNAL          *****
  // **************************************
	  function _isApprovedOrOwner(address tokenOwner_, address spender_) internal virtual returns (bool isApproved) {
	  	isApproved = spender_ == address(COUNTERPART) || 
	  }

	  function _transferFrom(address fromAddress_, address toAddress_, uint256 amount_) internal virtual {
	  }
  // **************************************
}
