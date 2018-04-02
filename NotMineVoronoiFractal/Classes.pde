//http://www.wblut.com/constructs/voronoiFractal/classes.pde
class Point2D{
  float x,y;
  int onBorder;
  Point2D(){
    x=y=0.0f;
    onBorder=-1;
  }
  Point2D(final float x, final float y){
    this.x=x;
    this.y=y;
    onBorder=-1;
  }
  Point2D(final float x, final float y, final int id){
    this.x=x;
    this.y=y;
    onBorder=id;
  }
  Point2D(final Point2D p){
    x=p.x;
    y=p.y;
    onBorder=p.onBorder;
  }

  boolean equals(final Point2D point){
    return((point.x==x)&&(point.y==y));
  }

  boolean equals(final Point2D point, float threshold){
    return((point.x<x+threshold)&&(point.x>x-threshold)&&(point.y<y+threshold)&&(point.y>y-threshold));
  }

  void draw(){
    ellipse(x,y,4,4);
  }


}

class SegmentPoint2D extends Point2D{
  ArrayList belongsToSegment;

  SegmentPoint2D(){
    super();
    belongsToSegment = new ArrayList();

  }
  SegmentPoint2D(final float x, final float y){
    super(x,y);
    belongsToSegment = new ArrayList();
  }
  SegmentPoint2D(final float x, final float y, final int id){
    super(x,y,id);
    belongsToSegment = new ArrayList();
  }
  SegmentPoint2D(final Point2D p){
    super(p);
    belongsToSegment = new ArrayList();
  }

  void add(final Segment2D segment){
    belongsToSegment.add(segment);
  }
  
  Point2D convertToPoint2D(){
     return new Point2D(x,y,onBorder);   
    }
}

class PeripheryPoint2D extends Point2D{
  float angle;
  Point2D centerPoint;
  PeripheryPoint2D(final Point2D point, final Point2D centerPoint){
    super(point);
    this.centerPoint=new Point2D(centerPoint);
    angle=atan2(point.y-centerPoint.y,point.x-centerPoint.x);
  }
  PeripheryPoint2D(final PeripheryPoint2D point){
    super(point);
    centerPoint=new Point2D(point.centerPoint);
    angle=point.angle;
  }
  Point2D convertToPoint2D(){
    return new Point2D(x,y,onBorder);
  }
}

class Segment2D{
  Point2D start;
  Point2D end;
  ArrayList points;
  Segment2D bisector=null;


  Segment2D(){
    start = new Point2D(0.0f,0.0f);
    end = new Point2D(0.0f,0.0f);
    points=new ArrayList();
    points.add(start);
    points.add(end);
  }

  Segment2D(final float startx,final  float starty,final  float endx,final  float endy){
    start = new Point2D(startx,starty);
    end = new Point2D(endx,endy);
    points=new ArrayList();
    points.add(start);
    points.add(end);
  }

  Segment2D(final float startx,final  float starty,final  float endx,final  float endy, int id){
    start = new Point2D(startx,starty);
    end = new Point2D(endx,endy);
    start.onBorder=id;
    end.onBorder=id;
    points=new ArrayList();
    points.add(start);
    points.add(end);
  }

  Segment2D(final Point2D start,final  Point2D end){
    this.start = new Point2D(start);
    this.end = new Point2D(end);
    points=new ArrayList();
    points.add(start);
    points.add(end);
  }

  Segment2D(final Point2D start,final  Point2D end, int id){
    this.start = new Point2D(start);
    this.end = new Point2D(end);
    this.start.onBorder=id;
    this.end.onBorder=id;
    points=new ArrayList();
    points.add(start);
    points.add(end);
  }

  Segment2D(final Segment2D segment){
    start = new Point2D(segment.start);
    end = new Point2D(segment.end);
    points=new ArrayList();
    points.add(start);
    points.add(end);
  }

  void add(Point2D point){
    Iterator itr = points.iterator();
    boolean unique=true;
    while (itr.hasNext()) {
      if (point.equals((Point2D)itr.next(),0.1f)){
        unique=false;
        break;
      }

    }
    if (unique) points.add(point);
  }

  Point2D get(final int i){
    return (Point2D)points.get(i);
  }

  void draw(){
    line(start.x,start.y,end.x,end.y);
  }

}

class Cell{
  Point2D centerPoint;
  ArrayList periphery;

  Cell(final Point2D point){
    centerPoint=new Point2D(point);
    periphery = new ArrayList();
  }

  void update(){
    clean();
    sort();
    removeCollinearPoints();   
  }

