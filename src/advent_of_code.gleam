import argv
import bridge_repair as day07
import ceres_search as day04
import disk_fragmenter as day09
import gleam/int
import gleam/io
import gleam/result
import guard_gallivant as day06
import historian_hysteria as day01
import hoof_it as day10
import mull_it_over as day03
import print_queue as day05
import red_nosed_reports as day02
import resonant_collinearity as day08
import simplifile.{read}

pub fn main() {
  case argv.load().arguments {
    ["1"] -> {
      result.unwrap(
        result.map(read("data/day1.txt"), fn(data) {
          io.println(
            "[1] Historian Hysteria (Part 1): "
            <> int.to_string(day01.solve_a(data)),
          )
          io.println(
            "[1] Historian Hysteria (Part 2): "
            <> int.to_string(day01.solve_b(data)),
          )
        }),
        Nil,
      )
    }
    ["2"] -> {
      result.unwrap(
        result.map(read("data/day2.txt"), fn(data) {
          io.println(
            "[2] Red Nosed Reports (Part 1): "
            <> int.to_string(day02.solve_a(data)),
          )
          io.println(
            "[2] Red Nosed Reports (Part 2): "
            <> int.to_string(day02.solve_b(data)),
          )
        }),
        Nil,
      )
    }
    ["3"] -> {
      result.unwrap(
        result.map(read("data/day3.txt"), fn(data) {
          io.println(
            "[3] Mull It Over (Part 1): " <> int.to_string(day03.solve_a(data)),
          )
          io.println(
            "[3] Mull It Over (Part 2): " <> int.to_string(day03.solve_b(data)),
          )
        }),
        Nil,
      )
    }
    ["4"] -> {
      result.unwrap(
        result.map(read("data/day4.txt"), fn(data) {
          io.println(
            "[4] Ceres Search (Part 1): " <> int.to_string(day04.solve_a(data)),
          )
          io.println(
            "[4] Ceres Search (Part 2): " <> int.to_string(day04.solve_b(data)),
          )
        }),
        Nil,
      )
    }
    ["5"] -> {
      result.unwrap(
        result.map(read("data/day5.txt"), fn(data) {
          io.println(
            "[5] Print Queue (Part 1): " <> int.to_string(day05.solve_a(data)),
          )
          io.println(
            "[5] Print Queue (Part 2): " <> int.to_string(day05.solve_b(data)),
          )
        }),
        Nil,
      )
    }
    ["6"] -> {
      result.unwrap(
        result.map(read("data/day6.txt"), fn(data) {
          io.println(
            "[6] Guard Gallivant (Part 1): "
            <> int.to_string(day06.solve_a(data)),
          )
          io.println(
            "[6] Guard Gallivant (Part 2): "
            <> int.to_string(day06.solve_b(data)),
          )
        }),
        Nil,
      )
    }
    ["7"] -> {
      result.unwrap(
        result.map(read("data/day7.txt"), fn(data) {
          io.println(
            "[7] Bridge Repair (Part 1): " <> int.to_string(day07.solve_a(data)),
          )
          io.println(
            "[7] Bridge Repair (Part 2): " <> int.to_string(day07.solve_b(data)),
          )
        }),
        Nil,
      )
    }

    ["8"] -> {
      result.unwrap(
        result.map(read("data/day8.txt"), fn(data) {
          io.println(
            "[8] Resonant Collinearity (Part 1): "
            <> int.to_string(day08.solve_a(data)),
          )
          io.println(
            "[8] Resonant Collinearity (Part 2): "
            <> int.to_string(day08.solve_b(data)),
          )
        }),
        Nil,
      )
    }
    ["9"] -> {
      result.unwrap(
        result.map(read("data/day9.txt"), fn(data) {
          io.println(
            "[9] Disk Fragmenter (Part 1): "
            <> int.to_string(day09.solve_a(data)),
          )
          io.println(
            "[9] Disk Fragmenter (Part 2): "
            <> int.to_string(day09.solve_b(data)),
          )
        }),
        Nil,
      )
    }
    ["10"] -> {
      result.unwrap(
        result.map(read("data/day10.txt"), fn(data) {
          io.println(
            "[10] Hoof It (Part 1): " <> int.to_string(day10.solve_a(data)),
          )
          io.println(
            "[10] Hoof It (Part 2): " <> int.to_string(day10.solve_b(data)),
          )
        }),
        Nil,
      )
    }
    _ -> io.println_error("invalid arguments!")
  }
}
