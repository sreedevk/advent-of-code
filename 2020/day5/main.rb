require 'pry'

file = File.open('./data.txt', 'r')
passes = file.readlines.map(&:strip)

$seat_ids = []

def parse_row(row_ident)
  rows = (0..127).to_a
  row_ident.chars.each do |bound_specifier|
    if bound_specifier    == 'F'
      rows = (rows[0]..rows[rows.length/2]).to_a
    else
      rows = (rows[(rows.length/2)]..rows[-1]).to_a
    end
  end
  return rows
end

def parse_column(col_ident)
  cols = (0..7).to_a
  col_ident.chars.each do |bound_specifier|
    if bound_specifier == 'L'
      cols = (cols[0]..cols[cols.length/2]).to_a
    else
      cols = (cols[cols.length/2]..cols[-1]).to_a
    end
  end
  return cols
end

passes.map do |pass|
  row_identifier = pass[0..6]
  column_identifier = pass[7..]
  selected_row, _    = parse_row(row_identifier)
  selected_column, _ = parse_column(column_identifier)
  $seat_ids << ((selected_row * 8) + selected_column)
end

puts "highest_seat_id (part1): #{$seat_ids.max}"

my_seat_id = nil

$seat_ids.each_with_index do |seat_id, i|
  my_seat_id = $seat_ids[i.next] unless $seat_ids[i.next] == $seat_ids[i].next
end

$seat_ids.sort!

my_seat_id = $seat_ids.find do |seat_id|
  $seat_ids[$seat_ids.index(seat_id).next] != seat_id.next
end.next

puts "my_seat_id (part2): #{my_seat_id}"
