import 'package:cinefetch_app/components/compact_pagination.dart';
import 'package:flutter/material.dart';
import '../components/movie_card.dart';
import '../components/pagination_controls.dart';
import '../models/movie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  int _selectedIndex = 0;
  final List<String> _toggleLabels = ["Latest", "Featured", "Trending"];
  List<Movie> allMovies = [];
  List<Movie> displayedMovies = [];
  int currentPage = 1;
  final int moviesPerPage = 8;

  @override
  void initState() {
    super.initState();
    _updateMovieList();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _updateMovieList() {
    setState(() {
      int i = 0;
      currentPage = 1;
      switch (_selectedIndex) {
        case 0:
          allMovies = [
            for (i = 0; i < 100; i++)
              Movie(
                title: "Iron Man",
                year: "2008",
                imagePath: "assets/movies/iron_man_2008.jpg",
              ),

            // Movie(
            //   title: "Avengers Infinity War",
            //   year: "2018",
            //   imagePath: "assets/movies/avengers_inf_war_2018.jpg",
            // ),
            // Movie(
            //   title: "Thor Dark World",
            //   year: "2017",
            //   imagePath: "assets/movies/thor_d_world_2013.jpg",
            // ),
            // Movie(
            //   title: "Guardian of the Galaxy",
            //   year: "2014",
            //   imagePath: "assets/movies/gotg_2014.jpg",
            // ),
            // Movie(
            //   title: "Interstellar",
            //   year: "2014",
            //   imagePath: "assets/movies/interstellar_2014.jpg",
            // ),
            // Movie(
            //   title: "Black Panther",
            //   year: "2018",
            //   imagePath: "assets/movies/black_panther_2018.jpg",
            // ),
            // Movie(
            //   title: "Doctor Strange",
            //   year: "2016",
            //   imagePath: "assets/movies/doctor_strange_2016.jpg",
            // ),
            // Movie(
            //   title: "Captain America: Civil War",
            //   year: "2016",
            //   imagePath: "assets/movies/cap_am_civil_war_2016.jpg",
            // ),
            // Movie(
            //   title: "Avengers: Endgame",
            //   year: "2019",
            //   imagePath: "assets/movies/endgame_2019.jpg",
            // ),
            // Movie(
            //   title: "Spider-Man: Far From Home",
            //   year: "2019",
            //   imagePath: "assets/movies/far_from_home_2019.jpg",
            // ),
            // Movie(title: "Tenet", year: "2020", imagePath: "assets/movies/tenet_2020.jpg"),
            // Movie(title: "1917", year: "2019", imagePath: "assets/movies/1917_2019.jpg"),
            // Movie(title: "Parasite", year: "2019", imagePath: "assets/movies/parasite_2019.jpg"),
          ];
          break;
        case 2:
          allMovies = [
            Movie(
              title: "Batman Dark Knight",
              year: "2008",
              imagePath: "assets/movies/dark_knight_2008.jpg",
            ),
            Movie(
              title: "Spider-Man No Way Home",
              year: "2021",
              imagePath: "assets/movies/spiderman_nowayhome_2021.jpg",
            ),
            Movie(
              title: "Dune",
              year: "2021",
              imagePath: "assets/movies/dune_2021.jpg",
            ),
            Movie(
              title: "Top Gun: Maverick",
              year: "2022",
              imagePath: "assets/movies/topgun_2022.jpg",
            ),
            Movie(
              title: "Avatar: The Way of Water",
              year: "2022",
              imagePath: "assets/movies/avatar2_2022.jpg",
            ),
            Movie(
              title: "Everything Everywhere All at Once",
              year: "2022",
              imagePath: "assets/movies/eeaao_2022.jpg",
            ),
            // Movie(title: "The Matrix Resurrections", year: "2021", imagePath: "assets/movies/matrix_4_2021.jpg"),
            // Movie(title: "No Time to Die", year: "2021", imagePath: "assets/movies/bond_2021.jpg"),
            // Movie(title: "Jurassic World Dominion", year: "2022", imagePath: "assets/movies/jurassic_2022.jpg"),
            // Movie(title: "The Suicide Squad", year: "2021", imagePath: "assets/movies/suicide_squad_2021.jpg"),
          ];
          break;
        default:
          allMovies = [];
      }
      _updateDisplayedMovies();
    });
  }

  void _updateDisplayedMovies() {
    final startIndex = (currentPage - 1) * moviesPerPage;
    final endIndex = startIndex + moviesPerPage;
    displayedMovies = allMovies.sublist(
      startIndex.clamp(0, allMovies.length),
      endIndex.clamp(0, allMovies.length),
    );
  }

  void _changePage(int page) {
    setState(() {
      currentPage = page;
      _updateDisplayedMovies();
    });
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }

  void _nextPage() {
    if (currentPage < (allMovies.length / moviesPerPage).ceil()) {
      _changePage(currentPage + 1);
    }
  }

  void _prevPage() {
    if (currentPage > 1) {
      _changePage(currentPage - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalPages = (allMovies.length / moviesPerPage).ceil();

    return Scaffold(
      backgroundColor: const Color(0xFF020912),
      appBar: AppBar(
        backgroundColor: const Color(0xFF020912),
        leading: IconButton(
          icon: const Icon(Icons.home, color: Colors.white),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
        title: const Row(
          children: [
            Text(
              'Cine',
              style: TextStyle(
                color: Color.fromARGB(255, 181, 229, 255),
                fontSize: 20,
                fontFamily: "Rosario",
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              'Fetch',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontFamily: "Rosario",
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.09,
              child: Image.asset(
                "assets/page_background.png",
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            top: true,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  const SizedBox(height: 25),
                  // Search Bar
                  TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFF7D96B7).withOpacity(0.55),
                      hintText: 'Search for movies, series, etc.',
                      hintStyle: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.lightBlueAccent.withOpacity(0.8),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.search,
                              color: Colors.white,
                              size: 26,
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ),
                    ),
                    style: const TextStyle(
                      color: Color.fromARGB(255, 204, 228, 246),
                      fontSize: 18,
                      fontFamily: "Rosario",
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 35),
                  // Toggle Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(_toggleLabels.length, (index) {
                      final isActive = _selectedIndex == index;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedIndex = index;
                              _updateMovieList();
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: isActive
                                  ? const Color.fromARGB(255, 23, 51, 90)
                                  : const Color(0xFF4174BA),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _toggleLabels[index],
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: "Quicksand",
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  height: 3,
                                  width: isActive ? 60 : 0,
                                  decoration: BoxDecoration(
                                    color: isActive
                                        ? Colors.lightBlueAccent
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 30),
                  // Responsive Movie Grid
                  Expanded(
                    child: displayedMovies.isEmpty
                        ? const Center(
                            child: Text(
                              'No movies found',
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        : GridView.builder(
                            controller: _scrollController,
                            physics: const BouncingScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.52,
                                  crossAxisSpacing: 30,
                                  mainAxisSpacing: 5,
                                ),
                            itemCount: displayedMovies.length,
                            itemBuilder: (context, index) {
                              return MovieCard(movie: displayedMovies[index]);
                            },
                          ),
                  ),
                  // Compact Pagination Controls
                  if (totalPages > 1)
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 20),
                      child: PaginationControls(
                        currentPage: currentPage,
                        totalPages: totalPages,
                        onPageChanged: _changePage,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
