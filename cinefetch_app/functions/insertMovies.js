// const axios = require('axios');
// require('dotenv').config();

// // All MCU movies in chronological order
// const MCU_MOVIES = [
//   { "title": "Transformers", "year": "2007" },
//   { "title": "Transformers: Revenge of the Fallen", "year": "2009" },
//   { "title": "Transformers: Dark of the Moon", "year": "2011" },
//   { "title": "Transformers: Age of Extinction", "year": "2014" },
//   { "title": "Transformers: The Last Knight", "year": "2017" },
//   { "title": "Bumblebee", "year": "2018" },
//   { "title": "Transformers: Rise of the Beasts", "year": "2023" },
//   { "title": "Forrest Gump", "year": "1994" },
//   { "title": "The Godfather", "year": "1972" },
//   { "title": "Titanic", "year": "1997" },
//   { "title": "Interstellar", "year": "2014" },
//   { "title": "Saving Private Ryan", "year": "1998" },
//   { "title": "The Shawshank Redemption", "year": "1994" },
//   { "title": "Gladiator", "year": "2000" },
//   { "title": "Braveheart", "year": "1995" },
//   { "title": "Mission: Impossible - Fallout", "year": "2018" },
//   { "title": "Top Gun: Maverick", "year": "2022" },
//   { "title": "The Curious Case of Benjamin Button", "year": "2008" },
//   { "title": "Star Trek", "year": "2009" },
//   { "title": "Indiana Jones and the Raiders of the Lost Ark", "year": "1981" },
//   { "title": "The Wolf of Wall Street", "year": "2013" },
//   { "title": "Shutter Island", "year": "2010" },
//   { "title": "A Quiet Place", "year": "2018" },
//   { "title": "Arrival", "year": "2016" },
//   { "title": "The Truman Show", "year": "1998" },
//   { "title": "True Grit", "year": "2010" }
// ];

// async function getTmdbId(movieTitle, year) {
//   const url = 'https://api.themoviedb.org/3/search/movie';
//   const params = {
//     api_key: process.env.TMDB_API_KEY,
//     query: movieTitle,
//     year: year,
//     include_adult: false
//   };

//   try {
//     const response = await axios.get(url, { params });
//     if (response.data.results.length > 0) {
//       // Find exact match (case insensitive)
//       const exactMatch = response.data.results.find(
//         movie => movie.title.toLowerCase() === movieTitle.toLowerCase()
//       );
//       return exactMatch?.id || response.data.results[0].id;
//     }
//     return null;
//   } catch (error) {
//     console.error(`Error searching for ${movieTitle}:`, error.message);
//     return null;
//   }
// }

// async function logAllTmdbIds() {
//   console.log("MCU Movie IDs:");
//   console.log("==============");
  
//   for (const movie of MCU_MOVIES) {
//     const id = await getTmdbId(movie.title, movie.year);
//     console.log(`🎬 ${movie.title.padEnd(40)} (${movie.year}): ${id || 'Not found'}`);
    
//     // Add delay to avoid rate limiting (TMDb allows 40 requests/10 seconds)
//     await new Promise(resolve => setTimeout(resolve, 250));
//   }
// }

// logAllTmdbIds();











const admin = require("firebase-admin");
const axios = require("axios");
require("dotenv").config();

// ===== 1. Initialize Firebase ===== //
admin.initializeApp({
  credential: admin.credential.cert(require("./serviceAccountKey.json")),
});
const db = admin.firestore();

