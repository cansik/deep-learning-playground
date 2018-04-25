public class TagFont
{
  String name;
  PFont font;
  int size;

  public TagFont(String name, int size)
  {
    this.name = name;
    this.size = size;
  }

  public void init()
  {
    font = createFont(name, size);

    if (font == null)
      print("could not load font " + name);
  }
}
