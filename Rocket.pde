public class Rocket 
{
  RocketType _type;

  Particle _casing;
  ArrayList<Particle> _particles;

  PVector _launchPoint;
  PVector _launchVel;  
  PVector _explosionPoint;

  color _color;
  boolean _hasExploded;

  Rocket(RocketType type, PVector pos, PVector vel, color c) 
  {
    _type = type;
    _particles = new ArrayList<Particle>();

    _launchPoint = pos.copy();
    _launchVel = vel.copy();
    _explosionPoint = new PVector(0.0, 0.0, 0.0);

    _color = c;
    _hasExploded = false;

    createCasing();
  }

  void createCasing()
  {
    // Codigo para crear la carcasa
    float masa = 2.0;
    int ttl = 50;
    
    _casing = new Particle(ParticleType.CASING, _launchPoint, _launchVel, masa, ttl, _color);    
    _numParticles++;
  }

  void explosion() 
  {
    float angulo;
    PVector vel = new PVector();
    float masa = 1.0;
    int ttl = 200;
    
    // Codigo para utilizar el vector de partículas, creando particulas en él con diferentes velocidades para recrear distintos tipos de palmeras
    switch (_type)
    {
      case CIRCULO:
        for (int i = 0; i < 100; i++)
        {          
          angulo = random(0,TWO_PI);
          vel = new PVector(random(5,5.5),random(5,5.5));
          vel.x = 10*vel.x*cos(angulo);
          vel.y = 10*vel.y*sin(angulo);
          
          Particle _particula = new Particle(ParticleType.REGULAR_PARTICLE, _explosionPoint, vel, masa, ttl, _color);
          _particles.add(_particula);       

          _numParticles++;
        }
        break;
      case FLOWER:
        for (int i = 0; i < 150; i++)
        {
          angulo = random(0,TWO_PI);
          vel = new PVector(3-10*sin(3*angulo),3-10*sin(3*angulo));
          vel.x = 10*vel.x*cos(angulo);
          vel.y = 10*vel.y*sin(angulo);

          Particle _particula = new Particle(ParticleType.REGULAR_PARTICLE, _explosionPoint, vel, masa, ttl, _color);
          _particles.add(_particula);       

          _numParticles++;
        }
        break;
     case ESPIRAL:
       for (int i = 0; i < 150; i++)
       {
          angulo = random(0,2*TWO_PI);
          vel = new PVector(2*angulo,2*angulo);
          vel.x = 10*vel.x*cos(angulo);
          vel.y = 10*vel.y*sin(angulo);
        
          Particle _particula = new Particle(ParticleType.REGULAR_PARTICLE, _explosionPoint, vel, masa, ttl, _color);
         _particles.add(_particula);       

         _numParticles++;
        }
        break;
      case HEART:
        for (int i = 0; i < 150; i++)
        {
          angulo = random(0,2*TWO_PI);
          vel.x = -20*(3*sin(angulo)-1*sin(3*angulo));
          vel.y = -20*(3.25*cos(angulo)-1.25*cos(2*angulo)-0.5*cos(3*angulo)-0.25*cos(4*angulo));
          
          Particle _particula = new Particle(ParticleType.REGULAR_PARTICLE, _explosionPoint, vel, masa, ttl, _color);
          _particles.add(_particula);       
          
          _numParticles++;
        }
        

      break;
    }
  }

  void run() 
  {
    // Codigo con la lógica de funcionamiento del cohete. En principio no hay que modificarlo.
    // Si la carcasa no ha explotado, se simula su ascenso.
    // Si la carcasa ha explotado, se genera su explosión y se simulan después las partículas creadas.
    // Cuando una partícula agota su tiempo de vida, es eliminada.

    if (!_casing.isDead())
      _casing.run();
    else if (_casing.isDead() && !_hasExploded)
    {
      _numParticles--;
      _hasExploded = true;

      _explosionPoint = _casing.getPosition().copy();
      explosion();
    } 
    else
    {
      for (int i = _particles.size() - 1; i >= 0; i--) 
      {
        Particle p = _particles.get(i);
        p.run();

        if (p.isDead()) 
        {
          _numParticles--;
          _particles.remove(i);
        }
      }
    }
  }
}
