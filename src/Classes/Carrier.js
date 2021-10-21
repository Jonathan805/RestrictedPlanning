export class Carrier{
  pilots = [];
  planes = [];
  weapons = [];

  constructor(pilots, planes, weapons){
    this.pilots = pilots;
    this.planes = planes;
    this.weapons = weapons;
  }

  getData()  {

  }

  addPilot(pilot)  {
    this.pilots.push(pilot);
  }

  addPlane(plane){
    this.planes.push(plane);
  }

  addWeapon(weapon){
    this.weapons.push(weapon);
  }
}