class GenerateWorld{
  
  private int totalRoom=100;
  private List<Room> rooms = new ArrayList<Room>();
  private int padding = 1;
  private List<Room> corridors = new ArrayList<Room>();
  private List<Room> halls = new ArrayList<Room>();
  GenerateWorld(){
  }
  
  GenerateWorld(List<Room> room, int totalRoom){
    this.rooms = room;
    this.totalRoom = totalRoom;
  }
  
  private PVector getRandomPointInEllipse(int ellipse_width, int ellipse_height) {
    float t = 2*PI*random(0,1);
    float u = random(0,1)+random(0,1);
    float r; 
    if (u > 1) 
      r = 2-u; 
    else 
      r = u; 
    return new PVector(int(ellipse_width*r*cos(t)), int(ellipse_height*r*sin(t)));
  }
  
  private void generateWorld(){
    for(int i=0;i<totalRoom;i++){
      PVector res = getRandomPointInEllipse(50,50);
      float _width = random(10,30);
      float _height = random(10,30);
      makeRoom((int(_width)),(int(_height)),res,i);
      println(rooms.get(i).area);
    }
    separateRooms();
    
    //centerCorridors();
    markMainRooms();
    connectRooms();
    //line(room[5].getCenter().x,room[5].getCenter().y,room[10].getCenter().x,room[10].getCenter().y);
    
  }
  
  //private double roundm(int n,int m){
  //  return Math.floor(((n + m - 1)/m))*m;
  //}
  
  void makeRoom(int _width, int _height, PVector coordinate,int c){
    Room room;
    room = new Room(new Size(_width,_height),coordinate);
    rooms.add(room);
    room.roomNumber = c;
  }
  
  void createCorridors(int _width, int _height, PVector coordinate){
    Room room;
    room = new Room(new Size(_width,_height),coordinate);
    corridors.add(room);
  }
  
  void markMainRooms(){
    
    float average = getRoomAreaAverage() * 1.5;
    
    print("AVERAGE: " + average +"\n");
    for(int i=0;i<totalRoom;i++){
      if(rooms.get(i).area >= average){
          fill(255,0,0);
          stroke(0,0,0);
          createHalls(rooms.get(i).size.w, rooms.get(i).size.h, rooms.get(i).coordinate);
          rect(rooms.get(i).coordinate.x,rooms.get(i).coordinate.y,rooms.get(i).size.w, rooms.get(i).size.h);
          
      }
      if(rooms.get(i).area<average){
          fill(220,220,220);
          stroke(0,0,0);
          createCorridors(rooms.get(i).size.w, rooms.get(i).size.h, rooms.get(i).coordinate);
          //rect(rooms.get(i).coordinate.x,rooms.get(i).coordinate.y,rooms.get(i).size.w, rooms.get(i).size.h);
      }
      
    }
    for(int i=0;i<corridors.size();i++)
      print("Area Rectangle "+i+ ": "+corridors.get(i).area+"\n");
    for(int i=0;i<halls.size();i++)
      print("Hallway "+i+":"+halls.get(i).area);
  }
  
  private int getRoomAreaAverage(){
    int sum=0;
    for(int i =0;i<totalRoom;i++){
      sum += rooms.get(i).area;
    }
    return sum/totalRoom;
  }
  
  private void connectRooms(){
    Room a,b,c;
    double d_ab,d_ac,d_bc;
    boolean skip = false;
    for(int i=0;i<halls.size();i++){
      a = halls.get(i);
      
      for(int j=1;j<halls.size();j++){
        skip = false;
        b = halls.get(j);
        //d_ab = Math.pow(a.getCenter().x - b.getCenter().x,2) + Math.pow(a.getCenter().y - b.getCenter().y,2);
        d_ab = dist(a.getCenter().x, a.getCenter().y, b.getCenter().x, b.getCenter().y);
        
        for(int k=0;k<halls.size();k++){
          if(k == i || k == j){
            continue;
          }
          c = halls.get(k);
          //d_ac = Math.pow(a.getCenter().x - c.getCenter().x,2) + Math.pow(a.getCenter().y - c.getCenter().y,2);
          //d_bc = Math.pow(b.getCenter().x - c.getCenter().x,2) + Math.pow(b.getCenter().y - c.getCenter().y,2);
          d_ac = dist(a.getCenter().x, a.getCenter().y, c.getCenter().x, c.getCenter().y);
          d_bc = dist(b.getCenter().x, b.getCenter().y, c.getCenter().x, c.getCenter().y);
          if(d_ac < d_ab && d_bc < d_ab)
            skip = true;
          if(skip)
            break;
        }
        if(!skip){
          a.linkTo.add(b);
        }
        
      }
    }
    for(int i=0;i<halls.size();i++){ // bapak
      Room s = halls.get(i);
      PVector r1 = s.getCenter();
      for(int j = 0;j<halls.get(i).linkTo.size();j++){ // anaknya
        Room r = (Room)s.linkTo.get(j);
        PVector r2 = r.getCenter();
        line(r1.x, r1.y, r2.x, r2.y);
      }
    }
    for(int i=0;i<halls.size();i++){
      Room s = halls.get(i);
      createL(s,3);
    }
  }
  
