// const admin = require("firebase-admin");
// const axios = require("axios");
// require("dotenv").config();

// // Initialize Firebase
// const serviceAccount = require("./serviceAccountKey.json");
// admin.initializeApp({
//   credential: admin.credential.cert(serviceAccount),
// });
// const db = admin.firestore();

// // TMDB API Key
// const TMDB_API_KEY = process.env.TMDB_API_KEY;

// // List of TMDB Movie IDs (Example: Top 100 Popular Movies)
// const MOVIE_IDS = [
//   550,  // Fight Club
//   155,  // The Dark Knight
//   680,  // Pulp Fiction
//   27205, // Inception
//   // Add more IDs as needed
// ];

// // Function to fetch movie from TMDB
// async function fetchMovie(tmdbId) {
//   try {
//     const response = await axios.get(
//       `https://api.themoviedb.org/3/movie/${tmdbId}`,
//       { params: { api_key: TMDB_API_KEY, append_to_response: "credits" } }
//     );
//     const data = response.data;
//     const credits = data.credits || {};

//     return {
//       title: data.title || "Unknown",
//       year: data.release_date?.split("-")[0] || "N/A",
//       imdb_rating: data.vote_average?.toString() || "0.0",
//       rotten_rating: "N/A", // Requires Rotten Tomatoes API
//       audience_rating: "N/A",
//       overview: data.overview || "No description",
//       movie_img_path: data.poster_path
//         ? `https://image.tmdb.org/t/p/w500${data.poster_path}`
//         : null,
//       cast: (credits.cast || []).slice(0, 5).map((actor) => ({
//         actor: actor.name || "Unknown",
//         character: actor.character || "Unknown",
//         cast_img_path: actor.profile_path
//           ? `https://image.tmdb.org/t/p/w200${actor.profile_path}`
//           : null,
//       })),
//     };
//   } catch (error) {
//     console.error(`Failed to fetch movie ${tmdbId}:`, error.message);
//     return null;
//   }
// }

// // Insert movies into Firestore
// async function insertMovies() {
//   const batch = db.batch(); // Batch write for efficiency
//   const moviesRef = db.collection("movies");

//   for (const tmdbId of MOVIE_IDS) {
//     const movie = await fetchMovie(tmdbId);
//     if (movie) {
//       const newMovieRef = moviesRef.doc(); // Auto-generated ID
//       batch.set(newMovieRef, movie);
//       console.log(`Added to batch: ${movie.title}`);
//     }
//   }

//   // Commit the batch
//   await batch.commit();
//   console.log("All movies inserted successfully!");
// }

// insertMovies().catch(console.error);



const admin = require("firebase-admin");
const axios = require("axios");
require("dotenv").config();

// ===== 1. Verify Environment ===== //
const TMDB_API_KEY = process.env.TMDB_API_KEY;
if (!TMDB_API_KEY) throw new Error("TMDB_API_KEY missing in .env!");

// ===== 2. Initialize Firebase ===== //
admin.initializeApp({
  credential: admin.credential.cert(require("./serviceAccountKey.json")),
});
const db = admin.firestore();

// ===== 3. Fetch Movie Data ===== //
async function fetchMovie(tmdbId) {
  const url = `https://api.themoviedb.org/3/movie/${tmdbId}`;
  const params = { api_key: TMDB_API_KEY, append_to_response: "credits" };

  try {
    const { data } = await axios.get(url, { params });
    return {
      title: data.title,
      year: data.release_date?.split("-")[0] || "N/A",
      imdb_rating: data.vote_average?.toString() || "0.0",
      overview: data.overview || "No description",
      movie_img_path: data.poster_path 
          ? `https://image.tmdb.org/t/p/w500${data.poster_path}` 
          : null,
      cast: (data.credits?.cast || []).slice(0, 5).map(actor => ({
        actor: actor.name,
        character: actor.character,
        cast_img_path: actor.profile_path
            ? `https://image.tmdb.org/t/p/w200${actor.profile_path}`
            : null,
      })),
    };
  } catch (err) {
    console.error(`❌ Failed to fetch ${tmdbId}:`, err.message);
    return null;
  }
}

// ===== 4. Insert into Firestore ===== //
async function insertMovies() {
  const MOVIE_IDS = [550, 155, 680, 27205]; // Example IDs
  const batch = db.batch();

  for (const id of MOVIE_IDS) {
    const movie = await fetchMovie(id);
    if (!movie) continue;

    const docRef = db.collection("movies").doc(); // Auto-generated ID
    batch.set(docRef, movie);
    console.log(`✅ Added: ${movie.title}`);
  }

  await batch.commit();
  console.log("🔥 Batch committed!");
}

// ===== 5. Run ===== //
insertMovies().catch(console.error);