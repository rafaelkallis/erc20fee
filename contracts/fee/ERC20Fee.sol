pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";

/**
 * @title ERC20Fee
 */
contract ERC20Fee is ERC20 {

  mapping (uint256 => uint256[]) private _blockFees;

  function _chargeFee(address account, uint256 amount) internal {
    _transfer(account, address(this), amount);
    _blockFees[block.number].push(amount);
    emit FeeCharged(account, amount);
  }

  function blockFees(uint256 blocknumber) public view returns (uint256[] memory) {
    return _blockFees[blocknumber];
  }

  function pendingFees() public view returns (uint256) {
    return balanceOf(address(this));
  }

  // function _computeFees(uint256 amount, uint256 feeInverse) internal pure returns (uint256) {
  //   return amount.div(feeInverse);
  // }

  event FeeCharged(address indexed account, uint256 amount);
}
