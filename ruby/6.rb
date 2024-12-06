#!/usr/bin/env ruby
# frozen_string_literal: true

# class Guard
class Guard
  attr_reader :position, :path

  def initialize(initial_position)
    @direction = [0, -1]
    @position = initial_position
    @path = Set.new
    @loop = Set.new # pos + dir
  end

  def steps
    @path.size
  end

  def backup
    @position[0] -= @direction[0]
    @position[1] -= @direction[1]
    @path.delete(@position)
    @loop.delete([@position, @direction])
  end

  def walk
    @path.add(@position.dup)
    @loop.add([@position.dup, @direction.dup])
    @position[0] += @direction[0]
    @position[1] += @direction[1]
  end

  def loop?
    @loop.include?([@position, @direction])
  end

  def rotate
    case @direction
    when [0, -1] then @direction = [1, 0] # up -> right
    when [1, 0] then @direction = [0, 1] # right -> down
    when [0, 1] then @direction = [-1, 0] # down -> left
    when [-1, 0] then @direction = [0, -1] # left -> up
    else
      raise "unknown direction #{@direction}"
    end
  end
end

# class Board
class Board
  def initialize(lines)
    @grid = lines.map(&:chomp).map(&:chars)
  end

  def start_cell
    @start_cell ||= @grid.each_with_index { |row, y| row.each_with_index { |cell, x| return [x, y] if cell == '^' } }
    raise 'No start cell found' if @start_cell.nil?
  end

  def block(x, y)
    raise "Out of bounds (#{x},#{y})" if x.negative? \
      || x >= @grid.size \
      || y.negative? \
      || y >= @grid[0].size

    @grid[y][x] = '#'
  end

  def cell_at(x, y)
    raise 'Out of bounds' if x.negative? \
      || x >= @grid.size \
      || y.negative? \
      || y >= @grid[0].size

    @grid[y][x]
  end
end

# class P6
class P6
  def initialize(filename)
    @board = Board.new(File.readlines(filename)).freeze
    @guard = Guard.new(@board.start_cell)
  end

  def part1
    traverse(@guard, @board)
  rescue StandardError
    # left the map
    @part1 ||= @guard.steps
  end

  def part2
    candidates = @guard.path
    candidates.delete(@board.start_cell)
    candidates = candidates.to_a
    loops = 0
    until candidates.empty?
      board = Marshal.load(Marshal.dump(@board)) # deep copy
      board.block(*candidates.pop)
      guard = Guard.new(board.start_cell)
      catch :loop do
        traverse(guard, board) { loops += 1 and throw :loop if guard.loop? }
      rescue StandardError
        next
      end
    end
    loops
  end

  private

  def traverse(guard, board)
    while guard.walk
      next unless board.cell_at(*guard.position) == '#'

      guard.backup
      guard.rotate
      yield if block_given?
    end
  end
end

if $PROGRAM_NAME == __FILE__
  p = P6.new('../input/6-1.input')
  puts("Part 1 (4883): #{p.part1}")
  puts("Part 2 (1655): #{p.part2}")
end
