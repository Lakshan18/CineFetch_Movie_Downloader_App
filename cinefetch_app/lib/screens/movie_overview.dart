// import 'package:flutter/material.dart';
// import '../models/movie.dart';

// class MovieOverview extends StatefulWidget {
//   final Movie movie;

//   const MovieOverview({super.key, required this.movie});

//   @override
//   State<MovieOverview> createState() => _MovieOverviewState();
// }

// class _MovieOverviewState extends State<MovieOverview> {
//   Color _getRatingColor(String? rating) {
//     if (rating == null) return Colors.white;
//     final numericValue = double.tryParse(rating.replaceAll('%', '')) ?? 0;
//     if (numericValue >= 80) return Colors.greenAccent;
//     if (numericValue >= 50 && numericValue < 80) return const Color.fromARGB(255, 255, 241, 111);
//     return Colors.white;
//   }

//   Widget _buildRatingCircle(String label, String? value) {
//     if (value == null) return const SizedBox.shrink();

//     return SizedBox(
//       width: 80,
//       height: 80,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             value,
//             style: TextStyle(
//               color: _getRatingColor(value),
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//               fontFamily: "Quicksand",
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             label,
//             style: TextStyle(
//               color: Colors.grey[400],
//               fontSize: 14,
//               fontFamily: "Quicksand",
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF020912),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF020912),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text(
//           "Movie Overview",
//           style: TextStyle(color: Colors.white, fontFamily: "Rosario"),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             AspectRatio(
//               aspectRatio: 0.7,
//               child: Image.asset(
//                 widget.movie.imagePath,
//                 fit: BoxFit.cover,
//                 width: double.infinity,
//               ),
//             ),

//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Title and Year
//                   Text(
//                     widget.movie.title,
//                     style: const TextStyle(
//                       color: Color.fromARGB(255, 170, 228, 255),
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       fontFamily: "Rosario",
//                     ),
//                   ),

//                   const SizedBox(height: 8),

//                   Text(
//                     widget.movie.year,
//                     style: TextStyle(
//                       color: Colors.grey[400],
//                       fontSize: 16,
//                       fontFamily: "Quicksand",
//                     ),
//                   ),

//                   const SizedBox(height: 20),

//                   // Ratings Row
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       Column(
//                         children: [
//                           Text(
//                             widget.movie.imdbrating ?? "N/A",
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 24,
//                               fontWeight: FontWeight.bold,
//                               fontFamily: "Quicksand",
//                             ),
//                           ),
//                           Text(
//                             "IMDb",
//                             style: TextStyle(
//                               color: Colors.grey[400],
//                               fontSize: 14,
//                               fontFamily: "Quicksand",
//                             ),
//                           ),
//                         ],
//                       ),
//                       if (widget.movie.rottentomatoes != null)
//                         Column(
//                           children: [
//                             Text(
//                               widget.movie.rottentomatoes!,
//                               style: TextStyle(
//                                 color: _getRatingColor(
//                                   widget.movie.rottentomatoes,
//                                 ),
//                                 fontSize: 24,
//                                 fontWeight: FontWeight.bold,
//                                 fontFamily: "Quicksand",
//                               ),
//                             ),
//                             Text(
//                               "Rotten Tomatoes",
//                               style: TextStyle(
//                                 color: Colors.grey[400],
//                                 fontSize: 14,
//                                 fontFamily: "Quicksand",
//                               ),
//                             ),
//                           ],
//                         ),
//                       if (widget.movie.audiencescore != null)
//                         Column(
//                           children: [
//                             Text(
//                               widget.movie.audiencescore!,
//                               style: TextStyle(
//                                 color: _getRatingColor(
//                                   widget.movie.audiencescore,
//                                 ),
//                                 fontSize: 24,
//                                 fontWeight: FontWeight.bold,
//                                 fontFamily: "Quicksand",
//                               ),
//                             ),
//                             Text(
//                               "Audience",
//                               style: TextStyle(
//                                 color: Colors.grey[400],
//                                 fontSize: 14,
//                                 fontFamily: "Quicksand",
//                               ),
//                             ),
//                           ],
//                         ),
//                     ],
//                   ),

//                   const SizedBox(height: 20),

//                   // Overview
//                   if (widget.movie.description != null) ...[
//                     const Text(
//                       "Overview",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 18,
//                         fontFamily: "Rosario",
//                       ),
//                     ),

//                     const SizedBox(height: 8),

//                     Text(
//                       widget.movie.description!,
//                       style: const TextStyle(
//                         color: Colors.white70,
//                         fontSize: 16,
//                         fontFamily: "Quicksand",
//                       ),
//                     ),

//                     const SizedBox(height: 20),
//                   ],

//                   // Cast Section
//                   if (widget.movie.cast != null &&
//                       widget.movie.cast!.isNotEmpty) ...[
//                     const Text(
//                       "Cast",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 18,
//                         fontFamily: "Rosario",
//                       ),
//                     ),

//                     const SizedBox(height: 8),

//                     SizedBox(
//                       height: 150,
//                       child: ListView.builder(
//                         scrollDirection: Axis.horizontal,
//                         itemCount: widget.movie.cast!.length,
//                         itemBuilder: (context, index) {
//                           final actor = widget.movie.cast![index];
//                           return Padding(
//                             padding: const EdgeInsets.only(right: 16.0),
//                             child: Column(
//                               children: [
//                                 ClipRRect(
//                                   borderRadius: BorderRadius.circular(8),
//                                   child: Image.asset(
//                                     actor.imagePath,
//                                     width: 80,
//                                     height: 100,
//                                     fit: BoxFit.cover,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Text(
//                                   actor.name,
//                                   style: const TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 14,
//                                     fontFamily: "Quicksand",
//                                   ),
//                                 ),
//                                 if (actor.character != null)
//                                   Text(
//                                     actor.character!,
//                                     style: TextStyle(
//                                       color: Colors.grey[400],
//                                       fontSize: 13,
//                                       fontFamily: "Quicksand",
//                                     ),
//                                   ),
//                               ],
//                             ),
//                           );
//                         },
//                       ),
//                     ),

//                     const SizedBox(height: 30),
//                   ],

//                   // Download and Trailer Buttons
//                   Row(
//                     children: [
//                       Expanded(
//                         child: ElevatedButton(
//                           onPressed: () {
//                             // Add download functionality
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color.fromARGB(255, 28, 135, 184),
//                             padding: const EdgeInsets.symmetric(vertical: 15),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           ),
//                           child: const Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Icon(
//                                 Icons.download,
//                                 size: 20,
//                                 color: Colors.white,
//                               ),
//                               SizedBox(width: 8),
//                               Text(
//                                 'Download',
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 16),
//                       Expanded(
//                         child: OutlinedButton(
//                           onPressed: () {
//                             // Add watch trailer functionality
//                           },
//                           style: OutlinedButton.styleFrom(
//                             side: const BorderSide(
//                               color: Colors.lightBlueAccent,
//                             ),
//                             padding: const EdgeInsets.symmetric(vertical: 15),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           ),
//                           child: const Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Icon(
//                                 Icons.play_arrow,
//                                 size: 20,
//                                 color: Colors.white,
//                               ),
//                               SizedBox(width: 8),
//                               Text(
//                                 'Trailer',
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }





