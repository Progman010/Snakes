class Game {
    ArrayList<Unit> units = new ArrayList<Unit>();
    void init(int segmentsQty){
      units.add(new Unit(segmentsQty));
    }
    
    int qty() {
      return units.size();
    }
    
    void separate(int xS, int yS){
      Unit rmUnit = new Unit(0);
      int index = 0;
      boolean rm = false;
      for(Unit unit : units){
        index = unit.separateIndex(xS, yS);
        if(index!=-1){
          rm = true;
          rmUnit = unit;
          break;
        }
      }
      if(rm){
        if(rmUnit.segmentsQty>12){
          if(index<6) units.add(new Unit(rmUnit, index, false));
          else if(rmUnit.segmentsQty - index <6) units.add(new Unit(rmUnit, index, true));
          else {
            units.add(new Unit(rmUnit, index, true));
            units.add(new Unit(rmUnit, index, false));
          }
          units.remove(rmUnit);
        }
        else {
          units.remove(rmUnit);
        }
      }
    }
    
    void refresh(){
      for(Unit unit : units){
        unit.refresh();
      }
    }
}