/*
StereoRibbons
 by Alejandro García Salas
 
dancing ribbons? - based on "Tendrils" by Jeff Traer (http://murderandcreate.com/physics/) using the Traer Physics Library
*/

String audiofilename = "data/so-obvious.mp3"; // The audio source to use.


int MAX_NUMBER_OF_TENDRILS = 400;
// the length of the lines.
float TENDRIL_POINT_SPACING = 40.0;
float CONDUCTOR_SCALING_CONSTANT = 7.0;
int BEAT_DETECTION_SENSITIVITY = 50;
int SKIP_BEATS = 1;
int skip_beat_counter = 0;

import peasy.*;
import traer.physics.*;
import ddf.minim.analysis.*;
import ddf.minim.*;
import java.util.Vector;

Palette pal;

PeasyCam cam;
Vector tendrils;
ParticleSystem physics;
Particle conductor, positioner;
Minim minim;
FFT fft;
AudioPlayer player;
BeatDetect beat;
BeatListener blistener;
float buffersize;

void setup()
{
  
  size( 1920, 1080, P3D );
  frameRate(60);
  smooth();
  
  physics = new ParticleSystem( 0.0f, 0.1f );
  
  pal = new Palette();
  

  conductor = physics.makeParticle();
  conductor.makeFixed();
  
  tendrils = new Vector();
  
  // Init Minim
  minim = new Minim(this);
  // Init audio source
  player = minim.loadFile(audiofilename);
  player.play();
  buffersize = player.mix.size();
  beat = new BeatDetect(player.bufferSize(), player.sampleRate());
  beat.setSensitivity(BEAT_DETECTION_SENSITIVITY);
  blistener = new BeatListener(beat, player);
  
  cam = new PeasyCam(this, 300);
 
  tendrils.add( new T3ndril( physics, conductor.position(), conductor ) );
}

void draw()
{
  physics.tick();
  
  // Compute the driving value s.
  float s = currentAudioSignalEnergy();

  // Store detected beats for this frame
  boolean BeatIsKick = beat.isKick();
  boolean BeatIsSnare = beat.isSnare();
  boolean BeatIsHat = beat.isHat();
  boolean BeatIsOn = BeatIsKick || BeatIsSnare || BeatIsHat;
  

  if (BeatIsSnare) { s=s*1.8; };
  
  float perturbation = pow(10.0, s*CONDUCTOR_SCALING_CONSTANT);
  Vector3D rd = randVector3d(perturbation);
  conductor.position().set(rd.x(), rd.y(), rd.z());
  
  if (BeatIsKick) {
    background(10.0*s,10,100.0*s);
    if (tendrils.size()<MAX_NUMBER_OF_TENDRILS && skip_beat_counter == SKIP_BEATS) {
      tendrils.add( new T3ndril( physics, conductor.position(), conductor ) );
      // Add one point to this new line
      addPointToLastTendril();
      skip_beat_counter = 0;
    }
    skip_beat_counter = skip_beat_counter + 1;
    pal.change();
  } else {
    background(0);
  }
  
  if (BeatIsOn && tendrils.size()<MAX_NUMBER_OF_TENDRILS) {
    addPointToLastTendril();
  }

  // And finally, draw the lines
  drawTendrils();  
}

float currentAudioSignalEnergy() {
  float s = 0.0;
  for(int i = 0; i < buffersize - 1; i++) {
    s = s + pow(abs(player.left.get(i)),2) + pow(abs(player.right.get(i)),2);
  }
  s = s/buffersize;
  return s;
}

void addPointToLastTendril(Particle pos) {
  T3ndril t = ((T3ndril)tendrils.lastElement());
  Particle p = ((Particle)t.particles.lastElement());
  Vector3D r = pos.position();
  Vector3D pt = new Vector3D(p.position().x()+r.x(), p.position().y()+r.y(), p.position().z()+r.z() );
  ((T3ndril)tendrils.lastElement()).addPoint( pt );
}

