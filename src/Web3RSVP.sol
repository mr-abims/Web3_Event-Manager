// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Web3RSVP {
    struct CreateEvent {
        bytes32 eventId;
        string eventDataCID;
        address eventOwner;
        uint256 eventTimestamp;
        uint256 deposit;
        uint256 maxCapacity;
        address[] confirmedRSVPs;
        address[] claimedRSVPs;
        bool paidOut;
    }

    mapping(bytes32 => CreateEvent) public idToEvent;

    function createNewEvent(
        uint256 eventTimestamp,
        uint256 deposit,
        uint256 maxCapacity,
        string calldata eventDataCID
    ) external {
        // generate an eventID based on other things passed in to generate a hash
        bytes32 eventId = keccak256(
            abi.encodePacked(
                msg.sender,
                address(this),
                eventTimestamp,
                deposit,
                maxCapacity
            )
        );

        address[] memory confirmedRSVPs;
        address[] memory claimedRSVPs;

        // this creates a new CreateEvent struct and adds it to the idToEvent mapping
        idToEvent[eventId] = CreateEvent(
            eventId,
            eventDataCID,
            msg.sender,
            eventTimestamp,
            deposit,
            maxCapacity,
            confirmedRSVPs,
            claimedRSVPs,
            false
        );
    }
    function createNewRSVP(bytes32 eventId) external payable {
    // look up event from our mapping
    CreateEvent storage myEvent = idToEvent[eventId];

    // transfer deposit to our contract / require that they send in enough ETH to cover the deposit requirement of this specific event
    require(msg.value == myEvent.deposit, "NOT ENOUGH");

    // require that the event hasn't already happened (<eventTimestamp)
    require(block.timestamp <= myEvent.eventTimestamp, "ALREADY HAPPENED");

    // make sure event is under max capacity
    require(
        myEvent.confirmedRSVPs.length < myEvent.maxCapacity,
        "This event has reached capacity"
    );

    // require that msg.sender isn't already in myEvent.confirmedRSVPs AKA hasn't already RSVP'd
    for (uint8 i = 0; i < myEvent.confirmedRSVPs.length; i++) {
        require(myEvent.confirmedRSVPs[i] != msg.sender, "ALREADY CONFIRMED");
    }

    myEvent.confirmedRSVPs.push(payable(msg.sender));

}
}
