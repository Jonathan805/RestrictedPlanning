export class Pilot{
  constructor(id, name){
    this.id = id;
    this.name = name;
  }

  getData()  {
    return this.id + " " + this.name;
  }
}