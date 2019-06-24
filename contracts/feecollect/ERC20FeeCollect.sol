pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "../fee/ERC20Fee.sol";

/**
 * @title ERC20FeeCollect
 */
contract ERC20FeeCollect is ERC20, ERC20Fee {

  function collectFees() external;

  event FeesCollected(address indexed account, uint256 amount);
}
