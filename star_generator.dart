import 'dart:io';
import 'dart:math';

class StarGenerator {
  static void CreatePolygonSVG(
      double cx, double cy, double startAngle, String inputFile,
      {int sides = 6, double radius = 300, String color = "black"}) {
    // Generate points for the polygon
    final points = List.generate(sides, (i) {
      //compute the angle between two edges (360 degrees in total in a polygon)
      // --> 360/corners is the angle at every corner
      double angle = i * (2 * pi / sides) + startAngle;
      double x = cx + radius * cos(angle);
      double y = cy + radius * sin(angle);

      //return x,y as list of strings to add them to the 'points' of polygon svg
      //as parameter
      return '${x.toStringAsFixed(2)},${y.toStringAsFixed(2)}';
    }).join(' ');

    //save the existing content from the input file in a variable
    final file = File(inputFile);
    final svgContent = file.readAsStringSync();

    //creating the polygon with the calculated points
    final polygon = '''
      <polygon points="$points" fill="$color" stroke="black" stroke-width="2" />
    ''';

    //finding the end of the input file and adding the created polygon
    final updatedSvgContent =
        svgContent.replaceFirst('</svg>', '$polygon</svg>');

    file.writeAsStringSync(updatedSvgContent);
  }

  static void CreateStarSVG(
      double cx, double cy, double startAngle, String inputFile,
      {int points = 5,
      double outerRadius = 300,
      double innerRadius = 150,
      String color = "white"}) {
    //list of points consists of the outer point(the top of the spikes) and the
    //inner points(the bottom of the spikes).
    //
    //inner points are laying on a circle with value of 'innerRadius'
    //outer points are laying on a circle with value of 'outerRadius'
    final pointsList = <String>[];

    for (int i = 0; i < points * 2; i++) {
      //Determine whether to use the outer or inner radius by checking if we
      //are on even or uneven index
      //even index is the outer radius and uneven the inner radius
      //calculations for the points are the same as the calculations
      //for a polygon
      //we basically just create two polygons that are shifted by a
      //specific degree and the points are just connected inbetween them
      double angle = i * (2 * pi / (points * 2)) + startAngle;
      double radius = (i % 2 == 0) ? outerRadius : innerRadius;

      double x = cx + radius * cos(angle);
      double y = cy + radius * sin(angle);

      pointsList.add('${x.toStringAsFixed(2)},${y.toStringAsFixed(2)}');
    }

    //Save the existing content from the input file in a variable
    final file = File(inputFile);
    final svgContent = file.readAsStringSync();

    //Create the star polygon
    final starPolygon = '''
      <polygon points="${pointsList.join(' ')}" fill="$color" stroke="black" stroke-width="2" >
          <animateTransform attributeName="transform" type="rotate"
      from="0 $cx $cy" to="360 $cx $cy"
      dur="4s" repeatCount="indefinite"/>
      </polygon>
    ''';

    //Find the end of the input file and add the created star polygon
    final updatedSvgContent =
        svgContent.replaceFirst('</svg>', '$starPolygon</svg>');

    //update the input file with the updated content
    file.writeAsStringSync(updatedSvgContent);
  }
}

void main() {
  StarGenerator.CreateStarSVG(
      600, 500, 0, "ueb5_nachname1_nachname2_nachname3.svg",
      color: "#ffd700", innerRadius: 50, outerRadius: 100);
}