import 'package:flutter/material.dart';
import '../models/movie.dart';

class MovieOverview extends StatefulWidget {
  final Movie movie;

  const MovieOverview({super.key, required this.movie});

  @override
  State<MovieOverview> createState() => _MovieOverviewState();
}

class _MovieOverviewState extends State<MovieOverview> {
  Color _getRatingColor(String? rating) {
    if (rating == null) return Colors.white;
    final numericValue = double.tryParse(rating.replaceAll('%', '')) ?? 0;
    if (numericValue >= 80) return Colors.greenAccent;
    if (numericValue >= 50) return const Color.fromARGB(255, 255, 241, 111);
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020912),
      appBar: AppBar(
        backgroundColor: const Color(0xFF020912),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Movie Overview",
          style: TextStyle(color: Colors.white, fontFamily: "Rosario"),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Movie Poster
            AspectRatio(
              aspectRatio: 0.7,
              child: widget.movie.movieImgPath != null
                  ? Image.network(
                      widget.movie.movieImgPath!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) => 
                        const Center(child: Icon(Icons.error, color: Colors.red)),
                    )
                  : const Center(child: Icon(Icons.movie, size: 100, color: Colors.grey)),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Year
                  Text(
                    widget.movie.title,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 170, 228, 255),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Rosario",
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    widget.movie.year,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 16,
                      fontFamily: "Quicksand",
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Genre
                  if (widget.movie.genreType != null)
                    Text(
                      widget.movie.genreType!,
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14,
                        fontFamily: "Quicksand",
                      ),
                    ),

                  const SizedBox(height: 20),

                  // Ratings Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // IMDb Rating
                      Column(
                        children: [
                          Text(
                            widget.movie.imdbRating,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Quicksand",
                            ),
                          ),
                          const Text(
                            "IMDb",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontFamily: "Quicksand",
                            ),
                          ),
                        ],
                      ),

                      // Rotten Tomatoes Rating
                      Column(
                        children: [
                          Text(
                            widget.movie.rottenRating,
                            style: TextStyle(
                              color: _getRatingColor(widget.movie.rottenRating),
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Quicksand",
                            ),
                          ),
                          const Text(
                            "Rotten Tomatoes",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontFamily: "Quicksand",
                            ),
                          ),
                        ],
                      ),

                      // Audience Score
                      Column(
                        children: [
                          Text(
                            widget.movie.audienceRating,
                            style: TextStyle(
                              color: _getRatingColor(widget.movie.audienceRating),
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Quicksand",
                            ),
                          ),
                          const Text(
                            "Audience",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontFamily: "Quicksand",
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Overview
                  const Text(
                    "Overview",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: "Rosario",
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    widget.movie.overview,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontFamily: "Quicksand",
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Cast Section
                  if (widget.movie.cast != null && widget.movie.cast!.isNotEmpty) ...[
                    const Text(
                      "Cast",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: "Rosario",
                      ),
                    ),

                    const SizedBox(height: 8),

                    SizedBox(
                      height: 150,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.movie.cast!.length,
                        itemBuilder: (context, index) {
                          final actor = widget.movie.cast![index];
                          return Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: actor.castImgPath != null
                                      ? Image.network(
                                          actor.castImgPath!,
                                          width: 80,
                                          height: 100,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) => 
                                            const Icon(Icons.person, size: 80),
                                        )
                                      : const Icon(Icons.person, size: 80),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  actor.actor,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontFamily: "Quicksand",
                                  ),
                                ),
                                Text(
                                  actor.character,
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 13,
                                    fontFamily: "Quicksand",
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Download functionality
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 28, 135, 184),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.download, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Download',
                                style: TextStyle(fontSize: 16,color: Colors.white,fontFamily: "Rosario"),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            // Trailer functionality
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.lightBlueAccent),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.play_arrow, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Trailer',
                                style: TextStyle(fontSize: 16,color: Colors.white,fontFamily: "Rosario"),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}