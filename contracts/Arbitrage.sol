// SPDX-License-Identifier: MIT
// Tells the Solidity compiler to compile only from v0.8.13 to v0.9.0
pragma solidity ^0.8.13;

import "./Dex.sol";
import "./Oracle.sol";

contract Arbitrage {
    struct Asset {
        string name;
        address dex;
    }
    mapping(string => Asset) public assets;
    address public admin;
    address public oracle;

    constructor() {
        admin = msg.sender;
    }

    function configureOracle(address _oracle) external onlyAdmin {
        oracle = _oracle;
    }

    function configureAssets(Asset[] calldata _assets) external onlyAdmin {
        for (uint i = 0; i < _assets.length; i++) {
            assets[_assets[i].name] = Asset(_assets[i].name, _assets[i].dex);
        }
    }

    function maybeTrade(
        string calldata _sticker,
        uint _date
    ) external onlyAdmin {
        Asset storage asset = assets[_sticker];
        require(asset.dex != address(0), "the asset does not exist");

        bytes32 dataKey = keccak256(abi.encodePacked(_sticker, _date));
        Oracle oracleContract = Oracle(oracle);
        Oracle.Result memory result = oracleContract.getData(dataKey);

        require(result.exist == true, "this result does not exist");
        require(
            result.approvedBy == 10,
            "the number of validators are not enough"
        );
    }

    modifier onlyAdmin() {
        require(admin == msg.sender, "only admin");
        _;
    }
}
