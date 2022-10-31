import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const String BASE_IMAGE_URL = 'https://image.tmdb.org/t/p/w500';

// colors
const Color kRichBlack = Color(0xFF000814);
const Color kOxfordBlue = Color(0xFF001D3D);
const Color kPrussianBlue = Color(0xFF003566);
const Color kMikadoYellow = Color(0xFFffc300);
const Color kDavysGrey = Color(0xFF4B5358);
const Color kGrey = Color(0xFF303030);

// text style
final TextStyle kHeading5 =
    GoogleFonts.poppins(fontSize: 23, fontWeight: FontWeight.w400);
final TextStyle kHeading6 = GoogleFonts.poppins(
    fontSize: 19, fontWeight: FontWeight.w500, letterSpacing: 0.15);
final TextStyle kSubtitle = GoogleFonts.poppins(
    fontSize: 15, fontWeight: FontWeight.w400, letterSpacing: 0.15);
final TextStyle kBodyText = GoogleFonts.poppins(
    fontSize: 13, fontWeight: FontWeight.w400, letterSpacing: 0.25);

// text theme
final kTextTheme = TextTheme(
  headline5: kHeading5,
  headline6: kHeading6,
  subtitle1: kSubtitle,
  bodyText2: kBodyText,
);

const kColorScheme = ColorScheme(
  primary: kMikadoYellow,
  primaryContainer: kMikadoYellow,
  secondary: kPrussianBlue,
  secondaryContainer: kPrussianBlue,
  surface: kRichBlack,
  background: kRichBlack,
  error: Colors.red,
  onPrimary: kRichBlack,
  onSecondary: Colors.white,
  onSurface: Colors.white,
  onBackground: Colors.white,
  onError: Colors.white,
  brightness: Brightness.dark,
);

/// Widget keys
const searchTextFieldKey = 'search_text_field';
const searchResultKey = 'search_result_key';
const searchFilterButtonKey = 'search_filter_button_key';
const filterTypeBottomSheetKey = 'filter_type_bottom_sheet_key';
const movieRadioButtonKey = 'movie_radio_button_key';
const tvSeriesRadioButtonKey = 'tv_series_radio_button_key';
const movieListScaffoldKey = 'movie_list_scaffold_key';
const tvSeriesListScaffoldKey = 'tv_series_list_scaffold_key';
const tvSeriesRecommendationItemKey = 'tv_series_recommendation_item_key';
const movieRecommendationItemKey = 'movie_recommendation_item_key';
const homeMovieItemKey = 'home_movie_item_key';
const homeTvSeriesItemKey = 'home_tv_series_item_key';

const appDescription = 'Ditonton merupakan sebuah aplikasi katalog '
    'film yang dikembangkan oleh Dicoding Indonesia '
    'sebagai contoh proyek aplikasi untuk kelas Menjadi '
    'Flutter Developer Expert.';
