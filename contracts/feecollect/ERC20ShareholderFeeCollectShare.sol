pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "openzeppelin-solidity/contracts/math/Math.sol";

/**
 * @title ERC20ShareholderFeeCollectShare
 */
contract ERC20ShareholderFeeCollectShare is ERC20 {

  struct TemporalValue {
    uint256 fromBlock;
    uint256 toBlock;
    uint256 value;
  }

  mapping(address => TemporalValue[]) private _balances;
  TemporalValue[] private _totalSupplies;

  function getRelativeSharesFrom(address account, uint256 fromBlock) 
    external view returns (
      uint256[] memory fromBlocks,
      uint256[] memory toBlocks,
      uint256[] memory balances,
      uint256[] memory totalSupplies
    ) {
      uint256 i_bal = _balances[account].length - 1;
      uint256 i_ts = _totalSupplies.length - 1;
      uint256 minToBlock;
      uint256 maxFromBlock;
      for (uint256 i = 0; i_bal >= 0 && i_ts >= 0; i++) {
        maxFromBlock = Math.max(
          _balances[account][i_bal].fromBlock,
          _totalSupplies[i_ts].fromBlock
        );
        minToBlock = Math.min(
          _balances[account][i_bal].toBlock,
          _totalSupplies[i_ts].toBlock
        );
        fromBlocks[i] = maxFromBlock;
        toBlocks[i] = minToBlock;
        balances[i] = _balances[account][i_bal].value;
        totalSupplies[i] = _totalSupplies[i_ts].value;
        if (maxFromBlock <= fromBlock) {
          fromBlocks[i] = fromBlock;
          break;
        }
        if (_balances[account][i_bal].fromBlock == maxFromBlock) {
          i_bal--;
        }
        if (_totalSupplies[i_ts].fromBlock == maxFromBlock) {
          i_ts--;
        }
      }
    }

  function _transfer(address sender, address recipient, uint256 amount) internal {
    _beforeBalanceUpdate(sender);
    _beforeBalanceUpdate(recipient);
    super._transfer(sender, recipient, amount);
  }

  function _mint(address account, uint256 amount) internal {
    _beforeBalanceUpdate(account);
    _beforeTotalSupplyUpdate();
    super._mint(account, amount);
  }
  
  function _burn(address account, uint256 amount) internal {
    _beforeBalanceUpdate(account);
    _beforeTotalSupplyUpdate();
    super._burn(account, amount);
  }
  
  function _beforeBalanceUpdate(address account) private {
    _balances[account].push(
      TemporalValue(
        _balances[account][_balances[account].length-1].fromBlock,
        block.number,
        balanceOf(account)
      )
    );
  }
  
  function _beforeTotalSupplyUpdate() private {
    _totalSupplies.push(
      TemporalValue(
        _totalSupplies[_totalSupplies.length-1].fromBlock,
        block.number,
        totalSupply()
      )
    );
  }
}
