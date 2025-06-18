import 'package:cinefetch_app/animation/custom_animation.dart';
import 'package:flutter/material.dart';
import '../components/filter_dropdown.dart';
import '../components/filter_tag.dart';
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
  final _searchResultController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  bool _showFilters = false;
  bool _isSearching = false;
  Map<String, String> _activeFilters = {};
  int _selectedIndex = 0;
  final List<String> _toggleLabels = ["Latest", "Featured", "Trending"];
  List<Movie> allMovies = [];
  List<Movie> displayedMovies = [];
  List<Movie> searchResults = [];
  int currentPage = 1;
  final int moviesPerPage = 8;

  @override
  void initState() {
    super.initState();
    _updateMovieList();

    // Listen for text changes in search field
    _searchResultController.addListener(_onSearchTextChanged);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchResultController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchTextChanged() {
    if (_searchResultController.text.isEmpty) {
      setState(() {
        _isSearching = false;
      });
    }
  }

  void _performSearch() {
    final query = _searchResultController.text.trim().toLowerCase();

    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _searchFocusNode.unfocus();
      });
      return;
    }

    setState(() {
      _isSearching = true;
      // Filter movies based on search query
      searchResults = allMovies.where((movie) {
        return movie.title.toLowerCase().contains(query);
      }).toList();

      _searchFocusNode.unfocus();
    });
  }

  void _clearSearch() {
    setState(() {
      _searchResultController.clear();
      _isSearching = false;
      _searchFocusNode.unfocus();
    });
  }

  void _applyFilters(Map<String, String> filters) {
    setState(() {
      _activeFilters = filters;
    });
  }

  void _updateMovieList() {
    setState(() {
      int i = 0;
      currentPage = 1;
      switch (_selectedIndex) {
        case 0: // Latest
          allMovies = Movie.sampleMovies;
          break;
        case 1: // Featured
          allMovies = Movie.sampleMovies;
          break;
        case 2: // Trending
          allMovies = Movie.sampleMovies;
          break;
        default:
          allMovies = [];
      }
      // switch (_selectedIndex) {
      //   case 0:
      //     allMovies = [
      //       for (i = 0; i < 40; i++) ...[
      //         Movie(
      //           title: "Iron Man",
      //           year: "2008",
      //           imagePath: "assets/movies/iron_man_2008.jpg",
      //         ),
      //         Movie(
      //           title: "Avengers Infinity War",
      //           year: "2018",
      //           imagePath: "assets/movies/avengers_inf_war_2018.jpg",
      //         ),
      //         Movie(
      //           title: "Thor Dark World",
      //           year: "2017",
      //           imagePath: "assets/movies/thor_d_world_2013.jpg",
      //         ),
      //       ],
      //     ];
      //     break;
      //   case 2:
      //     allMovies = [
      //       Movie(
      //         title: "Batman Dark Knight",
      //         year: "2008",
      //         imagePath: "assets/movies/dark_knight_2008.jpg",
      //       ),
      //       Movie(
      //         title: "Spider-Man No Way Home",
      //         year: "2021",
      //         imagePath: "assets/movies/spiderman_nowayhome_2021.jpg",
      //       ),
      //       Movie(
      //         title: "Dune",
      //         year: "2021",
      //         imagePath: "assets/movies/dune_2021.jpg",
      //       ),
      //       Movie(
      //         title: "Top Gun: Maverick",
      //         year: "2022",
      //         imagePath: "assets/movies/topgun_2022.jpg",
      //       ),
      //       Movie(
      //         title: "Avatar: The Way of Water",
      //         year: "2022",
      //         imagePath: "assets/movies/avatar2_2022.jpg",
      //       ),
      //       Movie(
      //         title: "Everything Everywhere All at Once",
      //         year: "2022",
      //         imagePath: "assets/movies/eeaao_2022.jpg",
      //       ),
      //     ];
      //     break;
      //   default:
      //     allMovies = [];
      // }
      _updateDisplayedMovies();
    });
  }

  void _updateDisplayedMovies() {
    final startIndex = (currentPage - 1) * moviesPerPage;
    final endIndex = startIndex + moviesPerPage;
    setState(() {
      displayedMovies = allMovies.sublist(
        startIndex.clamp(0, allMovies.length),
        endIndex.clamp(0, allMovies.length),
      );
    });
  }

  void _changePage(int page) {
    setState(() {
      currentPage = page;
      _updateDisplayedMovies();
    });
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
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

  Widget _buildSearchResults() {
    if (searchResults.isEmpty) {
      return const Center(
        child: Text(
          'No movies found',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontFamily: "Quicksand",
          ),
        ),
      );
    }

    return GridView.builder(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.52,
        crossAxisSpacing: 30,
        mainAxisSpacing: 5,
      ),
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        return MovieCard(movie: searchResults[index]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalPages = (allMovies.length / moviesPerPage).ceil();
    final hasActiveFilters = _activeFilters.isNotEmpty;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF020912),
      resizeToAvoidBottomInset: false,
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
          // Background Image
          Positioned.fill(
            child: Opacity(
              opacity: 0.09,
              child: Image.asset(
                "assets/page_background.png",
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Main Content
          SafeArea(
            top: true,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  const SizedBox(height: 25),

                  // Search Bar
                  CustomAnimation(
                    0.5,
                    type: AnimationType.fadeSlide,
                    TextField(
                      controller: _searchResultController,
                      focusNode: _searchFocusNode,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (value) => _performSearch(),
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (_searchResultController.text.isNotEmpty)
                                IconButton(
                                  icon: const Icon(
                                    Icons.clear,
                                    color: Colors.white,
                                  ),
                                  onPressed: _clearSearch,
                                ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.lightBlueAccent.withOpacity(
                                    0.8,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.search,
                                    color: Colors.white,
                                    size: 26,
                                  ),
                                  onPressed: _performSearch,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      style: const TextStyle(
                        color: Color.fromARGB(255, 204, 228, 246),
                        fontSize: 18,
                        fontFamily: "Quicksand",
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Only show filters and toggle buttons when not in search mode
                  if (!_isSearching) ...[
                    // Filter Tag
                    CustomAnimation(
                      0.5,
                      type: AnimationType.bounce,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: FilterTag(
                          onPressed: () =>
                              setState(() => _showFilters = !_showFilters),
                          hasActiveFilters: hasActiveFilters,
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // Toggle Buttons
                    CustomAnimation(
                      0.4,
                      type: AnimationType.fadeSlide,
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
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
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
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
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
                    ),
                  ],

                  const SizedBox(height: 30),

                  // Movie Grid with Pagination or Search Results
                  Expanded(
                    child: Stack(
                      children: [
                        if (_isSearching)
                          _buildSearchResults()
                        else
                          // Normal movie grid
                          displayedMovies.isEmpty
                              ? const Center(
                                  child: Text(
                                    'No movies found',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              : CustomAnimation(
                                  0.35,
                                  type: AnimationType.fadeSlide,
                                  GridView.builder(
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
                                      return MovieCard(
                                        movie: displayedMovies[index],
                                      );
                                    },
                                  ),
                                ),

                        // Pagination Controls (only show when not in search mode)
                        if (!_isSearching && totalPages > 1)
                          Positioned(
                            bottom: 10,
                            left: 0,
                            right: 0,
                            child: PaginationControls(
                              currentPage: currentPage,
                              totalPages: totalPages,
                              onPageChanged: _changePage,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Filter Dropdown Overlay (only show when not in search mode)
          if (_showFilters && !_isSearching)
            Positioned(
              top: 180, // Adjusted position below search and filter tag
              left: 20,
              right: 20,
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(12),
                color: Colors.transparent,
                child: FilterDropdown(
                  onClose: () => setState(() => _showFilters = false),
                  onApply: _applyFilters,
                  initialFilters: _activeFilters,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
