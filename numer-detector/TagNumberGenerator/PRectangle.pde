public class PRectangle
{
  public PVector position;
  public float width;
  public float height;

  public PRectangle()
  {
    position = new PVector();
  }

  public PRectangle(float x, float y, float width, float height)
  {
    this(new PVector(x, y), width, height);
  }

  public PRectangle(PVector position, float width, float height)
  {
    this.position = position;
    this.width = width;
    this.height = height;
  }
}
