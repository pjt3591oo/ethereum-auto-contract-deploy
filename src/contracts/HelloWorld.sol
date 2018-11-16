pragma solidity ^0.4.24;

contract ERC20TokenComplete {

    string public constant name = "Park Jeong Tae";
    string public constant symbol = "PJT";
    uint8 public constant decimals = 0;

    uint256 public totalSupply ;

    mapping(address => uint256) public balanceOf;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Burn(address indexed from, uint256 value);

    address owner; 

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    constructor (
        uint256 _totalSupply
    ) public {
        owner = msg.sender;
        totalSupply = _totalSupply * 10 ** uint256(decimals);
        balanceOf[msg.sender] = totalSupply;
        emit Transfer(address(this), msg.sender, totalSupply);
        assert(true);
    }

    function transfer(address to, uint amount)  public returns(bool) {
        require(balanceOf[msg.sender] >= amount); 
        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;
        emit Transfer(msg.sender, to, amount);
    }

    function burn(uint amount) onlyOwner public {
        require(totalSupply >= amount); 
        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;
        emit Burn(msg.sender, amount);
    }

    function addPublish(uint amount) onlyOwner public{
        totalSupply += amount * 10 ** uint(decimals); 
        balanceOf[msg.sender] +=  amount * 10 ** uint(decimals);
    }
}
