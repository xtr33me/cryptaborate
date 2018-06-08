pragma solidity ^0.4.10;

contract User {

    struct Statuses {
        string statusName;
        address[] projects;
    }

    Statuses completedProjects;
    Statuses appliedProjects;
    Statuses currentProjects;
    string Talents;
    
    constructor() public {

    }

}
