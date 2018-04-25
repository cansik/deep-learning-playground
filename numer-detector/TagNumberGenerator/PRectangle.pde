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

  public String relativeText(double w, double h)
  {
    double rx1 = (position.x + (this.width / 2f)) / w;
    double ry1 = (position.y + (this.height / 2f)) / h;
    double rx2 = this.width / w;
    double ry2 = this.height / h;

    return rx1 + " " + ry1 + " " + rx2 + " " + ry2;
  }
}
