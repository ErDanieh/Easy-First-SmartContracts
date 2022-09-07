pragma solidity ^0.8.0;

contract Enum {
    enum Status{
        Pending,
        Shipped,
        Accepted,
        Rejected,
        Canceled
    }


    Status public status;

    function get()public view returns (Status){
        return status;
    } 

    //Pass uint for input to update the value 
    function set(Status _status)public{
        status = _status;
    }


    //Update value to specific enum numbers
    function cancel() public {
        status = Status.Canceled;
    }
}