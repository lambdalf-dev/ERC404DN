// SPDX-License-Identifier: MIT

/**
* Author: Lambdalf the White
*/

pragma solidity >=0.8.4 <0.9.0;

import {IERC165} from '@lambdalf-dev/ethereum-contracts/contracts/interfaces/IERC165.sol';
import {IERC20} from '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import {IERC721} from '@lambdalf-dev/ethereum-contracts/contracts/interfaces/IERC721.sol';
import {IERC721Metadata} from '@lambdalf-dev/ethereum-contracts/contracts/interfaces/IERC721Metadata.sol';
import {IERC721Enumerable} from '@lambdalf-dev/ethereum-contracts/contracts/interfaces/IERC721Enumerable.sol';
import {IERC721Receiver} from '@lambdalf-dev/ethereum-contracts/contracts/interfaces/IERC721Receiver.sol';
import {IERC2981} from '@lambdalf-dev/ethereum-contracts/contracts/interfaces/IERC2981.sol';
import {LibBitMap} from 'solady/src/utils/LibBitMap.sol';

contract ERC404DN721 {
  // **************************************
  // *****           ERRORS           *****
  // **************************************
  // **************************************

  // **************************************
  // *****    BYTECODE  VARIABLES     *****
  // **************************************
    string public constant name = "ERC404 Dual Nexus 721";
    string public constant symbol = "ERC404DN721";
		uint public constant WAD = 10 ** 18;
		IERC20 public immutable COUNTERPART;
  // **************************************

  // **************************************
  // *****     STORAGE VARIABLES      *****
  // **************************************
	  /// @dev List of burned tokens
	  LibBitMap.BitMap private _burned;
	  /// @dev Identifier of the next token to be minted
	  uint256 private _nextId;
	  /// @dev Token ID mapped to approved address
	  mapping(uint256 => address) private _approvals;
	  /// @dev Token owner mapped to operator approvals
	  mapping(address => mapping(address => bool)) private _operatorApprovals;
	  /// @dev List of owner addresses
	  mapping(uint256 => address) private _owners;
  // **************************************

	constructor(address counterpart_) {
		COUNTERPART = IERC20(counterpart_);
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
    function approve(address approved_, uint256 tokenId_) external override {
      address _tokenOwner_ = ownerOf(tokenId_);
      if (to_ == _tokenOwner_) {
        revert IERC721_INVALID_APPROVAL();
      }
      bool _isApproved_ = _isApprovedOrOwner(_tokenOwner_, msg.sender, tokenId_);
      if (! _isApproved_) {
        revert IERC721_CALLER_NOT_APPROVED(msg.sender, tokenId_);
      }
      _approvals[tokenId_] = to_;
      emit Approval(_tokenOwner_, to_, tokenId_);
    }

    function safeTransferFrom(address from_, address to_, uint256 tokenId_, bytes calldata data_) external override {
      transferFrom(from_, to_, tokenId_);
      if (! _checkOnERC721Received(from_, to_, tokenId_, data_)) {
        revert IERC721_INVALID_RECEIVER(to_);
      }
    }

    function safeTransferFrom(address from_, address to_, uint256 tokenId_) external override {
      safeTransferFrom(from_, to_, tokenId_, "");
    }

    function setApprovalForAll(address operator_, bool approved_) external override {
      if (operator_ == msg.sender) {
        revert IERC721_INVALID_APPROVAL();
      }
      _operatorApprovals[msg.sender][operator_] = approved_;
      emit ApprovalForAll(msg.sender, operator_, approved_);
    }

    function transferFrom(address from_, address to_, uint256 tokenId_) external override {
      if (to_ == address(0)) {
        revert IERC721_INVALID_RECEIVER(to_);
      }
      address _tokenOwner_ = ownerOf(tokenId_);
      if (from_ != _tokenOwner_) {
        revert IERC721_INVALID_TOKEN_OWNER();
      }
      if (! _isApprovedOrOwner(_tokenOwner_, msg.sender, tokenId_)) {
        revert IERC721_CALLER_NOT_APPROVED(msg.sender, tokenId_);
      }
      _transfer(from_, to_, tokenId_);
    }
  // **************************************

  // **************************************
  // *****       CONTRACT_OWNER       *****
  // **************************************
  // **************************************

  // **************************************
  // *****            VIEW            *****
  // **************************************
    function balanceOf(address owner_) external view override returns (uint256 balance) {
    	balance = COUNTERPART.balanceOf(owner_) / WAD;
    }

    function getApproved(uint256 tokenId_) external view override returns (address approvedOperator) {
    	approvedOperator = _approvals[tokenId_];
    }

    function isApprovedForAll(address owner_, address operator_) external view override returns (bool isApproved) {
      isApproved = operator_ == address(COUNTERPART) || _operatorApprovals[owner_][operator_];
    }

    function ownerOf(uint256 tokenId_) external view override returns (address tokenOwner) {
      if (tokenId_ == 0 || tokenId_ >= _nextId) {
        revert IERC721_NONEXISTANT_TOKEN(tokenId_);
      }
      uint256 _tokenId_ = tokenId_;
      tokenOwner = _owners[_tokenId_];
      while (tokenOwner == address(0)) {
        unchecked {
          --_tokenId_;
        }
        tokenOwner = _owners[_tokenId_];
      }
    }

    function tokenByIndex(uint256 index_) external view override returns (uint256 tokenId) {
      if (index_ >= _nextId - 1) {
        revert IERC721Enumerable_INDEX_OUT_OF_BOUNDS(index_);
      }
      return index_ + 1;
    }

    function tokenOfOwnerByIndex(address owner_, uint256 index_) external view override returns (uint256 tokenId) {
      if (tokenOwner_ == address(0)) {
        revert IERC721_INVALID_TOKEN_OWNER();
      }
      address _currentTokenOwner_;
      uint256 _index_ = 1;
      uint256 _ownerBalance_;
      while (_index_ < _nextId) {
        if (_owners[_index_] != address(0)) {
          _currentTokenOwner_ = _owners[_index_];
        }
        if (tokenOwner_ == _currentTokenOwner_) {
          if (index_ == _ownerBalance_) {
            return _index_;
          }
          unchecked {
            ++_ownerBalance_;
          }
        }
        unchecked {
          ++_index_;
        }
      }
      revert IERC721Enumerable_OWNER_INDEX_OUT_OF_BOUNDS(index_);
    }

    function totalSupply() external view override returns (uint256 supply) {
    	supply = COUNTERPART.totalSupply() / WAD;
    }

    function tokenURI(uint256 tokenId_) external view override returns (string memory url) {
    	return bytes(_baseUri).length > 0 ? string(abi.encodePacked(_baseUri, _toString(tokenId_))) : _toString(tokenId_);
    }

	  function supportsInterface(bytes4 interfaceId_) public pure override returns (bool) {
	    return interfaceId_ == type(IERC721).interfaceId || interfaceId_ == type(IERC721Enumerable).interfaceId
	      || interfaceId_ == type(IERC721Metadata).interfaceId || interfaceId_ == type(IERC165).interfaceId;
	  }
  // **************************************

  // **************************************
  // *****          INTERNAL          *****
  // **************************************
    function _checkOnERC721Received(address from_, address to_, uint256 tokenId_, bytes memory data_) internal virtual returns (bool isValidReceiver) {
      uint256 _size_;
      assembly {
        _size_ := extcodesize(to_)
      }
      if (_size_ > 0) {
        try IERC721Receiver(to_).onERC721Received(msg.sender, from_, tokenId_, data_) returns (bytes4 retval) {
          return retval == IERC721Receiver.onERC721Received.selector;
        }
        catch (bytes memory reason) {
          if (reason.length == 0) {
            revert IERC721_INVALID_RECEIVER(to_);
          }
          else {
            assembly {
              revert(add(32, reason), mload(reason))
            }
          }
        }
      }
      else {
        return true;
      }
    }

	  function _isApprovedOrOwner(uint256 tokenId_, address spender_) internal virtual returns (bool isApproved) {
	  	address _tokenOwner_ = ownerOf(tokenId_);
	  	isApproved = spender_ == _tokenOwner_ || _approvals[tokenId_] == spender_ 
	  		|| isApprovedForAll(_tokenOwner_, spender_);
	  }

    function _mint(address toAddress_, uint256 qty_) internal virtual {
      uint256 _firstToken_ = _nextId;
      uint256 _nextStart_ = _firstToken_ + qty_;
      uint256 _lastToken_ = _nextStart_ - 1;
      _owners[_firstToken_] = toAddress_;
      if (_lastToken_ > _firstToken_) {
        _owners[_lastToken_] = toAddress_;
      }
      _nextId = _nextStart_;
      while (_firstToken_ < _nextStart_) {
        emit Transfer(address(0), toAddress_, _firstToken_);
        unchecked {
          ++_firstToken_;
        }
      }
      COUNTERPART.mintTo(toAddress_, qty_ * WAD);
    }

    function _transfer(address fromAddress_, address toAddress_, uint256 tokenId_) internal virtual {
      _approvals[tokenId_] = address(0);
      uint256 _previousId_ = tokenId_ > 1 ? tokenId_ - 1 : 1;
      uint256 _nextId_ = tokenId_ + 1;
      bool _previousShouldUpdate_ =
        _previousId_ < tokenId_ &&
        _exists(_previousId_) &&
        _owners[_previousId_] == address(0);
      bool _nextShouldUpdate_ =
        _exists(_nextId_) &&
        _owners[_nextId_] == address(0);
      if (_previousShouldUpdate_) {
        _owners[_previousId_] = fromAddress_;
      }
      if (_nextShouldUpdate_) {
        _owners[_nextId_] = fromAddress_;
      }
      _owners[tokenId_] = toAddress_;
      emit Transfer(fromAddress_, toAddress_, tokenId_);
      COUNTERPART.transferFrom(fromAddress_, toAddress_, WAD);
    }

	  function _toString(uint256 value_) internal pure virtual returns (string memory str) {
	    assembly {
	      let m := add(mload(0x40), 0xa0)
	      mstore(0x40, m)
	      str := sub(m, 0x20)
	      mstore(str, 0)
	      let end := str
	      for { let temp := value_ } 1 {} {
	        str := sub(str, 1)
	        mstore8(str, add(48, mod(temp, 10)))
	        temp := div(temp, 10)
	        if iszero(temp) { break }
	      }
	      let length := sub(end, str)
	      str := sub(str, 0x20)
	      mstore(str, length)
	    }
	  }

    function _setBaseUri(string memory newBaseUri_) internal virtual {
      _baseUri = newBaseUri_;
    }
  // **************************************
}
