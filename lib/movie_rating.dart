import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class Movie {
  final String name;
  final String description;
  final List<String> review;
  final List<double> rating;
  final String img;
  final List<List<String>> cast;

  Movie({
    required this.name,
    required this.description,
    required this.review,
    required this.rating,
    required this.img,
    required this.cast,
  });

  double getAvgRating() {
    return rating.reduce((a, b) => a + b) / rating.length;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var movies = [
    Movie(
      name: "Interstellar",
      description:
      "Interstellar is about Earth's last chance to find a habitable planet before a lack of resources causes the human race to go extinct.",
      review: [
        "A nice thriller with good screen play",
        "One of the best movies ever watched"
      ],
      rating: [9.9, 9.8],
      img: "assets/interstellar.jpg",
      cast: [
        ["Matthew McConaughey", "assets/matthew.jpeg"],
        ["Jessica Chastain", "assets/jess.jpeg"],
        ["Timothée Chalamet", "assets/tim.jpeg"],
        ["Anne Hathaway", "assets/anne.jpeg"],
        ["Matt Damon", "assets/matt.jpeg"],
      ],
    ),
    Movie(
      name: "One Piece",
      description:
      "The series follows Monkey D. Luffy and his crew as they search for the mythical treasure known as the One Piece.",
      review: [
        "The greatest story ever told",
        "This has everything from thriller to action"
      ],
      rating: [10.0, 9.9],
      img: "assets/op.jpeg",
      cast: [
        ["Monkey D. Luffy", "assets/luffy.jpeg"],
        ["Roronoa Zoro", "assets/zoro.jpeg"],
        ["Nami", "assets/nami.jpeg"],
        ["Sanji", "assets/sanji.jpg"],
        ["Red-Haired Shanks", "assets/shanks.png"],
      ],
    ),
    Movie(
      name: "The Pursuit of Happyness",
      description:
      "The story of a struggling salesman who never gave up trying to find happiness for himself and his son.",
      review: [
        "A fantastic movie with a nice message!",
        "Will Smith nailed it."
      ],
      rating: [9.7, 9.8],
      img: "assets/poh.jpeg",
      cast: [
        ["Will Smith", "assets/will.jpeg"],
        ["Jaden Smith", "assets/jade.jpeg"],
        ["Chris Gardner", "assets/chris.jpeg"],
      ],
    ),
    Movie(
      name: "Avatar: The Way of Water",
      description:
      "Jake Sully and his family face new challenges as they explore the oceans of Pandora.",
      review: [
        "Visually stunning!",
        "A beautiful sequel to the original Avatar."
      ],
      rating: [9.6, 9.4],
      img: "assets/avatar2.jpg",
      cast: [
        ["Sam Worthington", "assets/sam.jpeg"],
        ["Zoe Saldana", "assets/zoe.jpeg"],
        ["Sigourney Weaver", "assets/sigourney.jpeg"],
        ["Kate Winslet", "assets/kate.jpeg"],
      ],
    ),
    Movie(
      name: "Spider-Man: No Way Home",
      description:
      "Spider-Man faces multiversal villains with the help of his friends and allies.",
      review: [
        "An amazing culmination of Spider-Man stories.",
        "Great nostalgia and action-packed!"
      ],
      rating: [9.8, 9.7],
      img: "assets/spiderman.jpg",
      cast: [
        ["Tom Holland", "assets/tom.jpeg"],
        ["Zendaya", "assets/zendaya.jpeg"],
        ["Andrew Garfield", "assets/andrew.jpeg"],
        ["Tobey Maguire", "assets/tobey.jpeg"],
        ["Benedict Cumberbatch", "assets/benedict.jpeg"],
      ],
    ),
    Movie(
      name: "Inception",
      description:
      "A thief who steals corporate secrets through dreams is tasked with planting an idea in someone's subconscious.",
      review: [
        "Mind-bending and thrilling.",
        "A masterpiece by Nolan!"
      ],
      rating: [9.9, 9.8],
      img: "assets/inception.jpg",
      cast: [
        ["Leonardo DiCaprio", "assets/leo.jpeg"],
        ["Joseph Gordon-Levitt", "assets/joseph.jpeg"],
        ["Elliot Page", "assets/elliot.jpeg"],
        ["Tom Hardy", "assets/tom_hardy.jpeg"],
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(54, 0, 0, 0),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Text("+"),
      ),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Center(
          child: Text(
            "Movie Ratings Application",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: GridView.builder(
        gridDelegate:
        SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            child: MovieCard(movie: movies[index]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MoviePage(movie: movies[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class MovieCard extends StatelessWidget {
  final Movie movie;

  MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Color.fromARGB(172, 19, 19, 19),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: AspectRatio(
              aspectRatio: 3 / 2,
              child: Image.asset(movie.img, fit: BoxFit.cover),
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Text(
                    movie.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    "${movie.getAvgRating().toStringAsFixed(2)}/10",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MoviePage extends StatelessWidget {
  final Movie movie;

  MoviePage({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        title: Center(
          child: Text(
            movie.name,
          ),
        ),
      ),
      body: ListView(
        children: [
          Image.asset(
            movie.img,
            fit: BoxFit.fill,
          ),
          Container(
            margin: EdgeInsets.all(8),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: Text(
              movie.description,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: 10,
              bottom: 18,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FloatingActionButton(
                  onPressed: () {},
                  child: Icon(
                    Icons.share,
                  ),
                ),
                FloatingActionButton(
                  onPressed: () {},
                  child: Icon(
                    Icons.thumbs_up_down,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 250,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: movie.cast.length,
              itemBuilder: (context, index) => Card(
                child: CastCard(
                  name: movie.cast[index][0],
                  path: movie.cast[index][1],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CastCard extends StatelessWidget {
  final String name;
  final String path;

  CastCard({required this.name, required this.path});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          path,
          height: 100,
          width: 100,
          fit: BoxFit.cover,
        ),
        Text(name),
      ],
    );
  }
}
