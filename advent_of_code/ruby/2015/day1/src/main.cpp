#include <string>
#include <iostream>
#include <fstream>
#include <boost/filesystem.hpp>
#include <cstdint>

#define PART2 true

int main() {
  std::ifstream data_stream("build/data.txt");
  char proc_char;
  int64_t result = 0;
  if(!data_stream) { std::cout << "File Not Found" << std::endl; return EXIT_FAILURE; }

  while(data_stream.get(proc_char)) {
    switch(proc_char) {
      case '(':
        result++;
        break;
      case ')':
        result--;
        break;
    }

    if(!PART2) continue;
    if(result < 0) {
      std::cout << "Entered Basement at: " << data_stream.tellg() << std::endl;
      break;
    }
  }

  std::cout << "Result: " << signed(result) << std::endl;
  return EXIT_SUCCESS;
}
