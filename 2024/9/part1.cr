class Block

  getter :file_id
  
  def initialize(@file_id : Int64?)
  end

  def empty?
    @file_id.nil?
  end

  def file?
    @file_id
  end
  
  def to_s
    "#{@file_id.nil? ? "." : @file_id.to_s}"
  end
end

disk = [] of Block

is_file = true
file_id = 0_i64
empty_block = Block.new(nil)

STDIN.each_line(chomp: true) do |line|
  line.each_char do |ch|
    disk += [is_file ? Block.new(file_id) : empty_block] * ch.to_i
    file_id += 1 if is_file
    is_file = !is_file
  end
end

file_block_count = disk.count { |b| b.file? }
empty_index = disk.index! { |b| b.empty? }
last_block_index = disk.rindex! { |b| b.file? }

while empty_index < file_block_count
  disk[empty_index] = disk[last_block_index]
  disk[last_block_index] = empty_block
  empty_index = disk.index!(empty_index + 1) { |b| b.empty? }
  last_block_index = disk.rindex!(last_block_index - 1) { |b| b.file? }
end

puts disk.each_with_index.map { |b, i| (b.file_id || 0_i64) * i }.sum
