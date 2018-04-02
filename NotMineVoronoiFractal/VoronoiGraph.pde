//http://www.wblut.com/constructs/voronoiFractal/VoronoiGraph.pde
import java.util.Iterator;
class VoronoiGraph{
  ArrayList polygons;
  int order;
  int MAXORDER;
  color fillColor;
  color strokeColor;
  

  VoronoiGraph(Voronoi voronoi, int MAXORDER){
    polygons=new ArrayList();
    Polygon currentPolygon;
    order = voronoi.order;
    fillColor=voronoi.fillColor;
    strokeColor=color(0,50);
    this.MAXORDER=MAXORDER;
    Iterator cellItr = voronoi.cells.iterator();
    while(cellItr.hasNext()){
      Cell currentCell = (Cell)cellItr.next();
      currentPolygon=new Polygon(currentCell.periphery,strokeColor,0.5f*(MAXORDER-order+1),fillColor);
      polygons.add(currentPolygon);
    }
  }

  void draw(){
    Iterator polygonItr = polygons.iterator();
    while(polygonItr.hasNext()){
      ((Polygon)polygonItr.next()).draw();   
      }       
    }
    
   void drawFill(){
    Iterator polygonItr = polygons.iterator();
    while(polygonItr.hasNext()){
      ((Polygon)polygonItr.next()).drawFill();   
      }       
    }
    
     void drawStroke(){
    Iterator polygonItr = polygons.iterator();
    while(polygonItr.hasNext()){
      ((Polygon)polygonItr.next()).drawStroke();   
      }       
    }
    
     void drawPoints(){
    Iterator polygonItr = polygons.iterator();
    while(polygonItr.hasNext()){
      ((Polygon)polygonItr.next()).drawPoints();   
      }       
    }



}

class Polygon{
  ArrayList points;
  color strokeColor;
  color fillColor;
  float strokeWeight;

  Polygon(){
    points=new ArrayList();
    strokeColor=color(0);
    fillColor=color(0);
    strokeWeight=1.0f;
  }

  Polygon(final ArrayList points,final color strokeColor, final float strokeWeight, final color fillColor){
    this.points=new ArrayList();
    this.points.addAll(points);
    this.strokeColor=strokeColor;
    this.fillColor=fillColor;
    this.strokeWeight=strokeWeight;
  }

  void drawStroke(){
    noFill();
    stroke(strokeColor);
    strokeWeight(strokeWeight);
    beginShape();  
    Iterator itr = points.iterator();
    while(itr.hasNext()){
      Point2D currentPoint= (Point2D)itr.next();
      vertex(currentPoint.x,currentPoint.y);
    }
    if (points.size()>0)vertex(((Point2D)points.get(0)).x,((Point2D)points.get(0)).y);
    endShape();
  }
  void drawFill(){
    noStroke();
    fill(fillColor);
    beginShape();  
    Iterator itr = points.iterator();
    while(itr.hasNext()){
      Point2D currentPoint= (Point2D)itr.next();
      vertex(currentPoint.x,currentPoint.y);
    }
    if (points.size()>0)vertex(((Point2D)points.get(0)).x,((Point2D)points.get(0)).y);
    endShape();
  }

  void draw(){
    fill(fillColor);
    stroke(strokeColor);
    strokeWeight(strokeWeight);
    beginShape();  
    Iterator itr = points.iterator();
    while(itr.hasNext()){
      Point2D currentPoint= (Point2D)itr.next();
      vertex(currentPoint.x,currentPoint.y);
    }
    if (points.size()>0)vertex(((Point2D)points.get(0)).x,((Point2D)points.get(0)).y);
    endShape();
  }

  void drawPoints(){
    fill(fillColor);
    stroke(strokeColor);
    strokeWeight(1.0f);
    Iterator itr = points.iterator();
    while (itr.hasNext()) {
      Point2D currentPoint =(Point2D)itr.next();
      currentPoint.draw();
    }  

  }




}