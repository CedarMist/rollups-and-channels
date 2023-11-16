# Rollups & Smart Channels

This repo provides an example of how a view calls to confidential contracts on Oasis Sapphire can be used to create rollups and state channels.

Using the [@oasis-protocol/sapphire-contracts](https://www.npmjs.com/package/@oasisprotocol/sapphire-contracts) library The contracts generates their own secrets which are used to either encrypt state that only they can access, or to sign state which can be independently verified.

While [@oasis-protocol/sapphire-hardhat](https://www.npmjs.com/package/@oasisprotocol/sapphire-hardhat) package makes testing easy with Hardhat, you also need to run a local [sapphire-dev](https://github.com/oasisprotocol/oasis-web3-gateway/pkgs/container/sapphire-dev) instance which supports the necessary EVM precompiles.

For your convenience there is a `Makefile` which uses Docker to keep everything neatly contained:

```
make sapphire-dev &  # This will take a few minutes
make pnpm-install
make hardhat-compile
make hardhat-test
```