// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
// import "hardhat/console.sol";

contract AdminControlledUpgradeable is Initializable,AccessControl {
    address private admin;
    uint private paused;

    bytes32 constant public CONTROLLED_ROLE = keccak256("CONTROLLED_ROLE");
    bytes32 constant public OWNER_ROLE = keccak256("OWNER_ROLE");
    bytes32 constant public WITHDRAWAL_ROLE = keccak256("WITHDRAWAL_ROLE");

    function _AdminControlledUpgradeable_init(address _admin, uint flags) internal onlyInitializing {
        admin = _admin;
        paused = flags;
    }

    modifier onlyAdmin {
        require(msg.sender == admin);
        _;
    }

    modifier pausable(uint flag) {
        require((paused & flag) == 0 || msg.sender == admin);
        _;
    }

    
    modifier pausable1(uint flag,bytes32 role) {
        require((paused & flag) == 0 || hasRole(role,msg.sender));
        _;
    }

    function adminPause(uint flags) public onlyAdmin {
        paused = flags;
    }

    function adminSstore(uint key, uint value) public onlyAdmin {
        assembly {
            sstore(key, value)
        }
    }

    function adminSstoreWithMask(
        uint key,
        uint value,
        uint mask
    ) public onlyAdmin {
        assembly {
            let oldval := sload(key)
            sstore(key, xor(and(xor(value, oldval), mask), oldval))
        }
    }

    function adminSendEth(address payable destination, uint amount) public onlyAdmin {
        destination.transfer(amount);
    }

    // function adminReceiveEth() public payable onlyAdmin {}

    function adminDelegatecall(address target, bytes memory data) public payable onlyAdmin returns (bytes memory) {
        (bool success, bytes memory rdata) = target.delegatecall(data);
        require(success);
        return rdata;
    }
}
