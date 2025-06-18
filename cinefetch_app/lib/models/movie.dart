// class Movie {
//   final String title;
//   final String year;
//   final String imagePath;
//   final String? description; // Add more fields as needed
//   final String? imdbrating;
//   final String? rottentomatoes;
//   final String? audiencescore;
//   final String? duration;
//   final List<String>? genres;
//   final String? cast;

//   const Movie({
//     required this.title,
//     required this.year,
//     required this.imagePath,
//     this.description,
//     this.imdbrating,
//     this.rottentomatoes,
//     this.audiencescore,
//     this.duration,
//     this.genres,
//     this.cast,
//   });
// }

class Movie {
  final String title;
  final String year;
  final String imagePath;
  final String? description;
  final String? imdbrating;
  final String? rottentomatoes;
  final String? audiencescore;
  final String? duration;
  final List<String>? genres;
  final List<Actor>? cast;

  const Movie({
    required this.title,
    required this.year,
    required this.imagePath,
    this.description,
    this.imdbrating,
    this.rottentomatoes,
    this.audiencescore,
    this.duration,
    this.genres,
    this.cast,
  });

  // Example movies list
  static List<Movie> sampleMovies = [
    // Movie(
    //   title: "Inception",
    //   year: "2010",
    //   imagePath: "assets/images/inception.jpg",
    //   description: "A thief who steals corporate secrets through the use of dream-sharing technology is given the inverse task of planting an idea into the mind of a C.E.O.",
    //   imdbrating: "8.8",
    //   rottentomatoes: "87%",
    //   audiencescore: "91%",
    //   duration: "2h 28m",
    //   genres: ["Action", "Adventure", "Sci-Fi"],
    //   cast: [
    //     Actor(
    //       name: "Leonardo DiCaprio",
    //       imagePath: "assets/images/leonardo.jpg",
    //       character: "Cobb"
    //     ),
    //     Actor(
    //       name: "Joseph Gordon-Levitt",
    //       imagePath: "assets/images/joseph.jpg",
    //       character: "Arthur"
    //     ),
    //     Actor(
    //       name: "Ellen Page",
    //       imagePath: "assets/images/ellen.jpg",
    //       character: "Ariadne"
    //     ),
    //     Actor(
    //       name: "Tom Hardy",
    //       imagePath: "assets/images/tom.jpg",
    //       character: "Eames"
    //     ),
    //   ],
    // ),
    Movie(
      title: "The Dark Knight",
      year: "2008",
      imagePath: "assets/movies/dark_knight_2008.jpg",
      description:
          "When the menace known as the Joker wreaks havoc and chaos on the people of Gotham, Batman must accept one of the greatest psychological and physical tests of his ability to fight injustice.",
      imdbrating: "9.0",
      rottentomatoes: "94%",
      audiencescore: "94%",
      duration: "2h 32m",
      genres: ["Action", "Crime", "Drama"],
      cast: [
        Actor(
          name: "Christian Bale",
          imagePath: "assets/cast/actor/christian_bale.jpg",
          character: "Bruce Wayne",
        ),
        Actor(
          name: "Heath Ledger",
          imagePath: "assets/cast/actor/heath_ledger.jpg",
          character: "Joker",
        ),
        Actor(
          name: "Aaron Eckhart",
          imagePath: "assets/cast/actor/aaron_eckhart.jpg",
          character: "Harvey Dent",
        ),
        Actor(
          name: "Gary Oldman",
          imagePath: "assets/cast/actor/gary_oldman.jpg",
          character: "James Gordan",
        ),
        Actor(
          name: "Maggie Gyllenhaal",
          imagePath: "assets/cast/actress/maggie_gyllenhaal.jpg",
          character: "Rachel Dawes",
        ),
        Actor(
          name: "Cillian Murphy",
          imagePath: "assets/cast/actor/cillian_murphy.jpg",
          character: "Scarecrow"
        ),
      ],
    ),
    Movie(
      title: "Interstellar",
      year: "2014",
      imagePath: "assets/movies/interstellar_2014.jpg",
      description: "A team of explorers travel through a wormhole in space in an attempt to ensure humanity's survival.",
      imdbrating: "8.6",
      rottentomatoes: "73%",
      audiencescore: "86%",
      duration: "2h 49m",
      genres: ["Adventure", "Drama", "Sci-Fi"],
      cast: [
        Actor(
          name: "Matthew McConaughey",
          imagePath: "assets/cast/actor/matthew_mcConaughey.jpg",
          character: "Cooper"
        ),
        Actor(
          name: "Anne Hathaway",
          imagePath: "assets/cast/actress/anne_hathaway.jpg",
          character: "Brand"
        ),
        Actor(
          name: "Jessica Chastain",
          imagePath: "assets/cast/actress/jessica_chastain.jpg",
          character: "Murph"
        ),
      ],
    ),
  ];
}

class Actor {
  final String name;
  final String imagePath;
  final String? character;

  const Actor({required this.name, required this.imagePath, this.character});
}
