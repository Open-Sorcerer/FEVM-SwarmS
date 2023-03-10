// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./DataDAO.sol";

contract DataDoaFactory{
    // factory contract owner
    address public immutable dataDaoFactoryOwner;

    // number of DataDAO created
    uint256 public numOfDataDao;

    // owner address will be used check which address own/create a new dataDAO
    // mapping(ownerAddress => smart contract address)
    mapping(address => address[]) public searchByAddress;

    /**
     * @dev constructor to get the owner address of this contract factory
     */
    constructor(address _dataDaoFactoryOwner) {
        dataDaoFactoryOwner = _dataDaoFactoryOwner;
    }

    /**
     * @dev function to create the contract DATADAO
     * @param _dataDaoOwner = address of DATADAO owner
     */
    function createDataDao(address _dataDaoOwner) public {
        DataDAO dataDao = new DataDAO(
            _dataDaoOwner
        );
        // Increment the number of DataDao
        numOfDataDao++;

        // search the profile by using owner address
        searchByAddress[_dataDaoOwner].push(address(dataDao));
    }

     /**
      * @dev = function to withdraw the fund from contract factory to dataDaoFactoryOwner
      * @param _amount = amount user want to withdraw
      */
    function withdraw(uint256 _amount) external payable {
        require(msg.sender == dataDaoFactoryOwner, "ONLY_ONWER_CAN_CALL_FUNCTION");
        // sending money to contract owner
        require(address(this).balance >= _amount, "not_enough_funds");
        (bool success, ) = dataDaoFactoryOwner.call{value: _amount}("");
        require(success, "TRANSFER_FAILED");
    }

    
    // Getter Function
    // get the balance of the contract
    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }

    // get the total Number of Data DAOs
    function getNumOfDataDao() public view returns (uint256) {
        return numOfDataDao;
    }

    // get the address of factory contract
    function getAddressOfFactoryContract() public view returns (address) {
        return address(this);
    }

    // get the address of DataDaoFactory contract owner
    function getAddressOfDataDaoFactoryOwner() public view returns (address) {
        return dataDaoFactoryOwner;
    }

    // get all the DataDAO addresses deployed by this address
    function getSearchByAddress(address _address) public view returns(address[] memory){
        return searchByAddress[_address];
    }

    // receive function is used to receive Ether when msg.data is empty
    receive() external payable {}

    // Fallback function is used to receive Ether when msg.data is NOT empty
    fallback() external payable {}
}