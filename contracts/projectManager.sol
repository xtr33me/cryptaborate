pragma solidity ^0.4.10;
//pragma experimental ABIEncoderV2;

contract ProjectManager {
    struct AppliedUser {
        address user;
        uint positionIndex;
        uint amountToReceive;
        bool hasApplied;
    }

    struct Position {
        address chosenUserAddr;
        string name;
        string description;
        uint amountToReceive;
        uint numAppliedUsers;
        uint positionIndex;
        bool accepted;
        mapping(address => AppliedUser) appliedUsers;
    }

    struct Project {
        address owner;
        string category;
        string name;
        string description;
        string postalcode;
        uint ranking;
        ProjectStatus status;
        uint numPositions;
        mapping(uint => Position) positions;
    }


    enum ProjectStatus { New, Populating, Working, Completed}
    uint positionIndex;
    uint numProjects;
    mapping(uint => Project) projects;

    function hasApplied(address applicant, uint projectId, uint posIndex) private view returns(bool exists) {
        Project storage proj = projects[projectId];
        return proj.positions[posIndex].appliedUsers[applicant].hasApplied;
    }

    function newProject(address owner, string category, string name, string description, string postalcode) public returns (uint projectId) {
        //Going to have to tie the below to a larger scale project Id. Fine for local user projects
        projectId = numProjects++;
        //Need to see if there is a way to create hash from name instead
        positionIndex = 0;
        projects[projectId] = Project(owner, category, name, description, postalcode, 0, ProjectStatus.New, 0);
    }

    function createPosition(uint projectId, string name, string description) public returns (uint positionId) {
        Project storage proj = projects[projectId];
        proj.positions[positionIndex] = Position(0,name,description, 0, 0, positionIndex++, false);
        return positionIndex-1;

    }
    
    function applyForPosition(address applicant, uint projectId, uint posIndex, uint desiredAmount) public {
        //Need to create a hash
        if(hasApplied(applicant, projectId, posIndex)) revert();
        Project storage proj = projects[projectId];
        proj.positions[posIndex].numAppliedUsers++;
        proj.positions[posIndex].appliedUsers[applicant] = AppliedUser({user: msg.sender, positionIndex:posIndex, amountToReceive:desiredAmount, hasApplied: true});
    }

    /*function contribute(uint campaignId) public payable {
        Campaign storage c = campaigns[campaignId];
        c.funders[c.numFunders++] = Funder({addr: msg.sender, amount: msg.value});
        c.amount += msg.value;
    }*/

    /*function checkGoalReached(uint campaignId) public returns (bool reached){
        Campaign storage c = campaigns[campaignId];
        if(c.amount < c.fundingGoal)
            return false;
        uint amount = c.amount;
        c.amount = 0;
        c.benificiary.transfer(amount);
        return true;
    }*/
    
    //function modifyPositions()

    /*function ModifyProject(string category, string name, string description, Position[] positions) public {
        _category = category;
        _name = name;
        _description = description;
        //_positions = positions;
    }

    function getCategory() public returns(string) {
        return category;
    }

    function getRanking() public returns(uint) {
        return ranking;
    }

    function getStatus() public returns (uint) {
        return uint(status);
    }*/

    //Position[] public currentPositions;

    //mapping (address=>int) public userTopScores;
    
    // function setTopScore(int256 score, uint8 v, bytes32 r, bytes32 s) {
    //     var hash = sha3(msg.sender, owner, score);
    //     var addressCheck = ecrecover(hash, v, r, s);
        
    //     if(addressCheck != owner) throw;
        
    //     var currentTopScore = userTopScores[msg.sender];
    //     if(currentTopScore < score){
    //         userTopScores[msg.sender] = score;
    //     }

    //     if(topScores.length < maxTopScores){
    //         var topScore = TopScore(msg.sender, score);
    //         topScores.push(topScore);
    //     }else{
    //         int lowestScore = 0;
    //         uint lowestScoreIndex = 0; 
    //         for (uint i = 0; i < topScores.length; i++)
    //         {
    //             TopScore currentScore = topScores[i];
    //             if(i == 0){
    //                 lowestScore = currentScore.score;
    //                 lowestScoreIndex = i;
    //             }else{
    //                 if(lowestScore > currentScore.score){
    //                     lowestScore = currentScore.score;
    //                     lowestScoreIndex = i;
    //                 }
    //             }
    //         }
    //         if(score > lowestScore){
    //             var newtopScore = TopScore(msg.sender, score);
    //             topScores[lowestScoreIndex] = newtopScore;
    //         }
    //     }
    // }

}
