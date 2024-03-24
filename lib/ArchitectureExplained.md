# ProjectName Architecture Explained

ProjectName is a versatile project designed for [provide a brief description of the project's purpose]. This comprehensive guide will provide you with everything you need to know to get started with the project, from installation instructions to a detailed description of its features.

## Table of Contents

- [api-config.dart](#api-configdart)


- [ArchitectureExplained](#ArchitectureExplainedmd)


- [countingGenres](#countingGenresdart)


- [genre](#genredart)


- [image_carousel_slider](#image_carousel_sliderdart)


- [main](#maindart)

 
- [movie](#moviedart)


- [movie_carousel_view](#movie_carousel_viewdart)


- [movie_list](#movie_listdart)


- [fetchService](#fetchServicedart)


- [trendingMovies](#trendingMoviesdart)

## api-config.dart

The File api-config.dart include 1 class only : 

- ApiConfig: [Class with the needed URL and key to call from TMDB]
  - apiKey: [irene's key to open TMDB]
  - baseUrl: [basic URL to call TMDB]
  - imageBaseUrl: [basic Url to collect poster element from TMDB]


## ArchitectureExplained.md

The file you are reading explaining all the files of the lib.

## CountingGenres.dart

The function imports 2 classes Movie from [movie.dart](#moviedart) & Genre from [genre.dart](#genredart).

This file have 2 functions :

- (List<Movie> movieList, List<Genre> genreList) => countingGenreDictionary => Map<String, int> nbGenreDictionary;


The function takes movieList and genreList (the lists from the TMDB) and compare every film from movieList with genreList to identify what are the genre of the trending movies.


- (Map<String, int> genreCounts) => calculateGenrePercentages => (Map<String, double>);

The function takes the results from the previous one and return the percentage for each category. 
## genre.dart


The File genre.dart include 1 object class only :

- Genre: [Object Class for the genre from TMDB]
  - id: [int type]
  - name: [String type]


## image_carousel_slider.dart

2 imports from classes not created by us (carousel_slider.dart & flutter/material.dart).

This file defines 1 StatelessWidget Class :


- ImageCarouselSlider: [Widget class of the vertically rotating pictures in the bg]
  - buildImageCard [Widget Card]
    - including random Images ##NOT GOOD IMAGES YET##
  - build [Widget]
    - ShaderMask making a the top and bottom linearly cropped.
    - CarouselSlider sliding verticaly automatically sliding infinitely 
      - List.generate using buildImageCard and randomizing their order.


## main.dart

This File is our main! It runs when we execute the code.

It has 3 imports:
- flutter/material.dart
- [trendingMovies.dart](#trendingmoviesdart)
- [image_carousel_slider.dart](#image_carousel_sliderdart)

It has the function main calling the class CodeAvantApp.

It has 3 classes:
- BasicGridWidget: [Widget calling the all page that we show]
  - build: [Widget]
    - BoxDecoration: [LinearGradient used as background. We should work on THE HEIGHT OF THIS ]
    - GridView.builder: [With 5 columns and 5 [ImageCarouselSlider](#image_carousel_sliderdart) as Item] 
    - ResponsiveText: [Title made as a Class] WE SHOULD REPOSITION IT !!! (Center it or else)
    - [TrendingMoviesApp](#trendingmoviesdart): [List of poster of trending movies ] TO REWORK TO MAKE IT PRETTYYYYYY !!! AND WORK ON HIS TOP TO MAKE IT RESPONSIVE
- BasicWhiteCard [NEVER USED] KEEP IT OR CLEAN IT !!!
- ResponsiveText: [Object Class to define a responsive text that evolves with the screen size - Font = 'Montserrat' - BOLD] REFLECHIR SI SORTIR DE MAIN POUR USE IT OUTSIDE ALSO !
  - text: [String type]
  - fontSize: [double type]
  - textColor: [Color type]
  - shadowColor: [Color type]
  - shadowOffset: [Offset type]
    
## movie.dart


The File movie.dart include 1 object class only :

- Movie: [Object Class for the movie from TMDB]
  - id: [int type]
  - title: [String type]
  - overview: [String type]
  - posterPath: [String type]
  - genreIds: [List<dynamic> type]
  - voteAverage: [double type]

## movie_carousel_view.dart

It has 5 imports:
- carousel_slider/carousel_slider.dart
- flutter/material.dart
- [movie.dart](#moviedart)
- cached_network_image/cached_network_image.dart
- [api-config.dart](#api-configdart)

It has a single widget Class:
- MovieCarouselView: [Widget]
  - build: [Widget with an if]
    1. IF movieList is empty return text saying 'No movies available'
    2. (else) return CarouselSlider.builder
       - itemBuilder: 
         - ClipRRect: [collecting Poster of trending Movie using from [ApiConfig](#api-configdart) imageBaseUrl and from an item of type [Movie](#moviedart) posterPath]
         - Container: [from an item [Movie](#moviedart) we collect the title and put it the text for the bottom of the poster]


## movie_list.dart


It has 2 imports:
- [movie.dart](#moviedart)
- [fetchService.dart](#fetchServicedart)


The file movie_list.dart has only 1 class:

- MovieList: [Class returning an array named movieList of object of type [Movie](#moviedart)]
  - fetchMoviesTrend: [Function implementing all the movies in the array using [fetchService.fetchMoviesTrend](#fetchservicedart)]



## fetchService.dart

It has 5 imports:
- http/http.dart as http
- dart:convert
- [api-config.dart](#api-configdart)
- [movie.dart](#moviedart)
- [genre.dart](#genredart)


The file fetchService.dart has only 1 class that are giving 2 functions:

- FetchService: [Class including the 2 fetching functions]
  - fetchMoviesTrend: [Function returning a response parsed that wait to be turned into list of object [movie](#moviedart)]
  - fetchMoviesListGenre: [Function returning a response parsed that wait to be turned into list of object [genre](#genredart)]


## trendingMovies.dart

It has 4 imports:
- flutter/material.dart
- [movie_carousel_view.dart](#movie_carousel_viewdart)
- [movie.dart](#moviedart)
- [movie_list.dart](#movie_listdart)


The file trendingMovies.dart has 2 classes:

- TrendingMoviesHomePage: [Class behaving as a function. Calling TrendingMoviesHomePageState and creating a state out of it] IS IT NEEDED OR NOT ???? WHAT DOES IT CHANGE ???
 
- TrendingMoviesHomePageState: [Class Behving as a function and a Widget in ONE. ]
  - initState: [Function calling [MovieList()](#movie_listdart) and more precisely fetch function inside a list ml.]
  - build: [Widget]
    - appBar: |[The text Section on the top left corner]