void addPointToLastTendril() {
  T3ndril t = ((T3ndril)tendrils.lastElement());
  Particle p = ((Particle)t.particles.lastElement());
  Vector3D r = noiseVector3d(1,TENDRIL_POINT_SPACING);
  Vector3D pt = new Vector3D(p.position().x()+r.x(), p.position().y()+r.y(), p.position().z()+r.z() );
  ((T3ndril)tendrils.lastElement()).addPoint( pt );
}

Vector3D randVector3d(float scale) {
  float x = random(-0.5,0.5);
  float y = random(-0.5,0.5);
  float z = random(-0.5,0.5);
  PVector v = new PVector(x,y,z);
  v.normalize();
  v.mult(scale);
  return new Vector3D(v.x,v.y,v.z);
}

Vector3D noiseVector3d(float freq, float scale) {
  // Vector following perlin noise
  float t = freq*float(frameCount);
  float x = noise(t,0,0)-0.5;
  float y = noise(0,t,0)-0.5;
  float z = noise(0,0,t)-0.5;
  return new Vector3D(scale*x,scale*y,scale*z);
}

void drawTendrils() {
  stroke( 128 );
  for ( int i = 0; i < tendrils.size()-1; ++i )
  {
    T3ndril t = (T3ndril)tendrils.get( i );
    // Get tendril color by tendril index from the Palette generator.
    stroke(pal.get(i));
    fill(pal.get(i));
    drawElastic( t );
  }
}
  
void drawElastic( T3ndril t ) {
  float lastStretch = 1;
  for ( int i = 0; i < t.particles.size()-1; ++i )
  {
    Vector3D firstPoint = ((Particle)t.particles.get( i )).position();
    Vector3D firstAnchor =  i < 1 ? firstPoint : ((Particle)t.particles.get( i-1 )).position();
    Vector3D secondPoint = i+1 < t.particles.size() ? ((Particle)t.particles.get( i+1 )).position() : firstPoint;
    Vector3D secondAnchor = i+2 < t.particles.size() ? ((Particle)t.particles.get( i+2 )).position() : secondPoint;
      
    Spring s = (Spring)t.springs.get( i );
    float springStretch = 2.5*s.restLength()/s.currentLength();
          
    strokeWeight(25);
    lastStretch = springStretch;
      
    bezier(
      firstAnchor.x(), firstAnchor.y(), firstAnchor.z(),
      firstPoint.x(), firstPoint.y(), firstPoint.z(),
      secondPoint.x(), secondPoint.y(), secondPoint.z(),
      secondAnchor.x(), secondAnchor.y(), secondAnchor.z() );
  }
}

class T3ndril {
  public Vector particles;
  public Vector springs;
  ParticleSystem physics;
  
  public T3ndril( ParticleSystem p, Vector3D firstPoint, Particle followPoint )
  {
    particles = new Vector();
    springs = new Vector();
    
    physics = p;
    
    Particle firstParticle = p.makeParticle( 1.0f, firstPoint.x(), firstPoint.y(), firstPoint.z() );
    particles.add( firstParticle );
    physics.makeSpring( followPoint, firstParticle, 0.1f, 0.1f, 5 );
  }

  public void addPoint( Vector3D p )
  {
    Particle thisParticle = physics.makeParticle( 1.0f, p.x(), p.y(), p.z() );
    springs.add( physics.makeSpring( ((Particle)particles.lastElement()),
                       thisParticle, 
                       1.0f,
                       1.0f,
                       ((Particle)particles.lastElement()).position().distanceTo( thisParticle.position() ) ) );
    particles.add( thisParticle );
  }
}

void stop()
{
  player.close();
  minim.stop();
  super.stop();
}


class BeatListener implements AudioListener
{
  private BeatDetect beat;
  private AudioPlayer source;
  
  BeatListener(BeatDetect beat, AudioPlayer source)
  {
    this.source = source;
    this.source.addListener(this);
    this.beat = beat;
  }
  
  void samples(float[] samps)
  {
    beat.detect(source.mix);
  }
  
  void samples(float[] sampsL, float[] sampsR)
  {
    beat.detect(source.mix);
  }
}

