#include <string>
#include <iostream>
#include <fstream>
#include <boost/filesystem.hpp>
#include <cstdint>
#include <vector>
#include <sstream>
#include <set>
#include <unordered_map>

#define NORTH '^'
#define SOUTH 'v'
#define EAST '>'
#define WEST '<'

#define X 0
#define Y 1

int main() {
  std::ifstream data_stream("build/data.txt");
  if(!data_stream) { std::cout << "File Not Found" << std::endl; return EXIT_FAILURE; }

  std::unordered_map<int32_t, std::unordered_map<int32_t, int32_t>> hash_table;
  std::array<int32_t, 2> current_location = {0, 0};

  int32_t gifted_homes = 0;

  char instruction;

  while(data_stream.get(instruction)) {
    switch(instruction) {
      case NORTH:
        current_location[X]++;
        break;
      case SOUTH:
        current_location[X]--;
        break;
      case EAST:
        current_location[Y]++;
        break;
      case WEST:
        current_location[Y]--;
        break;
    }

    hash_table[current_location[X]][current_location[Y]]++;
  }

  for(auto i=hash_table.begin(); i != hash_table.end(); i++) {
    std::cout << hash_table[i][0] <<std::endl;
  }

  return EXIT_SUCCESS;
}
