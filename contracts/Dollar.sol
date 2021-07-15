// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./interfaces/IDollar.sol";
import "./interfaces/ITreasury.sol";
// import "./utilityContracts/ERC20Custom.sol";

contract Dollar is ERC20, IDollar, Ownable {
    address public treasury;
    bool public initialized;

    modifier onlyPools() {
        require(ITreasury(treasury).hasPool(msg.sender), "!pools");
        _;
    }

    event DollarBurned(address indexed from, address indexed to, uint256 amount);// Track DOLLAR burned
    event DollarMinted(address indexed from, address indexed to, uint256 amount);// Track DOLLAR minted
    event NewTreasuryAddress(address treasury);// Track treasury address changes

    constructor(
        string memory _name,  
        string memory _symbol, 
        address _treasury
    )
        ERC20(_name, _symbol)
    {
        setTreasuryAddress(_treasury);
    }

    function initialize(uint256 _genesis_supply) external onlyOwner {
        require(!initialized, "alreadyInitialized");
        initialized = true;
        _mint(msg.sender, _genesis_supply);//for pool creations
    }

    function setTreasuryAddress(address _treasury) public onlyOwner {
        require(_treasury != address(0), 'Zero address passed');
        treasury = _treasury;
        emit NewTreasuryAddress(treasury);
    }

    function poolBurnFrom(address _address, uint256 _amount) external override onlyPools {
        _burn(_address, _amount);
        emit DollarBurned(_address, msg.sender, _amount);
    }

    // Mint DOLLAR. Can be used by Pool only
    function poolMint(address _address, uint256 _amount) external override onlyPools {
        _mint(_address, _amount);
        emit DollarMinted(msg.sender, _address, _amount);
    }
}
