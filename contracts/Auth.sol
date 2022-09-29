pragma solidity ^0.8.16;

// SPDX-License-Identifier: MIT

contract Auth {

  enum Roles { Owner, Admin }

  struct Admin {
    bool enable;
    Roles role;
  }

  struct AdminRole {
    address adrs;
    Roles role;
  }

  mapping (address => Admin) private admins;
  address[] private keys;

  address private ownerContract;

  constructor() {
    ownerContract = msg.sender;
    admins[msg.sender] = Admin(true, Roles(0));
    keys.push(msg.sender);
  }

  function setOwnerContract(address _address) public {
    require(ownerContract == msg.sender, "you are not owner contract");

    if (!admins[_address].enable) {
      admins[_address] = Admin(true, admins[_address].role);
    }

    ownerContract = _address;
  }

  function getAdmin(address _address) public view returns(Roles){
    require(admins[msg.sender].enable && admins[msg.sender].role == Roles(0), "you are not owner");
    require(admins[_address].enable, "admin not found");
    return admins[_address].role;
  }

  function getAllAdmins() external view returns(AdminRole[] memory) {
    require(admins[msg.sender].enable && admins[msg.sender].role == Roles(0), "you are not owner");
    AdminRole[] memory allAdmins = new AdminRole[](keys.length);

    uint counter = 0;
    for(uint i = 0; i < keys.length; i++) {
      if (admins[keys[i]].enable) {
        AdminRole memory admin;
        admin.adrs = keys[i];
        admin.role = admins[keys[i]].role;

        allAdmins[counter] = admin;
        counter++;
      }
    }

    return allAdmins;
  }

  function add(address _address, Roles role) public {
    require(admins[msg.sender].enable && admins[msg.sender].role == Roles(0), "you are not owner");
    require(!admins[_address].enable, "admin already exists");

    admins[_address] = Admin(true, role);

    bool exist;
    for (uint i = 0; i < keys.length; i++) {
      if (keys[i] == _address) {
        exist = true;
      }
    }

    if (!exist) {
      keys.push(_address);
    }
  }

  function dlt(address _address) public {
    require(admins[msg.sender].enable && admins[msg.sender].role == Roles(0), "you are not admin");
    require(ownerContract != _address, "cannot delete owner contract");

    if(admins[_address].enable) {
      admins[_address].enable = false;
      admins[_address].role = Roles(0);
    }
  }

  function updateRole(address _addres, Roles role) public {
    require(admins[msg.sender].enable && admins[msg.sender].role == Roles(0), "you are not admin");
    require(admins[_addres].enable, "admin not found");
    require(admins[_addres].role != Roles(role), "admin already has this role");

    admins[_addres].role = Roles(role);
  }

  function splitSignature(bytes memory sig)
    pure
    internal
    returns (uint8 v, bytes32 r, bytes32 s)
  {
    require(sig.length == 65 , "invalid length");

    assembly {
      r := mload(add(sig, 32))
      s := mload(add(sig, 64))
      v := byte(0, mload(add(sig, 96)))
    }
    if (v < 27) {
      v += 27;
    }

    require(v == 27 || v == 28 , "value of v ");
    return (v, r, s);
  }

  function recoverSigner(bytes32 message, bytes memory sig)
    internal
    pure
    returns (address)
  {
    (uint8 v, bytes32 r, bytes32 s) = splitSignature(sig);
    return ecrecover(message, v, r, s);
  }

  function auth(address _address, bytes32 message, bytes memory sig) external view returns(Roles) {
    address signAddress = recoverSigner(message, sig);

    require(signAddress == _address, 'invalid signature');
    require(admins[signAddress].enable, 'address not found');
    return admins[signAddress].role;
  }
}
