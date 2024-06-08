// spdx-license-identifier: mit
pragma solidity ^0.8.0;

// importing the erc20 contract from openzeppelin
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// defining the fanengagementtoken contract which inherits from erc20
contract FanEngagementToken is ERC20 {
    // declaring a public variable organizer of type address
    address public organizer;

    // defining a struct to store engagement activity details
    struct EngagementActivity {
        uint256 activityId;  // activity id
        string description;  // description of the activity
        uint256 reward;      // reward tokens for the activity
        bool isActive;       // status of the activity
    }

    // declaring a public variable to store the next activity id
    uint256 public nextActivityId;

    // mapping to store activities with their ids
    mapping(uint256 => EngagementActivity) public activities;

    // nested mapping to track participation of users in activities
    mapping(address => mapping(uint256 => bool)) public participation;

    // event to log when an activity is created
    event ActivityCreated(uint256 activityId, string description, uint256 reward);

    // event to log when tokens are rewarded to a fan
    event TokensRewarded(address indexed fan, uint256 activityId, uint256 reward);

    // constructor to initialize the erc20 token with name and symbol
    constructor() ERC20("FanEngagementToken", "FET") {
        organizer = msg.sender;  // setting the contract deployer as the organizer
    }

    // modifier to restrict function access to only the organizer
    modifier onlyOrganizer() {
        require(msg.sender == organizer, "only organizer can perform this action");
        _;
    }

    // function to create a new engagement activity
    function createActivity(string memory description, uint256 reward) public onlyOrganizer {
        // creating a new activity with provided details
        EngagementActivity memory newActivity = EngagementActivity({
            activityId: nextActivityId,
            description: description,
            reward: reward,
            isActive: true
        });

        // storing the new activity in the mapping
        activities[nextActivityId] = newActivity;

        // emitting the activity created event
        emit ActivityCreated(nextActivityId, description, reward);

        // incrementing the activity id for the next activity
        nextActivityId++;
    }

    // function for a user to participate in an activity and earn tokens
    function participateInActivity(uint256 activityId) public {
        // checking if the activity is active
        require(activities[activityId].isActive, "activity is not active");

        // checking if the user has already participated in this activity
        require(!participation[msg.sender][activityId], "already participated in this activity");

        // marking the user as having participated in this activity
        participation[msg.sender][activityId] = true;

        // minting tokens to the user as a reward
        _mint(msg.sender, activities[activityId].reward);

        // emitting the tokens rewarded event
        emit TokensRewarded(msg.sender, activityId, activities[activityId].reward);
    }

    // function to deactivate an activity
    function deactivateActivity(uint256 activityId) public onlyOrganizer {
        activities[activityId].isActive = false;  // setting the activity as inactive
    }

    // function to generate a report of all activities
    function generateReport() public view onlyOrganizer returns (EngagementActivity[] memory) {
        // creating an array to store the active activities
        EngagementActivity[] memory activeActivities = new EngagementActivity[](nextActivityId);

        // looping through the activities and adding them to the array
        for (uint256 i = 0; i < nextActivityId; i++) {
            activeActivities[i] = activities[i];
        }

        // returning the array of active activities
        return activeActivities;
    }
}
