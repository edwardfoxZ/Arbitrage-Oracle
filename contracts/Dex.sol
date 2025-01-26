// SPDX-License-Identifier: MIT
// Tells the Solidity compiler to compile only from v0.8.13 to v0.9.0
pragma solidity ^0.8.13;

contract Dex {
    mapping(string => uint) private prices;

    function getPrice(string calldata _sticker) external view returns (uint) {
        return prices[_sticker];
    }

    function sell(
        string calldata _sticker,
        uint _amount,
        uint _prices
    ) external {
        //Buy ERC20
    }

    function buy(
        string calldata _sticker,
        uint _amount,
        uint _prices
    ) external {
        //Sell ERC20
    }
}
