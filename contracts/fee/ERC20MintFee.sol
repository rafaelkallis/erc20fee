pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "./ERC20Fee.sol";

/**
 * @title ERC20MintFee
 */
contract ERC20MintFee is ERC20Fee, ERC20Mintable {
  using SafeMath for uint256;

  uint256 private _mintFeeInverse;

  constructor(uint256 mintFeeInverse) public {
    require(mintFeeInverse > 0, "ERC20MintFee: mintFeeInverse is 0");
    _mintFeeInverse = mintFeeInverse;
  }

  function mint(address account, uint256 amount) public onlyMinter returns (bool) {
    if (!super.mint(account, amount)) {
      return false;
    }
    uint256 feeAmount = amount.div(_mintFeeInverse);
    _chargeFee(account, feeAmount);
  }

  function mintFeeInverse() public view returns (uint256) {
    return _mintFeeInverse;
  }
}