  private void createL(Room a, float roomHeight){
    //List<Room> halls = new ArrayList<Room>();
    
    for(int i = 0; i < a.linkTo.size(); i++){
      Room selected = (Room)a.linkTo.get(i);
      PVector coordinate_hor = new PVector(a.getCenter().x , a.getCenter().y - (roomHeight / 2));
      PVector coordinate_ver;
      
      /* Check if the child is on the left or on the right of the current room */
      Boolean isLeft = a.getCenter().x > selected.getCenter().x;
      Boolean isTop;
      
      /* Create horizontal section */
      /* Get absolute distance to child */
      float distance_hor = abs(a.getCenter().x - selected.getCenter().x);
      float distance_ver = 0;
      
      if(isLeft){
        coordinate_hor.x -= distance_hor + roomHeight;
      }else{
        coordinate_hor.x += roomHeight;
      }
      
      //distance_hor += roomHeight * 2;
      
      Room tmp = new Room(new Size(int(distance_hor), int(roomHeight)), coordinate_hor);
      tmp.isHallway = true;
      corridors.add(tmp);
      rect(coordinate_hor.x, coordinate_hor.y, distance_hor, roomHeight);
      
      /* Create vertical section */
      coordinate_ver = new PVector(a.getCenter().x - (roomHeight / 2) + (isLeft ? -distance_hor : distance_hor), a.getCenter().y);
      distance_ver = abs(a.getCenter().y - selected.getCenter().y);
      
      /* Check if the child is above a */
      isTop = a.getCenter().y > selected.getCenter().y;
      
      if(isTop){
        coordinate_ver.y -= distance_ver + roomHeight;
      }else{
        coordinate_hor.y += roomHeight;
      }
      
      //distance_ver += roomHeight * 2;
      
      tmp = new Room(new Size(int(roomHeight), int(distance_ver)), coordinate_ver);
      tmp.isHallway = true;
      corridors.add(tmp);
      rect(coordinate_ver.x, coordinate_ver.y, roomHeight, distance_ver);
      
      /* Search for parent in child link */
      for(int j = 0; j < selected.linkTo.size(); j++){
        Room selectedChild = (Room)selected.linkTo.get(j);
        if(selectedChild.roomNumber == a.roomNumber){
          selected.linkTo.remove(j);
          break;
        }
      }
    }
    //Room tempRoom;
    //List<Room> tempRchildren = new ArrayList<Room>();
    //List<Room> newRoom = new ArrayList<Room>();
    
    //for(int i=0;i<a.linkTo.size();i++){
    //  tempRoom = (Room)a.linkTo.get(i);
    //  tempRchildren.add(tempRoom);
    //  int L_Top_y = 10;
    //  int L_Top_x = int(Math.abs(a.getCenter().x - tempRchildren.get(i).getCenter().x));
    //  newRoom.add(new Room(new Size(L_Top_x,L_Top_y), a.getCenter()));
    //  rect(newRoom.get(i).getCenter().x,newRoom.get(i).getCenter().y,newRoom.get(i).size.w,newRoom.get(i).size.h);
    //}
  }
  
  private void createHalls(int _width, int _height, PVector coordinate){
    Room room = new Room(new Size(_width,_height),coordinate);
    halls.add(room);
  }
  
  private void separateRooms(){
    Room a,b;
    boolean touching;
    int dx,dxa,dxb,dy,dya,dyb;
    do{
      touching=false;
      for(int i=0;i<rooms.size();i++){
        a = rooms.get(i);
        for(int j=i+1;j<rooms.size();j++){
          b = rooms.get(j);
          if(a.isTouching(b, padding)){
            touching = true;
            dx = Math.min(a.getRight()-b.getLeft()+padding, a.getLeft()-b.getRight()-padding);
            dy = Math.min(a.getBottom()-b.getTop()+padding, a.getTop()-b.getBottom()-padding);
            if(Math.abs(dx) <Math.abs(dy))
              dy = 0;
            else
              dx = 0;
              dxa = -dx/2;
            dxb = dx+dxa;
            dya = -dy/2;
            dyb = dy+dya;
            a.shift(dxa, dya);
            b.shift(dxb, dyb);
          }
        }
      }
    }while(touching);
  }
}