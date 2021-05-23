#include <string>
#include <iostream>
#include <fstream>
#include <boost/filesystem.hpp>
#include <cstdint>
#include <vector>
#include <sstream>

std::vector<int32_t> build_dimensions(std::string measurements) {
  int32_t h = 0, w = 0, l = 0;
  sscanf(measurements.c_str(), "%dx%dx%d", &h, &w, &l);
  std::vector<int32_t> dimensions;
  dimensions.push_back(h);
  dimensions.push_back(w);
  dimensions.push_back(l);
  std::sort(dimensions.begin(), dimensions.end());
  return dimensions;
}

int32_t compute_surface_area(std::vector<int32_t> dimensions) {
  return (
      2*dimensions[0]*dimensions[1] + 2*dimensions[1]*dimensions[2] + 2*dimensions[2]*dimensions[0])
      + (dimensions[0] * dimensions[1]);
}

int32_t compute_ribbon_length(std::vector<int32_t> dimensions) {
  return (2 * dimensions[0]) + (2 * dimensions[1]) + (dimensions[0] * dimensions[1] * dimensions[2]);
}


int main() {
  std::ifstream data_stream("build/data.txt");
  if(!data_stream) { std::cout << "File Not Found" << std::endl; return EXIT_FAILURE; }

  std::vector<int32_t> present_dimensions;
  int32_t wrapping_paper_area = 0;
  int32_t ribbon_length = 0;

  std::string procline;
  while(std::getline(data_stream, procline)) {
    present_dimensions = build_dimensions(procline);
    wrapping_paper_area += compute_surface_area(present_dimensions);
    ribbon_length += compute_ribbon_length(present_dimensions);
  }

  std::cout << "wrapping_paper_area: " << signed(wrapping_paper_area) << std::endl;
  std::cout << "ribbon_length: " << signed(ribbon_length) << std::endl;
  return EXIT_SUCCESS;
}
