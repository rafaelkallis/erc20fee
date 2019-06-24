pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "./ERC20Fee.sol";

/**
 * @title ERC20BurnFee
 */
contract ERC20BurnFee is ERC20Fee, ERC20Burnable {
  using SafeMath for uint256;

  uint256 private _burnFeeInverse;

  constructor(uint256 burnFeeInverse) public {
    require(burnFeeInverse > 0, "ERC20BurnFee: burnFeeInverse is 0");
    _burnFeeInverse = burnFeeInverse;
  }

  function burn(uint256 amount) public {
    super.burn(amount);
    uint256 feeAmount = amount.div(_burnFeeInverse);
    _chargeFee(msg.sender, feeAmount);
  }
  
  function burnFrom(address account, uint256 amount) public {
    super.burnFrom(account, amount);
    uint256 feeAmount = amount.div(_burnFeeInverse);
    _chargeFee(account, feeAmount);
    _approve(account, msg.sender, allowance(account, msg.sender).sub(feeAmount));
  }

  function burnFeeInverse() public view returns (uint256) {
    return _burnFeeInverse;
  }
}
