// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./AbstractCalculator.sol";

contract Calculator is AbstractCalculator {
    struct LastResult {
        uint256 a;
        uint256 b;
        uint256 result;
        string operation;
    }

    mapping(address => LastResult[]) public history;

    event Calculate(uint256 result);

    function calculate(uint256 a, uint256 b, string memory operation) public {
        uint256 result;

        if (keccak256(bytes(operation)) == keccak256(bytes("add"))) {
            result = add(a, b);
        } else if (
            keccak256(bytes(operation)) == keccak256(bytes("subtract"))
        ) {
            result = subtract(a, b);
        } else if (
            keccak256(bytes(operation)) == keccak256(bytes("multiply"))
        ) {
            result = multiply(a, b);
        } else if (keccak256(bytes(operation)) == keccak256(bytes("divide"))) {
            result = divide(a, b);
        } else {
            revert("Invalid operation");
        }

        history[msg.sender].push(LastResult(a, b, result, operation));
        emit Calculate(result);
    }

    function getLastResult(
        address user
    ) public view returns (LastResult memory) {
        require(history[user].length > 0, "No calculation history");
        return history[user][history[user].length - 1];
    }

    function getHistoryItem(
        address user
    ) public view returns (LastResult[] memory) {
        require(history[user].length > 0, "No calculation history");
        return history[user];
    }

    function getHistoryLength(address user) public view returns (uint256) {
        return history[user].length;
    }
}
