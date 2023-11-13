pragma solidity >=0.4.21 <0.9.0;


import "./loyalty_token.sol";


//*******************
//Main Contract code
//*******************

contract loyalty_program{

	address private admin;

    // Customer Data 
    struct Csmer {
        address cusAd;
        string firstName;
        string email;
        bool isReg;
        mapping(address => bool) bus;
	}
    
	// Business Data
    struct Bns {
        address busAd;
        string name;
        string email;
        bool isReg;
        loyalty_token lt;
        mapping(address => bool) cus;
        mapping(address => bool) bs;
        mapping(address => uint256) rate;
	}
	constructor(){
		admin = msg.sender;
	}
	mapping(address => Csmer) public Cstmrs;
	mapping(address => Bns) public Bsn;

    // Business Registration
	function busReg(string memory _bsName, string memory _email, address _addBus, string memory _symbol, uint8 _decimal) public  {
		require(msg.sender == admin);
		require(!Cstmrs[_addBus].isReg, "Customer Registered");
		require(!Bsn[_addBus].isReg, "Business Registered");
		uint y = new Data() + (30*24)hrs;
		loyalty_token _newcon = new loyalty_token(_addBus, _bsName, _symbol, _decimal,30);
		Bns storage bd =  Bsn[_addBus];
        bd.name=_bsName;
		bd.busAd = _addBus;
		bd.lt = _newcon;
        bd.email = _email;
		uint256 x = 10000;
		bd.isReg = true;
		Bsn[_addBus].lt.mint(_addBus, x);
	}

	// Reward for Customer
    function rewardd(address _addCus, uint256 _points,address _addBus) public{
		require(Bsn[_addBus].isReg, "This is not a valid business account");
		require(Cstmrs[_addCus].isReg, "This is not a valid customer account");
		require(Bsn[_addBus].cus[_addCus], "This customer has not joined your business" );
		require(Cstmrs[_addCus].bus[_addBus], "This customer has not joined your business" );
		Bsn[_addBus].lt.transferFrom(_addBus, _addCus, _points);    
	}
    
	// Partner Business Connect & Exchange Rate Set
	function busConnect(address _addBus,address _addBus2, uint256 _rate) public{
		require(Bsn[_addBus].isReg, "This is not a valid business account");
		require(Bsn[_addBus2].isReg, "This is not a valid business account");
		Bsn[_addBus2].rate[_addBus] = _rate;
		require(Bsn[_addBus].isReg, "This is not a valid business account");
		Bsn[_addBus2].bs[_addBus] = true;
	}


   // Customer Registration
	function custReg(string memory _firstName, string memory _lastName, string memory _email, address _addCus) public  {
		require(msg.sender == admin);
		require(!Cstmrs[_addCus].isReg, "Customer Registered");
		require(!Bsn[_addCus].isReg, "Business Registered");
		Csmer storage cd = Cstmrs[_addCus];
		cd.cusAd = _addCus;
		cd.firstName = _firstName;
		cd.email = _email;
		cd.isReg = true;
	}

   // Decaying {In Progress}
    function decaying(address _addBus,address _addCus)public {
		require(Bsn[_addBus].isReg, "This is not a valid business account");
		uint256 cc = Bsn[_addBus].lt.balanceOf(_addCus);
	}

    //Customer Detection
	function shwCustomer( address _addCus) public view returns (bool) {
		require(msg.sender == admin);
        return Cstmrs[_addCus].isReg;
	}
    
	// Customer Joining Business
	function busJoin(address _addBus,address _addCus) public{
		require(Cstmrs[_addCus].isReg,"invalid cust");
		require(Bsn[_addBus].isReg, "This is not a valid business account");
		Cstmrs[_addCus].bus[_addBus] = true;
		Bsn[_addBus].cus[_addCus] = true;
	}

    // Customer Redeeming their Token
	function redeem(address from_bus, address to_bus,address _addCus, uint256 _points) public {
		require(Cstmrs[_addCus].isReg, "This is not a valid customer account");
		require(Bsn[from_bus].isReg, "This is not a valid business account");
		require(Bsn[to_bus].isReg, "This is not a valid business account");
		if(from_bus==to_bus){
			Bsn[to_bus].lt.transferFrom(_addCus, to_bus, _points);
		}
		else if(from_bus!=to_bus){
			require(Bsn[from_bus].bs[to_bus], "This is not a valid linked business account");
			require(Bsn[to_bus].bs[from_bus], "This is not a valid linked business account");
			uint256 _r = Bsn[from_bus].rate[to_bus];
			Bsn[from_bus].lt.burnFrom(_addCus, _points);
			Bsn[to_bus].lt.mint(to_bus, _r*_points);
		}
	}

	
    // Customer Wallet/Tokens
    function shwcoins(address _addCus,address _addBus)public view returns (uint256){
		require(Bsn[_addBus].isReg, "This is not a valid business account");
		require(Cstmrs[_addCus].isReg, "This is not a valid customer account");
		require(Bsn[_addBus].cus[_addCus], "This customer has not joined your business" );
        return  Bsn[_addBus].lt.balanceOf(_addCus);
	}


    //Business Tokens
	function shwcoin(address _addBus)public view returns (uint256){
		require(Bsn[_addBus].isReg, "This is not a valid business account");
        return  Bsn[_addBus].lt.balanceOf(_addBus);
	}
    
	

} 