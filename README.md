# Project

Warning: not easy to implement it perfectly to my taste.

- A pair of co-joined ERC20 and ERC721. 
- You will need initialize functions on both sides so that they know who is the other partner.
- We won’t be storing the balances in the ERC721 side, but rather derived from the ERC20 balances.
- Solady Uint48 maps for implementing the enumerable logic. 
- Balance stored as WAD on the ERC20 side, and divided by WAD to get the integer amount of ERC721 tokens.
- Any mint, transfer, burn on one side will trigger relevant state changes on the other side.
		So you gotta have permissioned external functions that allow only the partner to call.
- Events are to be emitted on each respective side for their standards.
- ERC721 isApprovalForAll and infinite ERC20 approvals won’t be reseted upon token transfers/burns.

## About Project

Description

## Running the repo

Here's a brief guide as to how run this repo.

First, you make sure you have [foundry](https://github.com/foundry-rs/foundry) on your machine.
Then clone the repo and run:
```
yarn install
forge install
```

### Running the tests

To run the tests, you can run either of the following commands:

- `yarn test` runs the full test suite
- `yarn test:verbose` runs the full test suite, displaying all internal calls, etc...
- `forge test -vvvv --match-test <test case name>` runs a given test case, displaying all internal calls, etc...

### Linting the contracts

To run a linter check, you can run:

- `yarn lint` runs forge fmt on the target directory

### Test coverage

To run coverage, run the following commands:

- `yarn coverage` runs a coverage report and generates an html coverage report

### Deployment

To deploy, run the following:

- `yarn deploy:sepolia` deploys on Sepolia testnet

## Contents

- `src`: The list of contracts included in the library.
- `lib`: A list of libraries necessary to run forge test suite.
- `test`: The foundry test suite for the repository.
- `script`: The deployment scripts.

## Testnet deployment

