//http://www.wblut.com/constructs/voronoiFractal/Voronoi.pde
class Voronoi{

  int NUMPOINTS;
  int order;
  ArrayList initialPoints;
  ArrayList initialSegments;
  ArrayList bisectors;
  ArrayList borders;
  ArrayList bisectorIntersections;
  ArrayList cells;
  color fillColor;


  Voronoi(final int n, final ArrayList borders, final int o, final color c){
    order=o;
    NUMPOINTS=n;
    initializeLists();
    this.borders.addAll(borders);
    generateInitialPoints();
    generateInitialSegments();
    generateBisectors(); 
    generateBisectorIntersections();
    generateVoronoiSegments();
    fillColor=c;

  }



  Segment2D extendToBorder(final Segment2D segment, final ArrayList borders){
    Point2D startPoint = null ;
    Iterator itr = borders.iterator();
    int border=-1;
    Segment2D currentBorder=new Segment2D();
    while ((itr.hasNext( ))&&(startPoint == null)){
      currentBorder=(Segment2D)itr.next();
      startPoint = segmentIntersectionWithLine(currentBorder,segment);
      border++;
    }
    if(startPoint != null){
      startPoint.onBorder=border;
      currentBorder.add(startPoint);
      }
    Point2D endPoint = null ;
    while ((itr.hasNext( ))&&(endPoint == null)){
      currentBorder=(Segment2D)itr.next();
      endPoint = segmentIntersectionWithLine(currentBorder,segment);
      border++;
    }
    if(endPoint != null){
      endPoint.onBorder=border;
      currentBorder.add(endPoint);
  
      }

    if((startPoint != null)&&(endPoint != null)) return new Segment2D(startPoint,endPoint);
    return new Segment2D(segment);
  }

  void initializeLists(){
    initialPoints = new ArrayList();
    initialSegments = new ArrayList();
    bisectors = new ArrayList();
    borders = new ArrayList();
    bisectorIntersections = new ArrayList();
    cells = new ArrayList();

  }

  void generateInitialPoints(){
    float minx,maxx,miny,maxy;
    minx=miny=20000000;
    maxx=maxy=-1;
    Iterator borderItr = borders.iterator();
    while(borderItr.hasNext()){
      Segment2D currentBorder =(Segment2D) borderItr.next();
      minx=min(minx,currentBorder.start.x);
      minx=min(minx,currentBorder.end.x);
      miny=min(miny,currentBorder.start.y);
      miny=min(miny,currentBorder.end.y);    
      maxx=max(maxx,currentBorder.start.x);
      maxx=max(maxx,currentBorder.end.x);
      maxy=max(maxy,currentBorder.start.y);
      maxy=max(maxy,currentBorder.end.y); 

    }

    for(int i=0;i<NUMPOINTS;i++){
      SegmentPoint2D trialPoint=new SegmentPoint2D(random(minx,maxx), random(miny,maxy));
      while(!inside(trialPoint)){
        trialPoint=new  SegmentPoint2D(random(minx,maxx), random(miny,maxy));
      }
      initialPoints.add(trialPoint);
    }
  }

  boolean inside(final Point2D point){
    boolean result=false;
    Segment2D testSegment = new Segment2D(point.x,point.y,width+1,point.y);
    int numIntersections=0;
    Iterator borderItr = borders.iterator();
    while(borderItr.hasNext()){
      Segment2D currentBorder =(Segment2D) borderItr.next();
      if(segmentIntersectionWithSegment(testSegment,currentBorder)!=null) numIntersections++;

    }
    if((numIntersections%2==1))  result=true;
    numIntersections=0;
    testSegment = new Segment2D(point.x,point.y,point.x,height+1);
    borderItr = borders.iterator();
    while(borderItr.hasNext()){
      Segment2D currentBorder =(Segment2D) borderItr.next();
      if(segmentIntersectionWithSegment(testSegment,currentBorder)!=null) numIntersections++;

    }
    if((numIntersections%2==1))  result=true;
    return result;

  }

  void generateInitialSegments(){
    for(int i=0;i<NUMPOINTS;i++){
      SegmentPoint2D pointi=(SegmentPoint2D)initialPoints.get(i);
      for(int j=i+1;j<NUMPOINTS;j++){
         SegmentPoint2D pointj=(SegmentPoint2D)initialPoints.get(j);
        Segment2D segmentij = new Segment2D(pointi.convertToPoint2D(),pointj.convertToPoint2D());
        initialSegments.add(segmentij);
        pointi.add(segmentij);
        pointj.add(segmentij);
      }
    }  
  }