// ===== 2. Define Movies Array (with Rotten Tomatoes ratings) ===== //
const MOVIES = [
  { "tmdbId": 1858, "rotten_rating": "57%", "audience_rating": "85%" },
  { "tmdbId": 8373, "rotten_rating": "19%", "audience_rating": "61%" },
  { "tmdbId": 38356, "rotten_rating": "35%", "audience_rating": "58%" },
  { "tmdbId": 91314, "rotten_rating": "17%", "audience_rating": "50%" },
  { "tmdbId": 335988, "rotten_rating": "15%", "audience_rating": "42%" },
  { "tmdbId": 424783, "rotten_rating": "91%", "audience_rating": "79%" },
  { "tmdbId": 667538, "rotten_rating": "52%", "audience_rating": "91%" },
  { "tmdbId": 13, "rotten_rating": "71%", "audience_rating": "95%" },
  { "tmdbId": 238, "rotten_rating": "97%", "audience_rating": "98%" },
  { "tmdbId": 597, "rotten_rating": "87%", "audience_rating": "89%" },
  { "tmdbId": 157336, "rotten_rating": "73%", "audience_rating": "86%" },
  { "tmdbId": 857, "rotten_rating": "93%", "audience_rating": "95%" },
  { "tmdbId": 278, "rotten_rating": "91%", "audience_rating": "98%" },
  { "tmdbId": 98, "rotten_rating": "80%", "audience_rating": "87%" },
  { "tmdbId": 197, "rotten_rating": "77%", "audience_rating": "90%" },
  { "tmdbId": 353081, "rotten_rating": "97%", "audience_rating": "88%" },
  { "tmdbId": 361743, "rotten_rating": "96%", "audience_rating": "99%" },
  { "tmdbId": 4922, "rotten_rating": "72%", "audience_rating": "81%" },
  { "tmdbId": 13475, "rotten_rating": "94%", "audience_rating": "91%" },
  { "tmdbId": 85, "rotten_rating": "93%", "audience_rating": "96%" },
  { "tmdbId": 106646, "rotten_rating": "80%", "audience_rating": "83%" },
  { "tmdbId": 11324, "rotten_rating": "68%", "audience_rating": "77%" },
  { "tmdbId": 447332, "rotten_rating": "96%", "audience_rating": "83%" },
  { "tmdbId": 329865, "rotten_rating": "94%", "audience_rating": "82%" },
  { "tmdbId": 37165, "rotten_rating": "95%", "audience_rating": "94%" },
  { "tmdbId": 44264, "rotten_rating": "95%", "audience_rating": "85%" }
  
];

// ===== 3. Fetch Movie Data from TMDB (Now Includes Duration) ===== //
async function fetchMovie(tmdbId) {
  const url = `https://api.themoviedb.org/3/movie/${tmdbId}`;
  const params = { 
    api_key: process.env.TMDB_API_KEY, 
    append_to_response: "credits"
  };

  try {
    const { data } = await axios.get(url, { params });
    
    // Format duration (e.g., 152 → "2h 32m")
    const duration = data.runtime 
      ? `${Math.floor(data.runtime / 60)}h ${data.runtime % 60}m`
      : "N/A";

    const genre_type = data.genres?.map(genre => genre.name).join(", ") || "N/A";
    
    return {
      title: data.title,
      year: data.release_date?.split("-")[0] || "N/A",
      imdb_rating: data.vote_average?.toFixed(1) || "0.0",
      overview: data.overview || "No description",
      genre_type: genre_type,
      duration: duration,  // 👈 New field
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
    console.error(`❌ Failed to fetch TMDB ID ${tmdbId}:`, err.message);
    return null;
  }
}

// ===== 4. Insert Movies into Firestore ===== //
async function insertMovies() {
  const batch = db.batch();

  for (const movie of MOVIES) {
    const tmdbData = await fetchMovie(movie.tmdbId);
    if (!tmdbData) continue;

    // Merge TMDB data with Rotten Tomatoes ratings
    const fullMovieData = {
      ...tmdbData,
      rotten_rating: movie.rotten_rating,
      audience_rating: movie.audience_rating,
    };

    const docRef = db.collection("movies").doc(); // Auto-ID
    batch.set(docRef, fullMovieData);
    console.log(`✅ Added: ${fullMovieData.title} (${fullMovieData.duration})`);
  }

  await batch.commit();
  console.log("🔥 All movies inserted successfully!");
}

// ===== 5. Run the Script ===== //
insertMovies().catch(err => {
  console.error("🚨 Critical error:", err);
  process.exit(1);
});


