// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract Structs {
  struct Car {
    string model;
    uint256 year;
    address owner;
  }

  Car public car;
  Car[] public cars;

  mapping(address => Car[]) public carsByOwner;

  function examples() external {
    Car memory toyota = Car("Toyota", 1998, msg.sender);
    Car memory lambo = Car({year: 1980, model: "Lamborghini", owner: msg.sender});
    Car memory tesla;
    tesla.model = "Tesla";
    tesla.year = 2010;
    tesla.owner = msg.sender;

    cars.push(toyota);
    cars.push(lambo);
    cars.push(tesla);
    cars.push(Car({model: "Ferrari", year: 1950, owner: msg.sender}));

    Car storage toyotaReference = cars[0];
    toyotaReference.year = 1990;

    for (uint256 i = 0; i < cars.length; ++i) {
      carsByOwner[cars[i].owner].push(cars[i]);
    }
  }
}
