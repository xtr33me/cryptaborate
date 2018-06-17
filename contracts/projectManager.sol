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

}
