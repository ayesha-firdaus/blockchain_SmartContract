// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

interface IERC20{
    function totalSupply() external view returns(uint256);
    function balanceOf(address account) external view returns(uint256);
    function transfer(address recipient,uint256 amount) external returns(bool);
     event Transfer(address indexed from,address indexed to,uint256 amount);

}
contract CGCToken is IERC20{
    string public name;
    string public  symbol;
    uint8 public  decimal;
    event Approval(address indexed Owner,uint amount,address indexed spender);
  
    mapping(address=>uint256) public balances;
    mapping(address=>mapping(address=>uint256)) public allowed;
   address owner;
   uint  totalsupply;
   constructor(string memory _name,string memory _symbol,uint8 _decimal,uint _totalsupply){
    owner=msg.sender;
      totalsupply=_totalsupply;
     balances[owner]=totalsupply;
     name=_name;
     symbol=_symbol;
     decimal=_decimal;
   
   }
   modifier onlyOwner(){
    require(msg.sender==owner,"Unauthorized Access");
    _;
   }
   function totalSupply() external view returns(uint256){
    return totalsupply;
   }
   function balanceOf(address account) external view returns(uint256){
    return balances[account];
   }
   function transfer(address  recipient,uint256 amount) public  returns(bool){
    require(amount <= balances[msg.sender],"Insufficient balances aborting ");
    balances[msg.sender]-=amount;
    balances[recipient]+=amount;
    emit Transfer(msg.sender, recipient, amount);
    return true;
   } 
   function mint(uint256 quantity) public onlyOwner returns(uint256) {
    totalsupply+=quantity;
    balances[msg.sender]+=quantity;
    return totalsupply;
   }
   function burn(uint256 quantity) public onlyOwner returns(uint256){
    require(balances[msg.sender]>quantity,"Insufficient balance ");
    totalsupply-=quantity;
    balances[msg.sender]-=quantity;
    return totalsupply;
   }
   function approval(address spender,uint amount) public returns (bool){
    allowed[msg.sender][spender]=amount;
        emit Approval(msg.sender,amount,spender);
        return true;

   }
   function transferFrom(address from,address to,uint value) public returns(bool){
    uint256 allowanceMoney=allowed[from][msg.sender];
    require(balances[from]>=value&&allowanceMoney>=value);
    balances[from]-=value;
    balances[msg.sender]+=value;
    allowed[from][msg.sender]-=value;
    emit Transfer(from,to,value);

    return true;
    
   }
   function Allowance(address from,address to) public view  returns(uint256)
   {
    return allowed[from][to];
   }


}