  void generateBisectors(){ 
    Iterator itr = initialSegments.iterator();
    while (itr.hasNext( )) {
      Segment2D currentSegment=(Segment2D)itr.next();
      Point2D midPoint = new Point2D(0.5f*currentSegment.start.x+0.5f*currentSegment.end.x, 0.5f*currentSegment.start.y+0.5f*currentSegment.end.y);
      Point2D relPoint =new Point2D(currentSegment.start.y-currentSegment.end.y, currentSegment.end.x-currentSegment.start.x);
      Point2D startPoint=new Point2D(midPoint.x-relPoint.x,midPoint.y-relPoint.y);
      Point2D endPoint=new Point2D(midPoint.x+relPoint.x,midPoint.y+relPoint.y);
      Segment2D bisector = new Segment2D(extendToBorder(new Segment2D(startPoint,endPoint), borders));
      bisectors.add(bisector);
      currentSegment.bisector = bisector;
    } 
  }  

  void  generateBisectorIntersections(){
    for(int i=0;i<bisectors.size();i++){
      Segment2D bisectori = (Segment2D)bisectors.get(i);
      for(int j=i+1;j<bisectors.size();j++){
        Segment2D bisectorj = (Segment2D)bisectors.get(j);
        Point2D result = segmentIntersectionWithSegment(bisectori, bisectorj);
        if (result!=null) {
          bisectorIntersections.add(result);
          bisectori.points.add(result);
          bisectorj.points.add(result);
        }
      }
    }
  }

  void  generateVoronoiSegments(){
    Iterator centerPointItr = initialPoints.iterator();
    while(centerPointItr.hasNext()){
      SegmentPoint2D currentCenterPoint = (SegmentPoint2D)centerPointItr.next();
      ArrayList periphery = new ArrayList();      
      Iterator segmentItr = currentCenterPoint.belongsToSegment.iterator();  
      while(segmentItr.hasNext()){
        Segment2D currentSegment = (Segment2D)segmentItr.next();
        Segment2D currentBisector = currentSegment.bisector;
        Iterator sweepPointItr = currentBisector.points.iterator();
        while(sweepPointItr.hasNext()){
          Point2D currentSweepPoint = (Point2D)sweepPointItr.next();
          Segment2D currentSweepRay = new Segment2D(currentCenterPoint,currentSweepPoint);
          Iterator sweepSegmentItr = currentCenterPoint.belongsToSegment.iterator();
          boolean intersect = false;
          while(sweepSegmentItr.hasNext()){
            Segment2D currentSweepSegment =(Segment2D)sweepSegmentItr.next();
            Segment2D currentSweepBisector=currentSweepSegment.bisector;
            Point2D sweepIntersection = segmentIntersectionWithSegment(currentSweepRay, currentSweepBisector);
            if ((sweepIntersection!=null)&&(!sweepIntersection.equals(currentSweepPoint,0.1f))){
              intersect = true;
              break;
            }
          }
          if(!intersect){
            Point2D peripheryPoint = new Point2D(currentSweepPoint);
            periphery.add(peripheryPoint);
          }
        }
      }
      
      segmentItr = borders.iterator();      
      while(segmentItr.hasNext()){
        Segment2D currentSegment = (Segment2D)segmentItr.next();
        Iterator sweepPointItr = currentSegment.points.iterator();
        while(sweepPointItr.hasNext()){
          Point2D currentSweepPoint = (Point2D)sweepPointItr.next();
          Segment2D currentSweepRay = new Segment2D(currentCenterPoint,currentSweepPoint);
          Iterator sweepSegmentItr = currentCenterPoint.belongsToSegment.iterator();
          boolean intersect = false;
          while(sweepSegmentItr.hasNext()){
            Segment2D currentSweepSegment =(Segment2D)sweepSegmentItr.next();
            Segment2D currentSweepBisector=currentSweepSegment.bisector;
            Point2D sweepIntersection = segmentIntersectionWithSegment(currentSweepRay, currentSweepBisector);
            if ((sweepIntersection!=null)&&(!sweepIntersection.equals(currentSweepPoint,0.1f))){
              intersect = true;
              break;
            }
          }
          if(!intersect){
            Point2D peripheryPoint = new Point2D(currentSweepPoint);
            periphery.add(peripheryPoint);

          }
        }
      }            
      Cell cell = new Cell(currentCenterPoint.convertToPoint2D());
      cell.periphery.addAll(periphery);
      cell.update();
      cells.add(cell);
    }
  }

}