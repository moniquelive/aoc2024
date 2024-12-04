#!/usr/bin/env ruby
# frozen_string_literal: true

# class P4
class P4
  attr_reader :part1, :part2

  def initialize(filename)
    board = File.readlines(filename).map(&:chomp)
    @part1 = count_patterns(board) { |y, x| xmas(board, y, x) }
    @part2 = count_patterns(board) { |y, x| x_mas(board, y, x) }
  end

  private

  def count_patterns(board)
    board.size.times.sum { |y| board[y].size.times.sum { |x| yield(y, x) } }
  end

  def get(board, coords)
    coords.map do |y, x|
      return nil if [y, x].any? { |i| i.negative? || i >= board.size }

      board[y][x]
    end.join
  end

  DIRECTIONS = [
    [[0, 1], [0, 2], [0, 3]], # right
    [[0, -1], [0, -2], [0, -3]], # left
    [[1, 0], [2, 0], [3, 0]],    # down
    [[-1, 0], [-2, 0], [-3, 0]], # up
    [[1, 1], [2, 2], [3, 3]],    # down-right
    [[-1, 1], [-2, 2], [-3, 3]], # up-right
    [[1, -1], [2, -2], [3, -3]], # down-left
    [[-1, -1], [-2, -2], [-3, -3]] # up-left
  ].freeze

  def xmas(board, y, x) # rubocop:disable Naming/MethodParameterName
    DIRECTIONS.count { |dir| get(board, [[y, x], *dir.map { |dy, dx| [y + dy, x + dx] }]) == 'XMAS' }
  end

  X_PATTERNS = [
    [[[0, 0], [1, 1], [2, 2]], [[0, 2], [1, 1], [2, 0]]],
    [[[0, 0], [1, 1], [2, 2]], [[2, 0], [1, 1], [0, 2]]],
    [[[2, 2], [1, 1], [0, 0]], [[0, 2], [1, 1], [2, 0]]],
    [[[2, 2], [1, 1], [0, 0]], [[2, 0], [1, 1], [0, 2]]]
  ].freeze

  def x_mas(board, y, x) # rubocop:disable Naming/MethodParameterName
    X_PATTERNS.count do |pattern|
      coords = pattern.map { |path| path.map { |dy, dx| [y + dy, x + dx] } }
      get(board, coords.flatten(1)) == 'MASMAS'
    end
  end
end

if $PROGRAM_NAME == __FILE__
  p = P4.new('../input/4-1.input')
  print('Part 1 (2462): ')
  puts(p.part1)

  print('Part 2 (1877): ')
  puts(p.part2)
end
