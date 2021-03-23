#include <cstring>
#include <Rcpp.h>
using namespace Rcpp;

bool strings_wildcard_equal(const std::string& s1, 
                            const std::string& s2)
{
  // if two strings are not the same length, they cannot be equal
  if (s1.length() != s2.length()) 
    return false;
  
  // character-by-character test for "wildcard equality"
  for (int i = 0; i < s1.length(); ++i)
  {
    if ((s1[i] == s2[i]) || // chars are equal
        (s1[i] == '?')   || // s1's char is wildcard
        (s2[i] == '?'))     // s2's char is wildcard
    {
      continue;
    }
    else
    {
      return false;
    }
  }
    // both strings were the same length
    // and all characters were "wildcard equivalent", so return true
    return true;
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
// [[Rcpp::export]]
IntegerVector fmatch( const std::vector< std::string >& x, const std::vector< std::string >& y ) 
{

  int x_size = x.size();
  int y_size = y.size();

  // Initialize our result. It's a vector of `NA`s, until/unless they
  // are set to an integer, which happens when a match is encountered.
  IntegerVector r( x_size, NA_INTEGER );
  
  for( int i=0; i < x_size; i++ ) {
    for( int j=0; j < y_size; j++ ) {
      // For every element of `x`, search through `y` until a match is found;
      // if no match is found, then `r[i]` will remain `NA`, and we'll move on 
      // to the next element of `x`.
      if (strings_wildcard_equal(x[i], y[j])) {
        // Found a match. Set `r[i]` equal to the index of the match, then break.
        // (Add 1 because R indexing starts at 1, whereas C++ starts at 0.)
        r[i] = j + 1;
        break;
      }
    }
  }
  
  return r;
}
