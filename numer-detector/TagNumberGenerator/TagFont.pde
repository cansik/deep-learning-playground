public class TagFont
{
  String name;
  PFont font;
  int size;
  boolean isTFF = false;

  public TagFont(String name, int size)
  {
    this(name, size, false);
  }

  public TagFont(String name, int size, boolean isTFF)
  {
    this.name = name;
    this.size = size;
    this.isTFF = isTFF;
  }

  public void init()
  {
    if (isTFF)
    {
      font = loadFont(name);
    } else
    {
      font = createFont(name, size);
    }

    if (font == null)
      print("could not load font " + name);
  }
}
