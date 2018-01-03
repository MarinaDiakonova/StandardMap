/* Description of program here*/

//Declaration of variables and initialisation of globals
//a dynamic list of coordinates of all the trajectories at the given time
float pi = acos(-1);
float systemperiod = 2*pi;
float K = 0.97; //the nonlinearity parameter in the Standard Map
//the last KAM will break down at K~1;

float edge = 0; //- pi; //sets periodic window to start at edge (e.g. -pi)

int ws;
int N;
int cellsize; //amount of pixels in cell length
float celllength; //length of cell (Leb.meas. of length of state space in one cell)
int count;

/* Applet window */
float screenratio = 0.75; //the display window is a given ratio of the _height_ of the screen
//Calculate size of window (in pixels)
int ssh = displayHeight; //get height of screen (in pixels)


/* State space visualisation */
//State space is discretised into cells of linear size epsilon 
float rel_cell_size = 0.005;


color backgroundcolour = 0; //0 for black background, 255 for white one
int fps = 500; //the default framerate (frames per second)


/* Declare variables */
DiscretisedSpace statespace; 
ArrayList trajectories;

boolean initialise;

void setup() {
  background(backgroundcolour);
  ws = floor( screenratio*ssh ); //limited by height of screen
  N = ceil(  (1/rel_cell_size) ); //number of cells in 1 dimension
  cellsize = ceil( ws/N ); //in pixels; Has to be ceil since want it to be at least 1 pixel
  //float epsilon = rel_cell_size*systemperiod; //absolute value
  ws = cellsize*N; //recalculate size of application window to fit cells
  celllength = systemperiod/N;
  
  cellsize = 1;
  N = 500;
  ws = cellsize*N;
  celllength = systemperiod/N;
  
  //frameRate( fps );
  //size(ws, ws);
  size(500, 500, P2D);
  //size(ws,ws);
  statespace = new DiscretisedSpace( N,N );
  trajectories = new ArrayList();
  
  count = 0;
}
  
  

void draw() {
  //print ( " " + count++ + " " ); 
  
  statespace.display();
  
  for (int j = 0; j < 100; j++) {
  for (int i = 0; i < trajectories.size(); i++) { 
    Trajectory trajectory = (Trajectory) trajectories.get( i ); //notice casting of the ith element
    trajectory.evolve();
      //print( " traj nu " + i );    
    }
  }
  
}

void mousePressed() {
  trajectories.add( new Trajectory(mouseX, mouseY) );
}

   
   


class DiscretisedSpace{
  int sizeX;
  int sizeY;
  color [] [] grid; //grid of colours
  
  
  //initialise
  DiscretisedSpace( int tempsizeX, int tempsizeY ){
    
    sizeX = tempsizeX;
    sizeY = tempsizeY;
    grid = new color[ sizeX ] [ sizeY ];
    
    //initialise constituent cells with coordinates and the default colour
    for (int i = 0; i < sizeX; i++) {
      for (int j = 0; j < sizeY; j++) {
       //print( i + " " + j + " " + cellsize + " " );
        grid[ i ][ j ] = backgroundcolour;
      }
    }
  }
  
  
  //returns a cell specified by the cell coordinates
  void setcolour( int tempX, int tempY, color tempColour ){
    grid[ tempX ] [ tempY ] = tempColour;
  }
  
  
  //displays cells
  void display() {
    //print( " sizeX is " + sizeX + " sizeY is " + sizeY );
    for (int i = 0; i < sizeX; i++) {
      for (int j = 0; j < sizeY; j++) {
        noStroke();
        //stroke( grid[ i ][ j ] );
        fill( grid[ i ][ j ] ); //set colour to cell colour
        rect( i*cellsize, j*cellsize, cellsize, cellsize);
      }
    }
  }
  
}



class Trajectory {
  float xcoord;
  float ycoord;
  color trajcolour;
  
  //Coord Constructor - to use in inialisation
  Trajectory( int tempX, int tempY ) {
    //index of cell in which mouse was clicked
    int getcellx = floor( tempX / cellsize );
    int getcelly = floor( tempY / cellsize );
    //print( " " + getcellx + " " + getcelly + " " );
    //print( " cellsize is " + cellsize + " celllength is " + celllength) ;
    xcoord = edge + getcellx*celllength + random(celllength);
    ycoord = edge + getcelly*celllength + random(celllength);
    //print( " " + xcoord + " " + ycoord + " " );
    //pick a random colour to assign to this trajectory
    trajcolour = color(random(255), random(255), random(255));
    statespace.setcolour( getcellx, getcelly, trajcolour );
  }
  
  //evolve according to the Standard Mapping
  void evolve () {
    ycoord = ycoord + K*sin( (float) xcoord );
    xcoord = xcoord + ycoord; 
    xcoord = xcoord % systemperiod;
    ycoord = ycoord % systemperiod;
    
    //select this for [0,2*pi] window
    if (xcoord < 0 ) { xcoord = xcoord + systemperiod; }
    if (ycoord < 0 ) { ycoord = ycoord + systemperiod; }
    //get coords of cell in which the Trajectory is currently located. No need for an extra function here.
    int getcellx = floor( xcoord / celllength );
    int getcelly = floor( ycoord / celllength );
    
    
    //print( " colour this cell " + getcellx + " " + getcelly );
    statespace.setcolour( getcellx, getcelly, trajcolour );
  }
  
}




    



  