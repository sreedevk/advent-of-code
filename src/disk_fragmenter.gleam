import gleam/int
import gleam/list
import gleam/result
import gleam/string
import utils/list as li

fn generate_file_block(block_count, file_index) -> List(String) {
  case block_count {
    "0" -> []
    _ ->
      list.range(1, result.unwrap(int.parse(block_count), 0))
      |> list.map(fn(_) { int.to_string(file_index / 2) })
  }
}

fn generate_space_block(block_count) -> List(String) {
  case block_count {
    "0" -> []
    _ ->
      list.range(1, result.unwrap(int.parse(block_count), 0))
      |> list.map(fn(_) { "." })
  }
}

fn generate_block(block_count, file_index) -> List(String) {
  case int.is_even(file_index) {
    True -> generate_file_block(block_count, file_index)
    False -> generate_space_block(block_count)
  }
}

fn disk_map(input: String) -> List(String) {
  string.to_graphemes(input)
  |> list.index_map(generate_block)
  |> list.flatten
}

fn defrag_complete(disk: List(String), current_index: Int) -> Bool {
  let #(_, after) = list.split(disk, current_index + 1)

  list.all(after, fn(x) { x == "." })
}

fn rotate_block(disk: List(String), state: List(String)) -> List(String) {
  case li.pop(disk) {
    #(Ok("."), rest) -> rotate_block(rest, list.append(state, ["."]))
    #(Ok(anyval), rest) -> list.append([anyval], list.append(rest, state))
    #(Error(_), _) -> disk
  }
}

fn disk_defrag(disk: List(String), current_index: Int) -> List(String) {
  case defrag_complete(disk, current_index) {
    True -> disk
    False ->
      case li.at(disk, current_index) {
        Ok(".") -> {
          let #(defragged, undefragged) = list.split(disk, current_index)
          let assert #(["."], remaining_undefragged) =
            list.split(undefragged, 1)
          let new_current_disk_map =
            list.append(
              defragged,
              list.append(rotate_block(remaining_undefragged, []), ["."]),
            )

          disk_defrag(new_current_disk_map, current_index + 1)
        }
        Ok(_) -> disk_defrag(disk, current_index + 1)
        Error(_) -> disk
      }
  }
}

fn checksum(input: List(String)) -> Int {
  input
  |> list.filter_map(fn(x) { int.parse(x) })
  |> list.index_map(int.multiply)
  |> list.fold(0, int.add)
}

pub fn solve_a(input: String) -> Int {
  disk_map(input)
  |> disk_defrag(0)
  |> checksum
}

pub fn solve_b(_input: String) -> Int {
  0
}
