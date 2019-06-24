pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "./ERC20FeeCollect.sol";

/**
 * @title ERC20SoleOwnerFeeCollect
 */
contract ERC20SoleOwnerFeeCollect is ERC20FeeCollect, Ownable {

  function collectFees() external onlyOwner {
    ERC20._transfer(
      address(this),
      msg.sender,
      balanceOf(address(this))
    );
    emit FeesCollected(msg.sender, balanceOf(address(this)));
  }
}
