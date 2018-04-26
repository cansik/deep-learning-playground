PImage[] images;
String[] names;

int iteration = 0;

void setup()
{
  size(500, 500);

  images = loadImageSet("data/", ".jpg");
  names = listFileNames(sketchPath("data/"), ".jpg");
}

void draw()
{
  background(100);
  PImage img = images[iteration];

  translate(width / 2 - img.width / 2, height / 2 - img.height / 2);
  image(img, 0, 0);

  // read text
  String name = names[iteration].replace(".jpg", ".txt");
  println(name);
  String[] lines = loadStrings(sketchPath("data/" + name));

  // draw boxes
  for (int i = 0; i < lines.length; i++)
  {
    // parse
    String[] infos = lines[i].split(" ");
    int number = int(infos[0]);
    float mx = float(infos[1]);
    float my = float(infos[2]);
    float rw = float(infos[3]);
    float rh = float(infos[4]);

    noFill();
    strokeWeight(2);
    stroke(0, 255, 255);

    float w = rw * img.width;
    float h = rh * img.height;
    float x = mx * img.width - (w / 2.0);
    float y = my * img.height - (h / 2.0);

    rect(x, y, w, h);
  }

  iteration++;

  if (iteration >= names.length)
    exit();

  noLoop();
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


void keyPressed()
{
  loop();
}
