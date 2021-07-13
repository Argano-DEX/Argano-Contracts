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



contract DollarOracle is Ownable, IOracle {
    address public dollar;
    address public oracleAGOUSDUSDT;
    address public chainlinkUsdtUsd = 0x0A6513e40db6EB1b165753AD52E80663aeA50545;

    uint256 private constant PRICE_PRECISION = 1e18;

    constructor(
        address _dollar,
        address _oracleAGOUSDUSDT,
        address _chainlinkUsdtUsd
    ){
        dollar = _dollar;
        oracleAGOUSDUSDT = _oracleAGOUSDUSDT;
        chainlinkUsdtUsd = _chainlinkUsdtUsd;
    }

    function consult() external view override returns (uint256) {
        uint256 _priceUsdtUsd = priceUsdtUsd();
        uint256 _priceAGOUSDUSDT = IPairOracle(oracleAGOUSDUSDT).consult(dollar, PRICE_PRECISION);
        return _priceUsdtUsd * _priceAGOUSDUSDT / PRICE_PRECISION;
    }

    function priceUsdtUsd() internal view returns (uint256) {
        AggregatorV3Interface _priceFeed = AggregatorV3Interface(chainlinkUsdtUsd);
        (, int256 _price, , , ) = _priceFeed.latestRoundData();
        uint8 _decimals = _priceFeed.decimals();
        return uint256(_price) * PRICE_PRECISION / (uint256(10)**_decimals);
    }

    function setchainlinkUsdtUsd(address _chainlinkUsdtUsd) external onlyOwner {
        chainlinkUsdtUsd = _chainlinkUsdtUsd;
    }

    function setOracleAGOUSDUSDT(address _oracleAGOUSDUSDT) external onlyOwner {
        oracleAGOUSDUSDT = _oracleAGOUSDUSDT;
    }
}
