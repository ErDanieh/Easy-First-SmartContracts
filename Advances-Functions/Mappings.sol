pragma solidity ^0.8.0;

contract Mappings {
    //Mapping key address => value uint
    mapping(address => uint256) public myMap;

    function get(address _addr) public view returns (uint256) {
        //The default value of uint is 0
        return myMap[_addr];
    }

    function set(address _addr, uint256 _i) public {
        myMap[_addr] = _i;
    }

    function remove(address _addr) public {
        delete myMap[_addr];
    }
}

contract NestedMapping {
    mapping(address => mapping(uint256 => bool)) public nestedMap;

    function get(address _addr1, uint256 _i) public view returns (bool) {
        return nestedMap[_addr1][_i];
    }

    function set(
        address _addr1,
        uint256 _i,
        bool _boo
    ) public {
        nestedMap[_addr1][_i] = _boo;
    }

    function remove(address _addr1, uint256 _i) public {
        delete nestedMap[_addr1][_i];
    }
}
