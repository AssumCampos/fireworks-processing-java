public class Particle 
{
  ParticleType _type;

  PVector _s = new PVector(10.0, 10.0, 0.0);   // Position (m)
  PVector _v = new PVector(0.0, 10.0, 0.0);   // Velocity (m/s)
  PVector _a;   // Acceleration (m/(s*s))
  PVector _F;   // Force (N)
  float _m = 2.0;   // Mass (kg)

  int _ttl = 100;   // Time to live (iterations)
  color _color;   // Color (RGB)
  
  final static int _particleSize = 7;   // Size (pixels)
  final static int _casingLength = 10;   // Length (pixels)

  Particle(ParticleType type, PVector s, PVector v, float m, int ttl, color c) 
  {
    _type = type;
    
    _s = s.copy();
    _v = v.copy();
    _m = m;

    _a = new PVector(0.0 ,0.0, 0.0);
    _F = new PVector(0.0, 0.0, 0.0);
   
    _ttl = ttl;
    _color = c;
  }

  void run() 
  {
    update();
    display();
  }

  void update() 
  {
    if (isDead())
      return;
      
    updateForce();
   
    // Codigo con la implementación de las ecuaciones diferenciales para actualizar el movimiento de la partícula  
    _a = PVector.div(_F, _m);
    _v.add(PVector.mult(_a, SIM_STEP));
    _s.add(PVector.mult(_v, SIM_STEP));
    
    _ttl--;

  }
  
  void updateForce()
  {
    // Código para calcular la fuerza que actua sobre la partícula
    PVector Fpeso  = PVector.mult(G, _m);     
    PVector FViento = new PVector();
    PVector viento = new PVector();

    viento = PVector.sub(_windVelocity, _v);    
    FViento = PVector.mult(viento, WIND_CONSTANT);
    
    _F = PVector.add(Fpeso, FViento);
  }
  
  PVector getPosition()
  {
    return _s;
  }

  void display() 
  {  
    // Código para dibujar la partícula. Se debe dibujar de forma diferente según si es la carcasa o una partícula normal
    switch(_type){
      case CASING:
        fill(_color);
        circle(_s.x, _s.y, _casingLength);
        break;
      case REGULAR_PARTICLE:
        fill(_color);
        circle(_s.x, _s.y, _particleSize);
        break;
    }
  }
    
  boolean isDead() 
  {
    if (_ttl < 0) 
      return true;
    else
      return false;
  }
}
