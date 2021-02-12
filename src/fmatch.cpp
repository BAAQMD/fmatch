#include <cstring>
#include <Rcpp.h>
using namespace Rcpp;

// Wildcard (?) comparator
// TODO: implement for < std::string >
int str_wcmp(const char* s1, const char* s2)
{
    while( *s1 && ( (*s1==*s2) || (*s1=='?') || (*s2=='?') ) ) s1++, s2++;
    return *(const unsigned char*)s1 - *(const unsigned char*)s2;
}

// TODO: implement without copying to C-style strings
char *as_c_str( const std::string & s ) {
   char *cpy = new char[s.size() + 1];
   std::strcpy(cpy, s.c_str());
   return cpy; 
}

//' Fast string matching with limited wildcard support
//' 
//' @description
//' For each string in \code{x}, find the match in \code{y}.
//' The character '?' is treated as a wildcard in both \code{x} and \code{y}.
//' 
//' @param x character
//' @param y character
//' @return integer positions of matches in \code{y} (\code{NA} indicates no match)
//' 
//' @export
//' 
// [[Rcpp::export]]
IntegerVector fmatch( std::vector< std::string > x, std::vector< std::string > y ) {

  int x_size = x.size();
  int y_size = y.size();
  IntegerVector r( x_size );
  
  // TODO: implement without copying to C-style strings
  std::vector<const char*> s1, s2;
  std::transform(x.begin(), x.end(), std::back_inserter(s1), as_c_str);
  std::transform(y.begin(), y.end(), std::back_inserter(s2), as_c_str);
  
  for( int i=0; i < x_size; i++ ) {
    r(i) = NA_INTEGER;
    for( int j=0; j < y_size; j++ ) {
      if( str_wcmp( s1[i], s2[j] ) == 0 ) {
        r(i) = j + 1;
        break;
      }
    }
  }
  
  return r;
}
