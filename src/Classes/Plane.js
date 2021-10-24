export class Plane{
  weapons = [];
  constructor(type, tail, id){
    this.type = type;
    this.tail = tail;
    this.id = id;
  }

  getData()  {

  }

  assignPilot(pilot){
    this.pilot = pilot;
  }

  getPilot(){
    return this.pilot.name;
  }

  addWeapon(weapon){
    this.weapons.push(weapon);
  }
}