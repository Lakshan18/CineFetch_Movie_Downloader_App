// const axios = require('axios');
// require('dotenv').config();

// // All MCU movies in chronological order
// const MCU_MOVIES = [
//   { "title": "Jurassic Park", "year": "1993" },
//   { "title": "The Lost World: Jurassic Park", "year": "1997" },
//   { "title": "Jurassic Park III", "year": "2001" },
//   { "title": "Jurassic World", "year": "2015" },
//   { "title": "Jurassic World: Fallen Kingdom", "year": "2018" },
//   { "title": "Jurassic World: Dominion", "year": "2022" },
//   { "title": "The Purge", "year": "2013" },
//   { "title": "The Purge: Anarchy", "year": "2014" },
//   { "title": "The Purge: Election Year", "year": "2016" },
//   { "title": "The First Purge", "year": "2018" },
//   { "title": "The Forever Purge", "year": "2021" },
//   { "title": "Despicable Me", "year": "2010" },
//   { "title": "Despicable Me 2", "year": "2013" },
//   { "title": "Minions", "year": "2015" },
//   { "title": "Despicable Me 3", "year": "2017" },
//   { "title": "Minions: The Rise of Gru", "year": "2022" },
//   { "title": "Despicable Me 4", "year": "2024" },
//   { "title": "The Mummy", "year": "1999" },
//   { "title": "The Mummy Returns", "year": "2001" },
//   { "title": "The Mummy: Tomb of the Dragon Emperor", "year": "2008" },
//   { "title": "The Mummy", "year": "2017" },
//   { "title": "The Bourne Identity", "year": "2002" },
//   { "title": "The Bourne Supremacy", "year": "2004" },
//   { "title": "The Bourne Ultimatum", "year": "2007" },
//   { "title": "The Bourne Legacy", "year": "2012" },
//   { "title": "Jason Bourne", "year": "2016" },
//   { "title": "Halloween", "year": "2018" },
//   { "title": "Halloween Kills", "year": "2021" },
//   { "title": "Halloween Ends", "year": "2022" },
//   { "title": "Shrek", "year": "2001" },
//   { "title": "Shrek 2", "year": "2004" },
//   { "title": "Shrek the Third", "year": "2007" },
//   { "title": "Shrek Forever After", "year": "2010" },
//   { "title": "Puss in Boots", "year": "2011" },
//   { "title": "Puss in Boots: The Last Wish", "year": "2022" },
//   { "title": "Dracula Untold", "year": "2014" },
//   { "title": "How to Train Your Dragon", "year": "2010" },
//   { "title": "How to Train Your Dragon 2", "year": "2014" },
//   { "title": "How to Train Your Dragon: The Hidden World", "year": "2019" },
//   { "title": "Pitch Perfect", "year": "2012" },
//   { "title": "Pitch Perfect 2", "year": "2015" },
//   { "title": "Pitch Perfect 3", "year": "2017" },
//   { "title": "Ted", "year": "2012" },
//   { "title": "Ted 2", "year": "2015" },
//   { "title": "Back to the Future", "year": "1985" },
//   { "title": "Back to the Future Part II", "year": "1989" },
//   { "title": "Back to the Future Part III", "year": "1990" },
//   { "title": "The Secret Life of Pets", "year": "2016" },
//   { "title": "The Secret Life of Pets 2", "year": "2019" },
//   { "title": "Fifty Shades of Grey", "year": "2015" },
//   { "title": "Fifty Shades Darker", "year": "2017" },
//   { "title": "Fifty Shades Freed", "year": "2018" },
//   { "title": "The Croods", "year": "2013" },
//   { "title": "The Croods: A New Age", "year": "2020" },
//   { "title": "Trolls", "year": "2016" },
//   { "title": "Trolls World Tour", "year": "2020" },
//   { "title": "Trolls Band Together", "year": "2023" },
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
  { "tmdbId": 329, "rotten_rating": "91%", "audience_rating": "91%" },       // Jurassic Park (1993)
  { "tmdbId": 330, "rotten_rating": "53%", "audience_rating": "51%" },       // The Lost World: Jurassic Park (1997)
  { "tmdbId": 331, "rotten_rating": "49%", "audience_rating": "37%" },       // Jurassic Park III (2001)
  { "tmdbId": 135397, "rotten_rating": "71%", "audience_rating": "78%" },    // Jurassic World (2015)
  { "tmdbId": 351286, "rotten_rating": "46%", "audience_rating": "60%" },    // Jurassic World: Fallen Kingdom (2018)
  { "tmdbId": 507086, "rotten_rating": "29%", "audience_rating": "77%" },    // Jurassic World: Dominion (2022)

  // The Purge Series
  { "tmdbId": 158015, "rotten_rating": "38%", "audience_rating": "41%" },    // The Purge (2013)
  { "tmdbId": 238636, "rotten_rating": "57%", "audience_rating": "52%" },    // The Purge: Anarchy (2014)
  { "tmdbId": 316727, "rotten_rating": "54%", "audience_rating": "51%" },    // The Purge: Election Year (2016)
  { "tmdbId": 442249, "rotten_rating": "53%", "audience_rating": "39%" },    // The First Purge (2018)
  { "tmdbId": 602223, "rotten_rating": "46%", "audience_rating": "66%" },    // The Forever Purge (2021)

  // Despicable Me / Minions Series
  { "tmdbId": 20352, "rotten_rating": "81%", "audience_rating": "85%" },     // Despicable Me (2010)
  { "tmdbId": 93456, "rotten_rating": "74%", "audience_rating": "80%" },      // Despicable Me 2 (2013)
  { "tmdbId": 211672, "rotten_rating": "55%", "audience_rating": "50%" },    // Minions (2015)
  { "tmdbId": 324852, "rotten_rating": "59%", "audience_rating": "58%" },     // Despicable Me 3 (2017)
  { "tmdbId": 438148, "rotten_rating": "70%", "audience_rating": "89%" },    // Minions: The Rise of Gru (2022)
  { "tmdbId": 519182, "rotten_rating": "55%", "audience_rating": "85%" },    // Despicable Me 4 (2024) *Early ratings*

  // The Mummy Series
  { "tmdbId": 564, "rotten_rating": "61%", "audience_rating": "73%" },       // The Mummy (1999)
  { "tmdbId": 1734, "rotten_rating": "47%", "audience_rating": "64%" },      // The Mummy Returns (2001)
  { "tmdbId": 1735, "rotten_rating": "13%", "audience_rating": "43%" },      // The Mummy: Tomb of the Dragon Emperor (2008)
  { "tmdbId": 282035, "rotten_rating": "16%", "audience_rating": "35%" },    // The Mummy (2017)

  // Bourne Series
  { "tmdbId": 2501, "rotten_rating": "84%", "audience_rating": "93%" },      // The Bourne Identity (2002)
  { "tmdbId": 2502, "rotten_rating": "82%", "audience_rating": "89%" },      // The Bourne Supremacy (2004)
  { "tmdbId": 2503, "rotten_rating": "92%", "audience_rating": "91%" },      // The Bourne Ultimatum (2007)
  { "tmdbId": 49040, "rotten_rating": "56%", "audience_rating": "61%" },     // The Bourne Legacy (2012)
  { "tmdbId": 324668, "rotten_rating": "55%", "audience_rating": "58%" },    // Jason Bourne (2016)

  // Halloween Series (2018-2022)
  { "tmdbId": 948, "rotten_rating": "79%", "audience_rating": "71%" },       // Halloween (2018)
  { "tmdbId": 610253, "rotten_rating": "40%", "audience_rating": "66%" },    // Halloween Kills (2021)
  { "tmdbId": 616820, "rotten_rating": "40%", "audience_rating": "57%" },    // Halloween Ends (2022)

  // Shrek Series
  { "tmdbId": 808, "rotten_rating": "88%", "audience_rating": "90%" },       // Shrek (2001)
  { "tmdbId": 809, "rotten_rating": "89%", "audience_rating": "85%" },       // Shrek 2 (2004)
  { "tmdbId": 810, "rotten_rating": "41%", "audience_rating": "53%" },       // Shrek the Third (2007)
  { "tmdbId": 10192, "rotten_rating": "58%", "audience_rating": "53%" },     // Shrek Forever After (2010)
  { "tmdbId": 417859, "rotten_rating": "86%", "audience_rating": "73%" },    // Puss in Boots (2011)
  { "tmdbId": 315162, "rotten_rating": "95%", "audience_rating": "94%" },    // Puss in Boots: The Last Wish (2022)

  // How to Train Your Dragon Series
  { "tmdbId": 10191, "rotten_rating": "99%", "audience_rating": "91%" },     // How to Train Your Dragon (2010)
  { "tmdbId": 82702, "rotten_rating": "92%", "audience_rating": "89%" },     // How to Train Your Dragon 2 (2014)
  { "tmdbId": 166428, "rotten_rating": "90%", "audience_rating": "86%" },    // How to Train Your Dragon 3 (2019)

  // Pitch Perfect Series
  { "tmdbId": 114150, "rotten_rating": "81%", "audience_rating": "86%" },    // Pitch Perfect (2012)
  { "tmdbId": 254470, "rotten_rating": "65%", "audience_rating": "73%" },    // Pitch Perfect 2 (2015)
  { "tmdbId": 353616, "rotten_rating": "30%", "audience_rating": "58%" },    // Pitch Perfect 3 (2017)

  // Ted Series
  { "tmdbId": 72105, "rotten_rating": "69%", "audience_rating": "76%" },     // Ted (2012)
  { "tmdbId": 214756, "rotten_rating": "45%", "audience_rating": "60%" },    // Ted 2 (2015)

  // Back to the Future Series
  { "tmdbId": 105, "rotten_rating": "96%", "audience_rating": "94%" },       // Back to the Future (1985)
  { "tmdbId": 165, "rotten_rating": "84%", "audience_rating": "86%" },       // Back to the Future Part II (1989)
  { "tmdbId": 196, "rotten_rating": "80%", "audience_rating": "82%" },       // Back to the Future Part III (1990)

  // The Secret Life of Pets Series
  { "tmdbId": 328111, "rotten_rating": "72%", "audience_rating": "63%" },    // The Secret Life of Pets (2016)
  { "tmdbId": 412117, "rotten_rating": "60%", "audience_rating": "52%" },    // The Secret Life of Pets 2 (2019)

  // Fifty Shades Series
  { "tmdbId": 216015, "rotten_rating": "65%", "audience_rating": "70%" },    // Fifty Shades of Grey (2015)
  { "tmdbId": 341174, "rotten_rating": "71%", "audience_rating": "81%" },    // Fifty Shades Darker (2017)
  { "tmdbId": 337167, "rotten_rating": "82%", "audience_rating": "88%" },    // Fifty Shades Freed (2018)

  // The Croods Series
  { "tmdbId": 49519, "rotten_rating": "72%", "audience_rating": "70%" },     // The Croods (2013)
  { "tmdbId": 529203, "rotten_rating": "77%", "audience_rating": "89%" },    // The Croods: A New Age (2020)

  // Trolls Series
  { "tmdbId": 136799, "rotten_rating": "75%", "audience_rating": "67%" },    // Trolls (2016)
  { "tmdbId": 446893, "rotten_rating": "71%", "audience_rating": "88%" },    // Trolls World Tour (2020)
  { "tmdbId": 901362, "rotten_rating": "62%", "audience_rating": "86%" },
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


