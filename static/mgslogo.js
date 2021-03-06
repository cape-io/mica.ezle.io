view.viewSize = [300, 300];

// Array of object connections
var connections = [
  [0,1],
  [0,5],
  [0,8],
  [0,9],
  [1,2],
  [1,5],
  [1,9],
  [2,3],
  [2,5],
  [3,4],
  [3,6],
  [3,8],
  [4,6],
  [4,8],
  [5,8],
  [5,9],
  [6,7],
  [6,8],
  [6,10],
  [7,10],
  [7,12],
  [8,9],
  [8,10],
  [8,12],
  [8,13],
  [9,11],
  [9,12],
  [9,13],
  [10,13],
  [11,12],
  [12,13],
  [12,14],
  [13,14]
];

// The amount of symbol we want to place;
var count = 15;

// Create a symbol, which we will use to place instances of later:
var path = new Path.Circle({
  center: new Point(0, 0),
  radius: 5,
  fillColor: 'magenta',
  strokeColor: 'magenta',
  strokeWidth: 0
});

var symbol = new Symbol(path);

// Place the instances of the symbol:
for (var i = 0; i < count; i++) {
  var center = new Point(
    randomIntFromInterval(20,view.bounds.width-20),
    randomIntFromInterval(20,view.bounds.height-20)
  );

  var placed = symbol.place(center);
  placed.data.vector = new Point({
    angle: Math.random() * 360,		// initial angle of movement
    length: Math.random() / 7		// speed of movement
  });

  var scale = {
    currentScale: 1,
    direction: (Math.round(Math.random())*2)-1,
    speed: Math.random() / 25
  };

  placed.data["scale"] = scale;
}

var connectionCount = connections.length; // number of connections to draw for this object

// draw all of our initial connections
for (var i = 0; i < connectionCount; i++) {
  var item = project.activeLayer.children[connections[i][0]]; // originating object
  var dItem = project.activeLayer.children[connections[i][1]]; // destination object

  var oPosition = item.position; // x and y position of object (start location for line)
  var dPosition = dItem.position; // x and y position of destination object (end location for line)

  var from = new Point(oPosition.x, oPosition.y);
  var to = new Point(dPosition.x, dPosition.y);

  var path = new Path.Line(from, to);
  path.strokeColor = 'magenta';
  path.strokeWidth = .5;
}

var vector = new Point({
  angle: 45,
  length: 0
});

var allCount = project.activeLayer.children.length;

// The onFrame function is called up to 60 times a second:
function onFrame(event) {
  // Run through the dots and update the position of the placed symbols:
  for (var i = 0; i < count; i++) {
    var item = project.activeLayer.children[i];
    var size = item.bounds.size;
    var length = vector.length / 10;

    var potentialPosition = item.position + vector.normalize(length) + item.data.vector;
    var potentialRadius = (item.bounds.width + (item.data.scale.speed * item.data.scale.direction)) / 2;

    // check to see if the items potential position and radius after scaling
    // will put the item outside the bounds of our canvas
    // which also results in the item getting "stuck" to an edge...

    // this is still pretty sloppy and not 100% perfect
    if ((potentialPosition.x - potentialRadius) <= 0) { // will exit left
      item.data.vector.angle = (180-item.data.vector.angle);
      item.position += (vector.normalize(length) + item.data.vector);
      // console.log("hit left");
    } else if ((potentialPosition.x + potentialRadius) >= view.bounds.width) { // will exit right
      item.data.vector.angle = (180-item.data.vector.angle);
      item.position += (vector.normalize(length) + item.data.vector);
      // console.log("hit right");
    } else if ((potentialPosition.y - potentialRadius) <= 0) { // will exit top
      item.data.vector.angle = (-item.data.vector.angle);
      item.position += (vector.normalize(length) + item.data.vector);
      // console.log("hit top");
    } else if ((potentialPosition.y + potentialRadius) >= view.bounds.height) { // will exit bottom
      item.data.vector.angle = (-item.data.vector.angle);
      item.position += (vector.normalize(length) + item.data.vector);
      // console.log("hit bottom");
    } else {
      // if everything is good, then move and scale as usual
      item.position += vector.normalize(length) + item.data.vector;
      item.bounds.width += item.data.scale.speed * item.data.scale.direction;
      item.bounds.height += item.data.scale.speed * item.data.scale.direction;
    }

    maintainScale(item); // check item scale
    keepInView(item); // keep item within bounds
  }

  for (var i = 0; i < connectionCount; i++) {
    var lineSegment = project.activeLayer.children[i+count];
    var startItem = project.activeLayer.children[connections[i][0]];
    var endItem = project.activeLayer.children[connections[i][1]];

    lineSegment.segments[0].point.x = startItem.position.x;
    lineSegment.segments[0].point.y = startItem.position.y;

    lineSegment.segments[1].point.x = endItem.position.x;
    lineSegment.segments[1].point.y = endItem.position.y;
  }
}

/*
  CUSTOM FUNCTIONS
*/

// Keep the object within the bounds of our canvas
function keepInView(item) {
  // exiting out right side
  if ((item.position.x + (item.bounds.width/2)) >= view.bounds.width) {
    item.data.vector.angle = (180-item.data.vector.angle);
  }

  // exiting out left size
  if ((item.position.x - (item.bounds.width/2)) <= 0) {
    item.data.vector.angle = (180-item.data.vector.angle);
  }

  // exiting out bottom
  if ((item.position.y + (item.bounds.height/2)) >= view.bounds.height) {
    item.data.vector.angle = (-item.data.vector.angle);
  }

  // exiting out top
  if ((item.position.y - (item.bounds.height/2)) <= 0) {
    item.data.vector.angle = (-item.data.vector.angle);
  }

  // if a dot should somehow get too far out of bounds (+-X units)
  // reset it's position to the center
  var outsideMargin = 0;
  if ((item.position.x < (0 - outsideMargin)) || (item.position.x > (view.bounds.width + outsideMargin))) {
    item.position.x = (view.bounds.width / 2);
    console.log("reset: too far out of bounds, x");
  }
  if ((item.position.y < (0 - outsideMargin)) || (item.position.y > (view.bounds.height + outsideMargin))) {
    item.position.y = (view.bounds.height /2);
    console.log("reset: too far out of bounds, y");
  }
}

// Make sure the scale of the object is within
// a given range, else, switch the scale direction
function maintainScale(item) {
  var small = 5; // smallest allowed size (diameter, not radius)
  var large = 20; // largest allowed size (diameter, not radius)

  if ((item.bounds.width >= large) || (item.bounds.width <= small))  {
    item.data.scale.direction *= -1; // reverse direction
  }
}

// Return a random interval in a given range
function randomIntFromInterval(min,max)
{
    return Math.floor(Math.random()*(max-min+1)+min);
}
