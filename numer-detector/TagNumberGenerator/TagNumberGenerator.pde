
// settings
int count = 20;
String[] chars = "1234567890".split("");

int minLength = 1;
int maxLength = 5;

float tagWHRatio = 0.5f;

float minFontSize = 14;
float maxFontSize = 100;

TagColor[] colors = new TagColor[] {
  new TagColor(color(255.0), color(0.0)), 
  new TagColor(color(0.0), color(255.0)), 
  new TagColor(color(255.0, 255.0, 100.0), color(0.0))
};

TagFont[] fonts = new TagFont[] { 
  new TagFont("Impact", 18), 
  new TagFont("Arial Black", 18), 
  new TagFont("SFCompactDisplay-Black", 18)
};

// vars
int iteration = 0;

ExtendedRandom rnd = new ExtendedRandom(123456789);

void setup()
{
  size(500, 500);
  frameRate(1);

  // setup fonts
  for (TagFont font : fonts)
  {
    font.init();
  }
}

void draw()
{
  background(55);

  // create tag
  PImage tag = createTag();
  image(tag, width / 2 - (tag.width / 2), height / 2 - (tag.height / 2));

  // create characters

  // add characters to tag

  // posprocess tag

  // save

  // display

  iteration++;

  if (iteration > count)
    exit();
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
    number += rnd.randomInt(chars.length - 1);
  }

  println("Tag '" + number + "'");

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
  PGraphics tag = createGraphics(Math.round(tagWidth), Math.round(tagHeight));

  tag.beginDraw();
  tag.background(tagColor.background);

  int w = 0;
  for (int i = 0; i < characters.length; i++)
  {
    tag.image(characters[i], w, 0);
    w += characters[i].width;
  }
  tag.endDraw();

  return tag;
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

  /*
  img.stroke(foreground);
   img.noFill();
   img.rect(0, 0, img.width - 1, img.height - 1);
   */

  img.endDraw();

  return img;
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
