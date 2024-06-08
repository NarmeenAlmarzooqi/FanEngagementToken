FanEngagementToken Smart Contract Project

Overview
This smart contract aims to enhance fan engagement during Esports events by rewarding fans with tokens for participating in activities within live streaming platforms such as Myco.

Local Testing with Remix
1. Open [Remix IDE](https://remix.ethereum.org/).
2. Create a new file named `FanEngagementToken.sol` and paste the contract code found in this repository.
3. Compile the contract using the appropriate Solidity version (0.8.0).
4. Deploy the contract using the "JavaScript VM" environment.
5. Interact with the contract functions directly in Remix

Smart Contract Functions
- `createActivity(string memory description, uint256 reward)`: Creates a new engagement activity.
- `participateInActivity(uint256 activityId)`: Participates in an activity to earn tokens.
- `deactivateActivity(uint256 activityId)`: Deactivates an activity.
- `generateReport()`: Generates a report of all activities.
