#include <iostream>
#include <fstream>
#include <vector>
#include <string>

int main() {
  std::ifstream file("data.txt");
  std::string file_pointer;
  std::vector<std::string> data;

  while(getline(file, file_pointer)) {
    data.push();
  }
  file.close();
  return EXIT_SUCCESS;
}
