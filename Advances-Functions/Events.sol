pragma solidity ^0.8.7;

contract Events {
    //Declare an event which logs and address and a string
    event TestCalled(address sender, string message);

    function test() public {
        //Log an event
        emit TestCalled(msg.sender, "Someone called test()!");
    }
}
