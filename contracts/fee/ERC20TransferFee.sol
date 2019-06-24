pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "./ERC20Fee.sol";

/**
 * @title ERC20TransferFee
 */
contract ERC20TransferFee is ERC20Fee {
  using SafeMath for uint256;

  uint256 private _transferFeeInverse;

  constructor(uint256 transferFeeInverse) public {
    require(transferFeeInverse > 0, "ERC20TransferFee: transferFeeInverse is 0");
    _transferFeeInverse = transferFeeInverse;
  }

  // function _transfer(address sender, address recipient, uint256 amount) internal {
  //   uint256 feeAmount = sendAmount.div(_transferFeeInverse);
  //   _chargeFee(sender, feeAmount);
  //   super._transfer(sender, recipient, amount.sub(feeAmount));
  // }

  function transfer(address recipient, uint256 amount) public returns (bool) {
    if (!super.transfer(recipient, amount)) {
      return false;
    }
    uint256 feeAmount = amount.div(_transferFeeInverse);
    _chargeFee(msg.sender, feeAmount);
    return true; 
  }
  
  function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
    if (!super.transferFrom(sender, recipient, amount)) {
      return false;
    }
    uint256 feeAmount = amount.div(_transferFeeInverse);
    _chargeFee(sender, feeAmount);
    _approve(sender, msg.sender, allowance(sender, msg.sender).sub(feeAmount));
    return true;
  }

  function transferFeeInverse() public view returns (uint256) {
    return _transferFeeInverse;
  }
}
