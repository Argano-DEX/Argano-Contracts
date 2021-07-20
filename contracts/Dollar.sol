// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./interfaces/IDollar.sol";
import "./interfaces/ITreasury.sol";
// import "./utilityContracts/ERC20Custom.sol";

contract Dollar is ERC20, IDollar, Ownable {
    address public treasury;
    bool private genesisSupplyMinted = false;
    uint256 public genesisSupply;

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
        address _treasury,
        uint256 _genesisSupply
    )
        ERC20(_name, _symbol)
    {
        setTreasuryAddress(_treasury);
        genesisSupply = _genesisSupply;
    }
    
        
    function mintGenesisSupply() external onlyOwner {
        require(!genesisSupplyMinted, "genesisSupplyAlreadyMinted");
        genesisSupplyMinted = true;
        _mint(msg.sender, genesisSupply);// mint 1 time requiered amount for allocation
        emit DollarMinted(address(this), msg.sender, genesisSupply);
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
