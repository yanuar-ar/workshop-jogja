// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IAggregatorV3 {
    function decimals() external view returns (uint8);

    function description() external view returns (string memory);

    function version() external view returns (uint256);

    function getRoundData(uint80 _roundId)
        external
        view
        returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound);

    function latestRoundData()
        external
        view
        returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound);
}

contract ChainlinkPrice {
    address quoteFeed = 0xF4030086522a5bEEa4988F8cA5B36dbC97BeE88c; // BTC/USD
    address baseFeed = 0x8fFfFfd4AfB6115b954Bd326cbe7B4BA576818f6; // WETH/USD

    function getPrice() public view returns (uint256) {
        (, int256 quotePrice,,,) = IAggregatorV3(quoteFeed).latestRoundData();
        (, int256 basePrice,,,) = IAggregatorV3(baseFeed).latestRoundData();
        return uint256(quotePrice) * 1e6 / uint256(basePrice);
    }

}
