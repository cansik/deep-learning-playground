import java.util.Random;

public class ExtendedRandom
{
  private Random r;

  public ExtendedRandom()
  {
    this(System.currentTimeMillis());
  }

  public ExtendedRandom(long seed)
  {
    r = new Random(seed);
  }

  public boolean randomBoolean()
  {
    return randomBoolean(0.5f);
  }

  public boolean randomBoolean(float value)
  {
    return randomFloat() <= value;
  }

  public float randomFloat ()
  {
    return randomFloat(1f);
  }

  public float randomFloat (float max)
  {
    return randomFloat(0f, max);
  }

  public float randomFloat (float min, float max)
  {
    return min + r.nextFloat() * (max - min);
  }

  public int randomInt()
  {
    return randomInt(1);
  }

  public int randomInt(int max)
  {
    return randomInt(0, max);
  }

  public int randomInt(int min, int max)
  {
    return Math.round(randomFloat(min, max));
  }
}
