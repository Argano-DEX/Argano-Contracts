// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

interface IOracle {
    function consult() external view returns (uint256);
}

interface IPairOracle {
    function consult(address token, uint256 amountIn) external view returns (uint256 amountOut);
    function update() external;
}

contract CustomTokenOracle is Ownable, IOracle {
    address public customToken;
    address public oracleCustomTokenCollateral;
    AggregatorV3Interface public priceFeed;
    uint8 public decimals;

    uint256 private constant PRICE_PRECISION = 1e18;

    constructor(
        address _customToken,
        address _oracleCustomTokenCollateral,//pairOracle
        address _chainlinkCollateralUsd
    ){
        customToken = _customToken;
        oracleCustomTokenCollateral = _oracleCustomTokenCollateral;
        priceFeed = AggregatorV3Interface(_chainlinkCollateralUsd);
        decimals = priceFeed.decimals();
    }

    function consult() external view override returns (uint256) {
        uint256 _priceCustomTokenCollateral = IPairOracle(oracleCustomTokenCollateral).consult(customToken, PRICE_PRECISION);
        return priceCollateralUsd() * _priceCustomTokenCollateral / PRICE_PRECISION;
    }

    function priceCollateralUsd() internal view returns (uint256) {
        (, int256 _price, , , ) = priceFeed.latestRoundData();
        return uint256(_price) * PRICE_PRECISION / (uint256(10)**decimals);
    }

    function setOracleCustomTokenCollateral(address _oracleCustomTokenCollateral) external onlyOwner {
        oracleCustomTokenCollateral = _oracleCustomTokenCollateral;
    }
}
