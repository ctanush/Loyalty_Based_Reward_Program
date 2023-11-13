pragma solidity >=0.4.21 <0.9.0;

import "./token/ERC20/ERC20Mintable.sol";


contract loyalty_token is ERC20Mintable {
	uint lifespan;
	string private nm;
	uint8 private dc;
	string private sy;
	

    address private admin;

	constructor(address _addBus, string memory _nm, string memory _sy, uint8 _dc,uint _lfsp){
		admin = _addBus;
		nm = _nm;
		sy = _sy;
		lifespan = _lfsp;
		dc = _dc;
	}
}