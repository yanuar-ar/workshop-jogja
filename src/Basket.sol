// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC20} from "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
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

contract Basket is ERC20 {

  address router = 0xE592427A0AEce92De3Edee1F18E0157C05861564;

  address public usdc = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
  address public weth = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
  address public wbtc = 0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599;

  uint256 public wethPrice = 3150e6;
  uint256 public wbtcPrice = 90_000e6;

  uint256 public constant PROPORTION_SCALED = 1e18;

  constructor() ERC20("Basket", "BSKT") {}

  function totalAssets() public view returns (uint256) {
    uint256 totalAssetWeth = IERC20(weth).balanceOf(address(this)) * wethPrice / 1e18 ;
    uint256 totalAssetWbtc = IERC20(wbtc).balanceOf(address(this)) * wbtcPrice / 1e8 ;

    return totalAssetWeth + totalAssetWbtc;
  }

  function deposit(uint256 amount) public {
    uint256 shares = 0;
    if (totalSupply() == 0) {
      shares = amount;
    } else {
      shares = (amount * totalSupply()) / totalAssets();
    }

    IERC20(usdc).transferFrom(msg.sender, address(this), amount);

    uint256 amountIn = amount/2;
    
    // swap ke weth
    IERC20(usdc).approve(router, amount);
    ISwapRouter.ExactInputSingleParams memory params =
      ISwapRouter.ExactInputSingleParams({
          tokenIn: usdc,
          tokenOut: weth,
          fee: 500,
          recipient: address(this),
          deadline: block.timestamp,
          amountIn: amountIn,
          amountOutMinimum: 0,
          sqrtPriceLimitX96: 0
      });

    ISwapRouter(router).exactInputSingle(params);

    // swap ke wbtc
    params = ISwapRouter.ExactInputSingleParams({
          tokenIn: usdc,
          tokenOut: wbtc,
          fee: 3000,
          recipient: address(this),
          deadline: block.timestamp,
          amountIn: amountIn,
          amountOutMinimum: 0,
          sqrtPriceLimitX96: 0
      });

    ISwapRouter(router).exactInputSingle(params);

    _mint(msg.sender, shares);
  }

  function distributeYield(uint256 amountWeth, uint256 amountWbtc) public {
    IERC20(weth).transferFrom(msg.sender, address(this), amountWeth);
    IERC20(wbtc).transferFrom(msg.sender, address(this), amountWbtc);
  }

  function withdraw(uint256 shares) public {
  
    uint256 proportion = shares * PROPORTION_SCALED / totalSupply();

    uint256 amountWeth = IERC20(weth).balanceOf(address(this)) * proportion / PROPORTION_SCALED; 
    uint256 amountWbtc = IERC20(wbtc).balanceOf(address(this)) * proportion / PROPORTION_SCALED;

    // swap weth ke usdc
    IERC20(weth).approve(router, amountWeth);
    ISwapRouter.ExactInputSingleParams memory params =
      ISwapRouter.ExactInputSingleParams({
          tokenIn: weth,
          tokenOut: usdc,
          fee: 500,
          recipient: address(this),
          deadline: block.timestamp,
          amountIn: amountWeth,
          amountOutMinimum: 0,
          sqrtPriceLimitX96: 0
      });

   uint256 amountOut = ISwapRouter(router).exactInputSingle(params);

    // swap wbtc ke usdc
    IERC20(wbtc).approve(router, amountWbtc);
    params = ISwapRouter.ExactInputSingleParams({
          tokenIn: wbtc,
          tokenOut: usdc,
          fee: 3000,
          recipient: address(this),
          deadline: block.timestamp,
          amountIn: amountWbtc,
          amountOutMinimum: 0,
          sqrtPriceLimitX96: 0
      });

    amountOut += ISwapRouter(router).exactInputSingle(params);

    _burn(msg.sender, shares);

    IERC20(usdc).transfer(msg.sender, amountOut);
  }
}


