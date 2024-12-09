import gleam/int
import gleam/list
import gleam/result
import gleam/string
import utils/list as li

type Block {
  File(Int)
  None
}

type Disk =
  List(Block)

fn generate_file_block(block_count, file_index) -> Disk {
  case block_count {
    "0" -> []
    _ ->
      list.range(1, result.unwrap(int.parse(block_count), 0))
      |> list.map(fn(_) { File(file_index / 2) })
  }
}

fn generate_space_block(block_count) -> Disk {
  case block_count {
    "0" -> []
    _ ->
      list.range(1, result.unwrap(int.parse(block_count), 0))
      |> list.map(fn(_) { None })
  }
}

fn generate_block(block_count, file_index) -> Disk {
  case int.is_even(file_index) {
    True -> generate_file_block(block_count, file_index)
    False -> generate_space_block(block_count)
  }
}

fn disk_map(input: String) -> Disk {
  string.to_graphemes(input)
  |> list.index_map(generate_block)
  |> list.flatten
}

fn defrag_complete(disk: List(Block), current_index: Int) -> Bool {
  let #(_, after) = list.split(disk, current_index + 1)

  result.is_error(list.find(after, fn(x) { x != None }))
}

fn rotate_block(disk: Disk, state: Disk) -> Disk {
  case li.pop(disk) {
    #(Ok(None), rest) -> rotate_block(rest, list.append(state, [None]))
    #(Ok(anyval), rest) -> list.append([anyval], list.append(rest, state))
    #(Error(_), _) -> disk
  }
}

fn disk_defrag(disk: Disk, current_index: Int) -> Disk {
  case defrag_complete(disk, current_index) {
    True -> disk
    False ->
      case li.at(disk, current_index) {
        Ok(None) -> {
          let #(defragged, undefragged) = list.split(disk, current_index)
          let assert #([None], remaining_undefragged) =
            list.split(undefragged, 1)
          let new_current_disk_map =
            list.append(
              defragged,
              list.append(rotate_block(remaining_undefragged, []), [None]),
            )

          disk_defrag(new_current_disk_map, current_index + 1)
        }
        Ok(_) -> disk_defrag(disk, current_index + 1)
        Error(_) -> disk
      }
  }
}

fn get_blkid(blk: Block) -> Result(Int, Nil) {
  case blk {
    File(id) -> Ok(id)
    None -> Error(Nil)
  }
}

fn checksum(input: Disk) -> Int {
  input
  |> list.filter_map(fn(x) { get_blkid(x) })
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
