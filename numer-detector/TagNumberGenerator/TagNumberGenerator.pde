
// settings
boolean debug = true;
long seed = 123456789;
int count = 10;
String[] chars = "V1234567890".split("");
int[] counters = new int[chars.length];

int minLength = 1;
int maxLength = 5;

float tagWHRatio = 0.5f;

float minFontSize = 14;
float maxFontSize = 120;

float tagMargin = 1.5;

float maxAffineTransform = 0.2f;

float backgroundDustProbability = 0.9;
float foregroundDustProbability = 0.9;

TagColor[] colors = new TagColor[] {
  new TagColor(color(255.0), color(0.0)), 
  new TagColor(color(0.0), color(255.0)), 
  new TagColor(color(255.0, 255.0, 100.0), color(0.0))
};

TagFont[] fonts = new TagFont[] { 
  new TagFont("Impact", 18), 
  new TagFont("Arial Black", 18), 
  new TagFont("Helvetica Neue Bold", 18)
};

PImage[] dustImages;

int[] backgroundBlendModes = new int[] {SCREEN, MULTIPLY};
int[] foregroundBlendModes = new int[] {ADD, LIGHTEST, EXCLUSION, SCREEN};

// vars
int iteration = 0;

ExtendedRandom rnd = new ExtendedRandom(seed);

void setup()
{
  size(500, 500, P2D);
  frameRate(debug ? 1 : 240);

  // setup fonts
  for (TagFont font : fonts)
  {
    font.init();
  }

  // setup dust
  dustImages = loadImageSet("data/dust/", ".jpg");
}

void draw()
{
  background(55);

  // create tag
  PImage tag = createTag();
  image(tag, width / 2 - (tag.width / 2), height / 2 - (tag.height / 2));

  iteration++;

  if (iteration > count)
  {
    printCounters();
    exit();
  }
}

PImage createTag()
{
  TagFont font = fonts[rnd.randomInt(fonts.length - 1)];
  TagColor tagColor = colors[rnd.randomInt(colors.length - 1)];

  float fontSize = rnd.randomFloat(minFontSize, maxFontSize);

  int textLength = rnd.randomInt(minLength, maxLength);

  // read characters
  String number = "";
  for (int i = 0; i < textLength; i++)
  {
    int index = rnd.randomInt(chars.length - 1);
    number += chars[index];
    counters[index]++;
  }

  // create characters
  int tagWidth = 0;
  int tagHeight = 0;

  PImage[] characters = new PImage[number.length()];
  for (int i = 0; i < characters.length; i++)
  {
    characters[i] = generateCharacter(number.charAt(i) + "", font, tagColor.foreground, Math.round(fontSize));

    // calculate tag size
    tagWidth += characters[i].width;
    tagHeight = max(tagHeight, characters[i].height);
  }

  // calculate tag size
  PGraphics tag = createGraphics(Math.round(tagWidth * tagMargin), Math.round(tagHeight * tagMargin), P2D);

  tag.beginDraw();
  tag.background(tagColor.background);

  // add background noise
  if (rnd.randomBoolean(backgroundDustProbability))
  {
    addDust(tag, backgroundBlendModes);
  }

  PRectangle[] boundingBoxes = new PRectangle[number.length()];

  int w = 0;
  for (int i = 0; i < characters.length; i++)
  {
    PShape shape = randomRotateSkewTransformImage(tag, characters[i], 
      w + tag.width / 2 - (tagWidth / 2f), 
      tag.height / 2 - (tagHeight / 2f));
    PRectangle rect = boundingBox(shape);
    boundingBoxes[i] = rect;
    w += characters[i].width;
  }

  // add dust
  if (rnd.randomBoolean(foregroundDustProbability))
  {
    addDust(tag, foregroundBlendModes);
  }

  // draw bounding boxes
  for (int i = 0; i < boundingBoxes.length; i++)
  {
    // draw rect
    PRectangle rect = boundingBoxes[i];
    tag.noFill();
    tag.stroke(255, 0, 255);
    tag.rect(rect.position.x, rect.position.y, rect.width, rect.height);
  }

  tag.endDraw();

  return tag;
}

void addDust(PGraphics graphics, int[] blendModes)
{
  PImage dust = dustImages[rnd.randomInt(dustImages.length - 1)];
  int blendMode = blendModes[rnd.randomInt(blendModes.length - 1)];

  graphics.blendMode(blendMode);
  graphics.image(dust, 0, 0, graphics.width, graphics.height, rnd.randomInt(0, dust.width), rnd.randomInt(0, dust.height), rnd.randomInt(0, dust.width), rnd.randomInt(0, dust.height));
  //graphics.image(dust, rnd.randomInt(0, -dust.width / 2), rnd.randomInt(0, -dust.height / 2), rnd.randomInt(graphics.width, dust.width / 2), rnd.randomInt(graphics.height, dust.height / 2));
  graphics.blendMode(BLEND);
}

PShape randomRotateSkewTransformImage(PGraphics g, PImage image, float x, float y)
{
  float dx1 = rnd.randomFloat(image.width * -maxAffineTransform, image.width * maxAffineTransform);
  float dy1 = rnd.randomFloat(image.height * -maxAffineTransform, image.height * maxAffineTransform);

  float dx2 = rnd.randomFloat(image.width * -maxAffineTransform, image.width * maxAffineTransform);
  float dy2 = rnd.randomFloat(image.height * -maxAffineTransform, image.height * maxAffineTransform);

  float sx1 = rnd.randomBoolean() ? 1 : -1;
  float sy1 = rnd.randomBoolean() ? 1 : -1;
  float sx2 = rnd.randomBoolean() ? 1 : -1;
  float sy2 = rnd.randomBoolean() ? 1 : -1;

  return affineTransformImage(g, image, x, y, dx1 * sx1, dy1 * sy1, dx1 * sx2, dy2 * sy1, dx2 * sx1, dy2 * sy1, dx2 * sx1, dy1 * sy2);
}


