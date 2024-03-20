import Koa from 'koa';
const fetch = require("node-fetch");

const app=new Koa()
const port = 3000;

const options = {
    method: 'GET',
    headers: {
        accept: 'application/json',
        Authorization: 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI0NTdlODYyMTlhYmM4ZjIxM2E5MzllNzgwOTU2Nzg1NCIsInN1YiI6IjY1ZWRhNGZiOGNmY2M3MDE0YTYyNDg2OSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.ZdmQE-jU5x3Lyfrxs8Mwh11jRDQcEPITvVyT2j6Dys0'
    }
};

async function fetchMovieList() {
    const url = 'https://api.themoviedb.org/3/discover/movie?include_adult=false&include_video=false&language=en-US&page=1&sort_by=popularity.desc';

    const response = await fetch(url, options);
    const json = await response.json();
    return json.results; // Return the list of movies
}

function fetchMovieAndTitleList(moviesList) {
    const titlesAndPosters = [];
    for (const movie of moviesList) {
        titlesAndPosters.push({
            original_title: movie.original_title, // Use original_title instead of title
            poster_path: movie.poster_path
        });
    }
    return titlesAndPosters;
}

// Middleware to handle requests
app.use(async (ctx) => {
    console.log('Request received');
    const movies = await fetchMovieList(); // Fetch movie data
    const titlesAndPosters = fetchMovieAndTitleList(movies); // Extract titles and posters
    ctx.body = JSON.stringify(titlesAndPosters); // Return the extracted data as response
});

app.listen(port, () => {
    console.log(`Server is running on port ${port}`);

});


