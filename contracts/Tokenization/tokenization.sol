pragma solidity ^0.4.23;

import "../permission/PermissionProviderInterface.sol";
// import "./TokenizationIndexInterface.sol";
import "../libs/SafeMath.sol";
import "./fundtemplate.sol";


contract TokenizationIndex {
    
    using SafeMath for uint256;
    
    //Permission Control
    PermissionProviderInterface internal permissionProvider;


    //modifier
    modifier onlyCore() {
        require(permissionProvider.has(msg.sender, permissionProvider.ROLE_CORE()));
        _;
    }

    modifier onlyWhitelist() {
        require(permissionProvider.has(msg.sender, permissionProvider.ROLE_CORE()));
        _;
    }
    //event
    event TransferOwnerShip(uint _fundindex, address _newowner);

    //status
    uint Fundlength;


    //mapping

    mapping (uint => address) public FundIndex;
    mapping (uint => address) public FundOwner;

    //function 

    function TokenizationIndex(address _permissionProvider) public {
        permissionProvider = PermissionProviderInterface(_permissionProvider);
    }


    //Create
    function CreatFUND(
        string _name,
        string _description,
        string _category,
        address[] memory _tokenAddresses,
        uint[] memory _weights,
        uint _withdrawcycle
    ) public 
    returns (address FundID) 
    {
        require(_checkLength(_tokenAddresses, _weights));
        Fund = new fundtemplate(Fundlength,_name,  _description, _category, _tokenAddresses, _weights, _withdrawcycle);
        FundOwner[Fundlength] = tx.origin;
        fundIndex[Fundlength] = Fund;
        Fundlength += 1;
        return Fund;
    }




    //Get
    function getFUND(uint _FundIndex) public returns(
        string _name,
        string _description,
        string _category,
        address[] memory _tokenAddresses,
        uint[] memory _weights,
        uint _withdrawcycle
    ){
        require(_FundIndex<=Fundlength);


    }

    function transferOwnership(uint _FundIndex, address _newOwner) public returns(bool success){
        require(FundOwner[_FundIndex] == tx.origin);
        FundOwner[_FundIndex] = _newOwner;
        fundtemplate _fundtemplate;
        _fundtemplate = fundtemplate(FundIndex[_FundIndex]);
        _fundtemplate.transferOwnership(_newOwner);

    }


    function _checkLength(address[] _tokenAddresses,uint[] _weights) internal returns(bool success){
        require(_tokenAddresses.length == _weights.length);
        uint total = 0;
        for (uint i = 0; i < _weights.length; ++i) {
            total += _weights[i];
        }
        return (total <= 100&&total > 0);
    }
}