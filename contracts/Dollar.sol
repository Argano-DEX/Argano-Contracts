// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "./interfaces/IDollar.sol";
import "./interfaces/ITreasury.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "./utilityContracts/ERC20Custom.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Dollar is ERC20Custom, IDollar, Ownable {
    // ERC20
    string public  symbol;
    string public  name;
    uint8 public constant  decimals = 18;

    // CONTRACTS
    address public treasury;

    // FLAGS
    bool public initialized;

    /* ========== MODIFIERS ========== */

    modifier onlyPools() {
        require(ITreasury(treasury).hasPool(msg.sender), "!pools");
        _;
    }

    event DollarBurned(address indexed from, address indexed to, uint256 amount);// Track DOLLAR burned
    event DollarMinted(address indexed from, address indexed to, uint256 amount);// Track DOLLAR minted


    constructor(string memory _name,  string memory _symbol, address _treasury){
        name = _name;
        symbol = _symbol;
        treasury = _treasury;
    }

    function initialize(uint256 _genesis_supply) external onlyOwner {
        require(!initialized, "alreadyInitialized");
        initialized = true;
        _mint(_msgSender(), _genesis_supply);//for pool creations
    }

    /* ========== RESTRICTED FUNCTIONS ========== */

    // Burn DOLLAR. Can be used by Pool only
    function poolBurnFrom(address _address, uint256 _amount) external override onlyPools {
        super._burnFrom(_address, _amount);
        emit DollarBurned(_address, msg.sender, _amount);
    }

    // Mint DOLLAR. Can be used by Pool only
    function poolMint(address _address, uint256 _amount) external override onlyPools {
        super._mint(_address, _amount);
        emit DollarMinted(msg.sender, _address, _amount);
    }

    function setTreasuryAddress(address _treasury) public onlyOwner {
        require(_treasury != address(0), 'Zero address passed');
        treasury = _treasury;
    }


}
