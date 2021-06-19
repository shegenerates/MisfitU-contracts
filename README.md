# MisfitU-contracts
Smart Contracts for Misfit U NFT project

## Deployments
**Goerli**
- 0x6e6BCDB87ADEeC6cf2A1b48f5e7676F5E0eF099C
- https://oneclickdapp.com/milk-presto

## How to Use:
- Call the `mint()` fuction to get a new Misfit. You must send the `fee` amount at least. This can be called 9900 times.
- The `owner` can call `mintOwner()` to mint up to 100 Misfits for free.
- Anyone can call `getOwnerResrveMinted()` to check how many free mints are left.
- The `owner` can call `cashOut()` to drain all the sales ETH to their address.
- The `owner` can call `updateOwner(address newOwner)` to update the `owner` field, they can change this to a DAO in the future which would be allowed to change the fee, set new owners, and cashout fees.