  void clean(){
    ArrayList cleanedPeriphery = new ArrayList();
    for(int i=0;i<periphery.size();i++){
     Point2D pointi=(Point2D)periphery.get(i);
      boolean unique=true;
      for(int j=i+1;j<periphery.size();j++){
        Point2D pointj=(Point2D)periphery.get(j);
        if (pointi.equals(pointj,0.1f)){
          unique=false;
          break;
        }
      }
      if(unique) cleanedPeriphery.add(pointi);
    }
    periphery.clear();
    periphery.addAll(cleanedPeriphery);
  }

  void sort(){
    for (int i = periphery.size(); --i >= 0; ) {
      for (int j = 0; j < i; j++) {
        PeripheryPoint2D pointj = new PeripheryPoint2D((Point2D)periphery.get(j),centerPoint);        
        PeripheryPoint2D pointjj = new PeripheryPoint2D((Point2D)periphery.get(j+1),centerPoint); 
        if (pointj.angle > pointjj.angle) {
          PeripheryPoint2D temp = new PeripheryPoint2D(pointj);
          periphery.set(j,pointjj.convertToPoint2D());
          periphery.set(j+1,temp.convertToPoint2D());
        }
      }
    }
  }

  void removeCollinearPoints(){
    ArrayList simplePeriphery = new ArrayList();
    for(int i=0;i<periphery.size();i++){
      Point2D pointi=(Point2D)periphery.get(i);
      int j = i-1;
      if(j<0) j=periphery.size()-1;
      Point2D pointj=(Point2D)periphery.get(j);
      int k = i+1;
      if(k==periphery.size()) k=0;
      Point2D pointk=(Point2D)periphery.get(k);
      if (!colinear(pointi,pointj,pointk,0.01f)){
        simplePeriphery.add(pointi);
      }
    }
    periphery.clear();
    periphery.addAll(simplePeriphery);
  }
}
float dist(Point2D point1,Point2D point2){
  return abs(point1.x-point2.x)+abs(point1.y-point2.y);
  //return dist(point1.x, point1.y,point2.x,point2.y);
}

Point2D segmentIntersectionWithSegment(final Segment2D segment1, final Segment2D segment2){
  Point2D result=null;
  float denominator = (segment2.end.y-segment2.start.y)*(segment1.end.x-segment1.start.x)-(segment2.end.x-segment2.start.x)*(segment1.end.y-segment1.start.y);
  if (denominator==0.0f) return result;
  float ua=((segment2.end.x-segment2.start.x)*(segment1.start.y-segment2.start.y)-(segment2.end.y-segment2.start.y)*(segment1.start.x-segment2.start.x))/denominator;
  float ub=((segment1.end.x-segment1.start.x)*(segment1.start.y-segment2.start.y)-(segment1.end.y-segment1.start.y)*(segment1.start.x-segment2.start.x))/denominator;
  if((ua>1.0f)||(ua<0.0f)||(ub>1.0f)||(ub<0.0f)) return result;
  result=new Point2D(segment1.start.x+ua*(segment1.end.x-segment1.start.x),segment1.start.y+ua*(segment1.end.y-segment1.start.y));
  return result;
}

Point2D segmentIntersectionWithLine(final Segment2D segment1, final Segment2D segment2){
  Point2D result=null;
  float denominator = (segment2.end.y-segment2.start.y)*(segment1.end.x-segment1.start.x)-(segment2.end.x-segment2.start.x)*(segment1.end.y-segment1.start.y);
  if (denominator==0.0f) return result;
  float ua=((segment2.end.x-segment2.start.x)*(segment1.start.y-segment2.start.y)-(segment2.end.y-segment2.start.y)*(segment1.start.x-segment2.start.x))/denominator;
  if((ua>1.0f)||(ua<0.0f)) return result;
  result=new Point2D(segment1.start.x+ua*(segment1.end.x-segment1.start.x),segment1.start.y+ua*(segment1.end.y-segment1.start.y));
  return result;
}

boolean colinear(final Point2D point1,final Point2D point2,final Point2D point3,final float threshold){
  if((point1.x==point2.x)||(point2.x==point3.x)) return(point3.x==point1.x);
  float a1=(point1.y-point2.y)/(point1.x-point2.x);
  float a2=(point2.y-point3.y)/(point2.x-point3.x);
  float b1=(point2.y*point1.x-point1.y*point2.x)/(point1.x-point2.x);
  float b2=(point3.y*point2.x-point2.y*point3.x)/(point2.x-point3.x);
  Point2D testPoint1 = new Point2D(a1,b1);
  Point2D testPoint2 = new Point2D(a2,b2);
  return testPoint1.equals(testPoint2, threshold);


}