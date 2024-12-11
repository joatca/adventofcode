class DiskFile
  property :file_id, :length
  def initialize(@file_id : Int64?, @length : Int32) end
  def empty? @file_id.nil? end
  def file? @file_id end
  def to_s "#{@file_id.nil? ? "." : @file_id.to_s}" end
end

disk = [] of DiskFile
is_file = true
file_id = 0_i64
STDIN.each_line(chomp: true) do |line|
  line.each_char do |ch|
    disk << DiskFile.new(is_file ? file_id : nil, ch.to_i)
    file_id += 1 if is_file
    is_file = !is_file
  end
end

while file_id > 0
  file_id -= 1
  file_index = disk.rindex! { |f| f.file_id == file_id }
  leftmost_space_index = disk.index { |f| f.empty? && f.length >= disk[file_index].length }
  if leftmost_space_index && leftmost_space_index < file_index
    space = disk[leftmost_space_index]
    file = disk[file_index]
    disk[leftmost_space_index].length -= file.length
    disk[file_index] = DiskFile.new(nil, file.length)
    disk.insert(leftmost_space_index, file)
  end
end

checksum = 0_i64
index = 0
disk.each do |file|
  # well, this ended up more complex than it needed to be. Works though.
  if file.file?
    (index...(index + file.length)).each do |i|
      checksum += (file.file_id||0) * i
    end
  end
  index += file.length
end
puts checksum
