$current_x, $current_y = 0, 0
$tree_count = 0

def traverse
  1.times do
    if $current_x == 30
      ($current_x = 0)
    else
      $current_x += 1
    end
  end
  $current_y += 2
  return unless $current_y < $geomap.length
  $tree_count+= 1 if $geomap[$current_y][$current_x] == "#"
  puts "current_y: #{$current_y}, current_x: #{$current_x}, tree_count: #{$tree_count}"
end

$geomap.each do
  break if $current_y >= $geomap.length

  traverse
end

puts "FINAL: current_y: #{$current_y}, current_x: #{$current_x}, tree_count: #{$tree_count}"
