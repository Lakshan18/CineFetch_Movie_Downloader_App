import 'dart:async';

import 'package:cinefetch_app/animation/custom_animation.dart';
import 'package:cinefetch_app/services/network_service.dart';
import 'package:flutter/material.dart';
import '../components/filter_dropdown.dart';
import '../components/filter_tag.dart';
import '../components/movie_card.dart';
import '../components/pagination_controls.dart';
import '../components/side_panel.dart';
import '../models/movie.dart';
import '../repositories/movie_repository.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late StreamSubscription<bool> _connectionSubscription;
  bool _dialogShowing = false;

  final ScrollController _scrollController = ScrollController();
  final _searchResultController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final MovieRepository _movieRepository = MovieRepository();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _showFilters = false;
  bool _isSearching = false;
  bool _isDarkMode = true;
  Map<String, String> _activeFilters = {};
  int _selectedIndex = 0;
  final List<String> _toggleLabels = ["Latest", "Featured", "Trending"];
  List<Movie> allMovies = [];
  List<Movie> filteredMovies = [];
  List<Movie> paginatedMovies = [];
  List<Movie> searchResults = [];
  int currentPage = 1;
  final int moviesPerPage = 8;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    final networkService = Provider.of<NetworkService>(context, listen: false);

    _connectionSubscription = networkService.connectionChanges.listen((
      isConnected,
    ) {
      if (isConnected) {
        if (_dialogShowing) {
          Navigator.of(context).pop();
          _dialogShowing = false;
        }
        if (!_isLoading && allMovies.isEmpty) {
          _loadMovies();
        }
      } else {
        _handleNoConnection(networkService);
      }
    });

    if (networkService.isConnected) {
      _loadMovies();
    } else {
      _handleNoConnection(networkService);
    }

    _loadMovies();
    _searchResultController.addListener(_onSearchTextChanged);
  }

  
  void _handleNoConnection(NetworkService networkService) {
    if (!_dialogShowing) {
      _dialogShowing = true;
      networkService.showNoInternetDialog(context).then((_) {
        _dialogShowing = false;
      });
    }
  }


  Future<void> _loadMovies() async {
    setState(() => _isLoading = true);
    try {
      final querySnapshot = await _movieRepository.getAllMovies();
      setState(() {
        allMovies = querySnapshot;
        filteredMovies = List.from(allMovies);
        _sortMovies();
        _updateDisplayedMovies();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error loading movies: $e')));
    }
  }

  @override
  void dispose() {
    _connectionSubscription.cancel();

    _scrollController.dispose();
    _searchResultController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchTextChanged() {
    if (_searchResultController.text.isEmpty) {
      setState(() {
        _isSearching = false;
        currentPage = 1;
        _updateDisplayedMovies();
      });
    }
  }

  void _performSearch() {
    final query = _searchResultController.text.trim().toLowerCase();
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _searchFocusNode.unfocus();
        currentPage = 1;
        _updateDisplayedMovies();
      });
      return;
    }
    setState(() {
      _isSearching = true;
      searchResults = allMovies.where((movie) {
        return movie.title.toLowerCase().contains(query) ||
            movie.genreType.toLowerCase().contains(query);
      }).toList();
      searchResults.sort((a, b) => b.year.compareTo(a.year));
      currentPage = 1;
      _updateDisplayedMovies();
      _searchFocusNode.unfocus();
    });
  }

  void _clearSearch() {
    setState(() {
      _searchResultController.clear();
      _isSearching = false;
      _searchFocusNode.unfocus();
      currentPage = 1;
      _updateDisplayedMovies();
    });
  }

  void _applyFilters(Map<String, String> filters) {
    setState(() {
      _activeFilters = filters;
      _filterMovies();
    });
  }

  void _filterMovies() {
    List<Movie> filtered = List.from(allMovies);
    if (_activeFilters.containsKey('genre') &&
        _activeFilters['genre'] != 'All') {
      final selectedGenre = _activeFilters['genre']!.toLowerCase();
      filtered = filtered.where((movie) {
        final genres = movie.genreType
            .split(',')
            .map((g) => g.trim().toLowerCase())
            .toList();
        return genres.contains(selectedGenre);
      }).toList();
    }
    if (_activeFilters.containsKey('year') && _activeFilters['year'] != 'All') {
      final year = _activeFilters['year']!;
      filtered = filtered.where((movie) => movie.year == year).toList();
    }
    if (_activeFilters.containsKey('rating')) {
      final minRating = double.parse(_activeFilters['rating']!);
      if (minRating > 0) {
        filtered = filtered
            .where((movie) => double.parse(movie.imdbRating) >= minRating)
            .toList();
      }
    }
    setState(() {
      filteredMovies = filtered;
      currentPage = 1;
      _updateDisplayedMovies();
    });
  }

  void _updateDisplayedMovies() {
    final startIndex = (currentPage - 1) * moviesPerPage;
    final endIndex = startIndex + moviesPerPage;
    final moviesToPaginate = _isSearching ? searchResults : filteredMovies;
    setState(() {
      paginatedMovies = moviesToPaginate.sublist(
        startIndex.clamp(0, moviesToPaginate.length),
        endIndex.clamp(0, moviesToPaginate.length),
      );
    });
  }

  void _changePage(int page) {
    setState(() {
      currentPage = page;
      _updateDisplayedMovies();
    });
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _sortMovies() {
    setState(() {
      final moviesToSort = _activeFilters.isNotEmpty
          ? filteredMovies
          : allMovies;
      switch (_selectedIndex) {
        case 0:
          moviesToSort.sort((a, b) => b.year.compareTo(a.year));
          break;
        case 1:
          final currentYear = DateTime.now().year.toString();
          moviesToSort.sort((a, b) {
            if (a.year == currentYear && b.year != currentYear) return -1;
            if (b.year == currentYear && a.year != currentYear) return 1;
            return b.year.compareTo(a.year);
          });
          break;
        case 2:
          moviesToSort.sort((a, b) {
            final aRating = a.rottenRating == "N/A"
                ? 0
                : double.parse(a.rottenRating.replaceAll('%', ''));
            final bRating = b.rottenRating == "N/A"
                ? 0
                : double.parse(b.rottenRating.replaceAll('%', ''));
            return bRating.compareTo(aRating);
          });
          break;
      }
      if (_activeFilters.isNotEmpty) {
        _filterMovies();
      } else {
        filteredMovies = List.from(allMovies);
        _updateDisplayedMovies();
      }
    });
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
      itemCount: paginatedMovies.length,
      itemBuilder: (context, index) {
        return MovieCard(movie: paginatedMovies[index]);
      },
    );
  }

  Widget _buildMovieGrid() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
      );
    }
    if (paginatedMovies.isEmpty) {
      return const Center(
        child: Text('No movies found', style: TextStyle(color: Colors.white)),
      );
    }
    return CustomAnimation(
      0.35,
      type: AnimationType.fadeSlide,
      GridView.builder(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.52,
          crossAxisSpacing: 30,
          mainAxisSpacing: 5,
        ),
        itemCount: paginatedMovies.length,
        itemBuilder: (context, index) {
          return MovieCard(movie: paginatedMovies[index]);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final networkService = Provider.of<NetworkService>(context);

    final totalPages = _isSearching
        ? (searchResults.length / moviesPerPage).ceil()
        : (filteredMovies.length / moviesPerPage).ceil();
    final hasActiveFilters = _activeFilters.isNotEmpty;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFF020912),
      resizeToAvoidBottomInset: false,
      endDrawer: SidePanel(onClose: () => Navigator.of(context).pop()),
      appBar: AppBar(
        backgroundColor: const Color(0xFF020912),
        leading: IconButton(
          icon: const Icon(Icons.home, color: Colors.white),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
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
          if(networkService.isConnected && !_dialogShowing)
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
                  if (!_isSearching) ...[
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
                                  _sortMovies();
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
                  Expanded(
                    child: Stack(
                      children: [
                        if (_isSearching)
                          _buildSearchResults()
                        else
                          _buildMovieGrid(),
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
          if (_showFilters && !_isSearching)
            Positioned(
              top: 180,
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
