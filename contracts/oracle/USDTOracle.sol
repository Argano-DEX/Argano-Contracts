// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract USDTOracle is Ownable{
    address public chainlinkUSDTUsd = 0x0A6513e40db6EB1b165753AD52E80663aeA50545;
    uint256 private constant PRICE_PRECISION = 1e6;

    function consult() external view returns (uint256) {
        AggregatorV3Interface _priceFeed = AggregatorV3Interface(chainlinkUSDTUsd);
        (, int256 _price, , , ) = _priceFeed.latestRoundData();
        uint8 _decimals = _priceFeed.decimals();
        return uint256(_price) * (PRICE_PRECISION) / (uint256(10)**_decimals);
    }

    function setChainlinkUsdtUsd(address _chainlinkUSDTUsd) external onlyOwner {
        chainlinkUSDTUsd = _chainlinkUSDTUsd;
    }
}