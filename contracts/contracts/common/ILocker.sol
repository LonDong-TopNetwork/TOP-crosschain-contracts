// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8;

interface ILocker {
    function lockToken(address fromToken, uint64 toChainId, uint256 amount, address receiver) external;
    function unlockToken(bytes memory proofData, uint64 proofBlockHeight) external;
}
