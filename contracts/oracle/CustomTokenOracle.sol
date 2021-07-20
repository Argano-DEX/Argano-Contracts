// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "../interfaces/IPairOracle.sol";
import "../interfaces/IOracle.sol";


contract CustomTokenOracle is Ownable, IOracle {
    address public customToken;
    address public oracleCustomTokenCollateral;
    IPairOracle customToken_collateral;
    AggregatorV3Interface public priceFeed;
    uint8 public decimals;

    uint256 private constant PRICE_PRECISION = 1e18;

    constructor(
        address _customToken,
        IPairOracle _oracleCustomTokenCollateral,//pairOracle
        address _chainlinkCollateralUsd
    ){
        customToken = _customToken;
        customToken_collateral = _oracleCustomTokenCollateral;
        priceFeed = AggregatorV3Interface(_chainlinkCollateralUsd);
        decimals = priceFeed.decimals();
    }

    function consult() external view override returns (uint256) {
        uint256 _priceCustomTokenCollateral = customToken_collateral.consult(customToken, PRICE_PRECISION);
        return priceCollateralUsd() * _priceCustomTokenCollateral / PRICE_PRECISION;
    }
    
    function updateIfRequiered() external override{
        customToken_collateral.updateIfRequiered();
    }

    function priceCollateralUsd() internal view returns (uint256) {
        (, int256 _price, , , ) = priceFeed.latestRoundData();
        return uint256(_price) * PRICE_PRECISION / (uint256(10)**decimals);
    }

    function setOracleCustomTokenCollateral(address _oracleCustomTokenCollateral) external onlyOwner {
        oracleCustomTokenCollateral = _oracleCustomTokenCollateral;
    }
}
