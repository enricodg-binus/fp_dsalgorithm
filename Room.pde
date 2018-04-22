
import java.util.*;

class Room{
  int roomNumber = 0;
  public final PVector coordinate;
  public final Size size;
  public final int area;
  public Boolean isHallway = false;
  
  List linkTo = new ArrayList<Room>();
  
  public Room(Size size, PVector coordinate){
    this.size = size;
    
    this.coordinate = coordinate;
    
    this.area = size.w * size.h;
  }
  
  public void setHallway(Boolean status){
    this.isHallway = status;
  }
  
  public Boolean isHallway(){
    return this.isHallway;
  }
  
  public int getTop(){
    return (int)this.coordinate.y;
  }
  
  public int getBottom(){
    return this.getTop() + this.size.h;
  }
  
  public int getLeft(){
    return (int)this.coordinate.x;
  }
  
  public int getRight(){
    return this.getLeft() + this.size.w;
  }
  
  public PVector getCenter(){
    int x = this.getLeft() + (this.size.w / 2);
    int y = this.getTop() + (this.size.h / 2);
    return new PVector(x, y);
  }
  
  private Boolean inContact(Room b, float padding){
    Room a = this;
    
    if(((a.getTop() > b.getBottom() && a.getLeft() > b.getRight()) ||
        (a.getBottom() < b.getTop() && a.getRight() < b.getLeft()))
        ||
        ((b.getTop() > a.getBottom() && b.getLeft() > a.getRight()) ||
        (b.getBottom() < a.getTop() && b.getRight() < a.getLeft())))
    return false;
    
    int[] _a = {a.getLeft(), a.getTop(), a.getRight(), a.getBottom()};
    int[] _b = {b.getLeft(), b.getTop(), b.getRight(), b.getBottom()};
    
    Boolean comp0 = _a[0] - padding < _b[2] - padding;
    Boolean comp1 = _a[2] - padding > _b[0] - padding;
    Boolean comp2 = _a[1] - padding < _b[3] - padding;
    Boolean comp3 = _a[3] - padding > _b[1] - padding;
    
    return (comp0 && comp1 && comp2 && comp3);
  }
  
  public Boolean isTouching(Room b, float padding){
    return inContact(b, padding);
  }
  
  public Boolean isTouching(Room b){
    return inContact(b, 0);
  }
  
  void shift(int x, int y){
    this.coordinate.x += x;
    this.coordinate.y += y;
  }
}

class Size{
  int w,h;
  Size(int _width, int _height){
    this.w = _width;
    this.h = _height;
  }
}