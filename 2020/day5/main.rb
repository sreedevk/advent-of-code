file = File.open('./data.txt', 'r')
# file = File.open('./aoc5sample.txt', 'r')
passes = file.readlines.map(&:strip)

$seat_ids = []

def parse_row(row_ident)
  rows = (0..127).to_a
  row_ident.chars.each do |bound_specifier|
    if bound_specifier    == 'F'
      rows = (rows[0]..rows[rows.length/2]).to_a
    elsif bound_specifier == 'B'
      rows = (rows[(rows.length/2)]..rows[-1]).to_a
    else
      puts "ERROR! WRONG ROW SPECIFIER"
    end
    puts "bound: #{bound_specifier}, range: #{rows[0]}..#{rows[-1]}"
  end
  return rows
end

def parse_column(col_ident)
  cols = (0..7).to_a
  col_ident.chars.each do |bound_specifier|
    if bound_specifier == 'L'
      cols = (cols[0]..cols[cols.length/2]).to_a
    elsif bound_specifier == 'R'
      cols = (cols[cols.length/2]..cols[-1]).to_a
    else
      puts "ERROR! WRONG COL SPECIFIER"
    end
    puts "bound: #{bound_specifier}, range: #{cols[0]}..#{cols[-1]}"
  end
  return cols
end

passes.map do |pass|
  row_identifier = pass[0..6]
  column_identifier = pass[7..]
  selected_row, _    = parse_row(row_identifier)
  selected_column, _ = parse_column(column_identifier)
  puts "selected_row: #{selected_row}"
  puts "selected_column #{selected_column}"
  puts "end of pass"
  $seat_ids << ((selected_row * 8) + selected_column)
end

puts "seat_ids: #{$seat_ids.sort!.inspect}"
puts "highest_seat_id: #{$seat_ids.max}"

my_seat_id = nil

$seat_ids.each_with_index do |seat_id, i|
  my_seat_id = $seat_ids[i.next] unless $seat_ids[i.next] == $seat_ids[i].next
end
