#include <cstring>
#include <Rcpp.h>
using namespace Rcpp;

// To compare two C strings, with limited wildcard support
int str_wcmp(const char* s1, const char* s2, const char wild = '?')
{
  while( *s1 && *s2 && ( (*s1==*s2) || (*s1==wild) || (*s2==wild) ) ) s1++, s2++;
  return *(const unsigned char*)s1 - *(const unsigned char*)s2;
}

char *as_c_str( const std::string & s ) {
   char *cpy = new char[s.size() + 1];
   std::strcpy(cpy, s.c_str());
   return cpy; 
}

//' Fast string matching with limited wildcard support
//' 
//' @description
//' For each string in `x`, finds the _first_ match in _y_.
//' The character '?' is treated as a wildcard in both `x` and `y`.
//' 
//' @param x character
//' @param y character
//' @return integer positions of matches in \code{y} (\code{NA} indicates no match)
//' 
//' @export
//' 
// [[Rcpp::export]]
IntegerVector fmatch( CharacterVector x, CharacterVector y ) 
{

  int x_size = x.size();
  int y_size = y.size();
  IntegerVector r( x_size );
  // Initialize our result. It's a vector of `NA`s, until/unless they
  // are set to an integer, which happens when a match is encountered.
  IntegerVector r( x.size(), NA_INTEGER );
  
  // Copy everything to C-style strings before we start comparing.
  // This saves us from having to convert all of the strings in `y`
  // more than once, which is helpful when `x` has a lot of elements.
  std::vector<const char*> s1, s2;
  std::transform(x.begin(), x.end(), std::back_inserter(s1), as_c_str);
  std::transform(y.begin(), y.end(), std::back_inserter(s2), as_c_str);
  
  for( int i=0; i < x_size; i++ ) {
    r(i) = NA_INTEGER;
    for( int j=0; j < y_size; j++ ) {
  // For every element of `x`, search through `y` until a match is found;
  // if no match is found, then `r(i)` will remain `NA`, and we'll move on 
  // to the next element of `x`.
      if( str_wcmp( s1[i], s2[j] ) == 0 ) {
        // Found a match. Set `r(i)` equal to the index of the match, then break.
        // (Add 1 because R indexing starts at 1, whereas C++ starts at 0.)
        r(i) = j + 1;
        break;
      }
    }
  }
  
  return r;
}