PShape randomSkewTransformImage(PGraphics g, PImage image, float x, float y)
{
  float dx1 = rnd.randomFloat(image.width * -maxAffineTransform, image.width * maxAffineTransform);
  float dy1 = rnd.randomFloat(image.height * -maxAffineTransform, image.height * maxAffineTransform);

  float dx2 = rnd.randomFloat(image.width * -maxAffineTransform, image.width * maxAffineTransform);
  float dy2 = rnd.randomFloat(image.height * -maxAffineTransform, image.height * maxAffineTransform);

  return affineTransformImage(g, image, x, y, dx1, dy1, dx1, dy2, dx2, dy2, dx2, dy1);
}


PShape randomAffineTransformImage(PGraphics g, PImage image, float x, float y)
{
  float dx1 = rnd.randomFloat(image.width * -maxAffineTransform, image.width * maxAffineTransform);
  float dy1 = rnd.randomFloat(image.height * -maxAffineTransform, image.height * maxAffineTransform);
  float dx2 = rnd.randomFloat(image.width * -maxAffineTransform, image.width * maxAffineTransform);
  float dy2 = rnd.randomFloat(image.height * -maxAffineTransform, image.height * maxAffineTransform);
  float dx3 = rnd.randomFloat(image.width * -maxAffineTransform, image.width * maxAffineTransform);
  float dy3 = rnd.randomFloat(image.height * -maxAffineTransform, image.height * maxAffineTransform);
  float dx4 = rnd.randomFloat(image.width * -maxAffineTransform, image.width * maxAffineTransform);
  float dy4 = rnd.randomFloat(image.height * -maxAffineTransform, image.height * maxAffineTransform);

  return affineTransformImage(g, image, x, y, dx1, dy1, dx2, dy2, dx3, dy3, dx4, dy4);
}

PShape affineTransformImage(PGraphics g, PImage image, float x, float y)
{
  return affineTransformImage(g, image, x, y, 0, 0, 0, 0, 0, 0, 0, 0);
}

PShape affineTransformImage(PGraphics g, PImage image, float x, float y, float dx1, float dy1, float dx2, float dy2, float dx3, float dy3, float dx4, float dy4)
{
  PShape s = createShape();
  s.beginShape();
  s.noStroke();
  s.textureMode(NORMAL);
  s.texture(image);
  s.vertex(x + dx1, y + dy1, 0, 0);
  s.vertex(x + image.width + dx2, y + dy2, 1, 0);
  s.vertex(x + image.width + dx3, y + image.height + dy3, 1, 1);
  s.vertex(x + dx4, y + image.height + dy4, 0, 1);
  s.endShape();

  g.shape(s);
  return s;
}

PRectangle boundingBox(PShape shape)
{
  PVector tl = new PVector(Float.MAX_VALUE, Float.MAX_VALUE);
  PVector br = new PVector(Float.MIN_VALUE, Float.MIN_VALUE);

  for (int i = 0; i < shape.getVertexCount(); i++)
  {
    PVector v = shape.getVertex(i);
    tl.x = min(v.x, tl.x);
    tl.y = min(v.y, tl.y);

    br.x = max(v.x, br.x);
    br.y = max(v.y, br.y);
  }

  return new PRectangle(tl, br.x - tl.x, br.y - tl.y);
}

PImage generateCharacter(String character, TagFont font, color foreground, int fontSize)
{

  textFont(font.font);
  textSize(fontSize);

  PGraphics img = createGraphics((int)Math.ceil(textWidth(character) * 1.0), Math.round(textAscent() - textDescent()));

  img.beginDraw();
  img.background(0, 0);
  img.textFont(font.font);
  img.textSize(fontSize);

  img.noStroke();
  img.fill(foreground);

  img.textAlign(CENTER, CENTER);
  img.text(character, img.width / 2, img.height / 2f - (textDescent() / 1.75f));

  img.endDraw();

  return img;
}

void printCounters()
{
  print("Counters: ");
  for (int i = 0; i < counters.length; i++)
  {
    print(chars[i] + ": " + counters[i] + "\t");
  }
  println();
}

String[] listFileNames(String dir, String extension) {
  File file = new File(dir);
  if (file.isDirectory()) {
    String names[] = file.list();
    ArrayList<String> specific = new ArrayList<String>();

    for (int i = 0; i < names.length; i++)
      if (names[i].endsWith(".jpg"))
        specific.add(names[i]);

    String[] result = new String[specific.size()];
    for (int i = 0; i < result.length; i++)
    {
      result[i] = specific.get(i);
    }

    return result;
  } else {
    // If it's not a directory
    return null;
  }
}

PImage[] loadImageSet(String setPath, String extension)
{
  String imagePath = sketchPath(setPath);
  String[] files = listFileNames(imagePath, extension);
  PImage[] images = new PImage[files.length];
  for (int i = 0; i < files.length; i++)
  {
    images[i] = loadImage(imagePath + files[i]);
  }

  return images;
}

/*
# Tag:
 # foreground / background color (darket and brighter changes)
 # image size
 # font
 # font size
 # amount of charachters
 
 # Characters
 # charachter size
 # xy offset
 # rotation
 # scewing
 
 # Post
 # noise
 # rotation
 # scewing
 # color changes / exposure
 # post image resize
 */
