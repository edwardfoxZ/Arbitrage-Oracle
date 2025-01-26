// SPDX-License-Identifier: MIT
// Tells the Solidity compiler to compile only from v0.8.13 to v0.9.0
pragma solidity ^0.8.13;

contract Oracle {
    struct Result {
        bool exist;
        uint payload;
        address[] approvedBy;
    }
    mapping(bytes32 => Result) public results;
    address[] public validators;

    constructor(address[] memory _validators) {
        validators = _validators;
    }

    function feedData(bytes32 dataKey, uint payload) external onlyValidators {
        address[] memory _approvedBy = new address[](1);
        _approvedBy[0] = msg.sender;
        require(
            results[dataKey].exist == false,
            "this data was already imported before"
        );
        results[dataKey] = Result(true, payload, _approvedBy);
    }

    function approvedData(bytes32 _dataKey) external onlyValidators {
        Result storage result = results[_dataKey];
        require(result.exist == true, "cannot approve  non-existing data");

        for (uint i = 0; i < result.approvedBy.length; i++) {
            require(
                result.approvedBy[i] != msg.sender,
                "cannot approve who already approved"
            );
        }
        result.approvedBy.push(msg.sender);
    }

    function getData(bytes32 _dataKey) external view virtual returns (Result memory) {
        return results[_dataKey];
    }

    modifier onlyValidators() {
        bool isValidator = false;
        for (uint i = 0; i < validators.length; i++) {
            if (validators[i] != msg.sender) {
                isValidator = true;
            }
        }
        require(isValidator == true, "only validators");
        _;
    }
}
