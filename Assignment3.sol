// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "IERC20.sol";
import "Context.sol";
import "IERC20Metadata.sol";


contract AssignmentToken is Context, IERC20, IERC20Metadata {
    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;
     address payable owner;
      uint price;
    
    string private _name;
    string private _symbol;

    event Valuerecieved(address _sender, uint _amount);
    

    modifier onlyOwner() {
        require (msg.sender == owner, "you are not the owner");
        _;
    }


     constructor() {
       _name = "BlockChain Assignment Token" ;
       _symbol = "BAT";
       _totalSupply = 100000;
        owner = payable (msg.sender);
        _balances[owner] = _totalSupply;
    }

 function buytoken(address _seller, address _buyer) public payable returns (uint, uint, string memory) {
   
    price = 1 * 10 ** 16;
   
    require(msg.value % price == 0, "price of 1 token is 1 * 10 ** 16 wei,amount you provided is not exact multiple of unit price");
    require(_buyer != address(0) && _seller != address(0),"not a valid buyer/seller");
    require(msg.value >= price, "insufficient amount" );
    
    uint tokencount = msg.value / price;
    _balances[_buyer] += tokencount;
    _balances[_seller] -= tokencount;
    
    return  (_balances[_seller], _balances[_buyer], "transfer of token from seller to buyer");

    }
    // TASK 2
     fallback() external payable{
        emit Valuerecieved(msg.sender, msg.value);
    }
    
    // TASK 3
   function pricesetting(uint _newprice) public  onlyOwner() returns(string memory) {
     
     price = _newprice;
     
     return "price adjusted";
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view virtual override returns (string memory) {
        return _name;
    }

   
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    function decimals() public view virtual override returns (uint8) {
        return 18;
    }

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account) public view virtual override onlyOwner returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) public virtual override onlyOwner returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {IERC20-approve}.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount) public virtual override onlyOwner returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

 
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);

        uint256 currentAllowance = _allowances[sender][_msgSender()];
        require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
        unchecked {
            _approve(sender, _msgSender(), currentAllowance - amount);
        }

        return true;
    }


    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        uint256 currentAllowance = _allowances[_msgSender()][spender];
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
        unchecked {
            _approve(_msgSender(), spender, currentAllowance - subtractedValue);
        }

        return true;
    }


    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(sender, recipient, amount);

        uint256 senderBalance = _balances[sender];
        require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
        unchecked {
            _balances[sender] = senderBalance - amount;
        }
        _balances[recipient] += amount;

        emit Transfer(sender, recipient, amount);

        _afterTokenTransfer(sender, recipient, amount);
    }

  
    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}


    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}
}



