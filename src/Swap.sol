// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IERC20} from "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";


interface ISwapRouter {
      struct ExactInputSingleParams {
        address tokenIn;
        address tokenOut;
        uint24 fee;
        address recipient;
        uint256 deadline;
        uint256 amountIn;
        uint256 amountOutMinimum;
        uint160 sqrtPriceLimitX96;
    }

    function exactInputSingle(ExactInputSingleParams calldata params) external payable returns (uint256 amountOut);
}

contract Swap {

  address router = 0xE592427A0AEce92De3Edee1F18E0157C05861564;

  // tokens
  address weth = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
  address pepe = 0x6982508145454Ce325dDbE47a25d4ec3d2311933;

  function swapETHtoPepe(uint256 amountIn, uint256 amountOutMin) public returns (uint256 amountOut) {

    IERC20(weth).transferFrom(msg.sender, address(this), amountIn);
    
    IERC20(weth).approve(router, amountIn);
    ISwapRouter.ExactInputSingleParams memory params =
      ISwapRouter.ExactInputSingleParams({
          tokenIn: weth,
          tokenOut: pepe,
          fee: 3000,
          recipient: msg.sender,
          deadline: block.timestamp,
          amountIn: amountIn,
          amountOutMinimum: amountOutMin,
          sqrtPriceLimitX96: 0
      });

    amountOut = ISwapRouter(router).exactInputSingle(params);

  }

}


