#!/usr/bin/env ruby
# frozen_string_literal: true

# class P4
class P4
  attr_reader :part1, :part2

  def initialize(filename)
    board = %w[
      MMMSXXMASM
      MSAMXMSMSA
      AMXSXMAAMM
      MSAMASMSMX
      XMASAMXAMM
      XXAMMXXAMA
      SMSMSASXSS
      SAXAMASAAA
      MAMMMXMMMM
      MXMXAXMASX
    ]
    board = File.readlines(filename)
    @part1 = board.size.times.map { |y| board[y].size.times.map { |x| count_xmas(board, y, x) }.sum }.sum
    @part2 = 0 # board.size.times.map { |y| board[y].size.times.map { |x| count_x_mas(board, y, x) }.sum }.sum
  end

  private

  def get(board, *idxs) # rubocop:disable Metrics/AbcSize
    idxs.map do |idx|
      if idx.first.negative? || idx.last.negative? || idx.first >= board.size || idx.last >= board[idx.first].size
        return nil
      end

      board[idx.first][idx.last]
    end.join
  end

  def count_xmas(board, y, x) # rubocop:disable Naming/MethodParameterName,Metrics/AbcSize
    [
      get(board, [y, x], [y, x + 1], [y, x + 2], [y, x + 3]), # right
      get(board, [y, x], [y, x - 1], [y, x - 2], [y, x - 3]), # left
      get(board, [y, x], [y + 1, x], [y + 2, x], [y + 3, x]), # down
      get(board, [y, x], [y - 1, x], [y - 2, x], [y - 3, x]), # up
      get(board, [y, x], [y + 1, x + 1], [y + 2, x + 2], [y + 3, x + 3]), # down-right
      get(board, [y, x], [y - 1, x + 1], [y - 2, x + 2], [y - 3, x + 3]), # up-right
      get(board, [y, x], [y + 1, x - 1], [y + 2, x - 2], [y + 3, x - 3]), # down-left
      get(board, [y, x], [y - 1, x - 1], [y - 2, x - 2], [y - 3, x - 3]) # up-left
    ].count { |e| e == 'XMAS' }
  end

  def count_x_mas(board, y, x) # rubocop:disable Naming/MethodParameterName
    d1 = [[y, x], [y + 1, x + 1], [y + 2, x + 2]]
    d2 = [[y, x + 2], [y + 1, x + 1], [y + 2, x]]
    d3 = [[y + 2, x], [y + 1, x + 1], [y, x + 2]]
    d4 = [[y + 2, x + 2], [y + 1, x + 1], [y, x]]
    [
      # 1-2-3
      get(board, *d1, *d2),
      get(board, *d1, *d3),
      # 2-1-4
      get(board, *d2, *d1),
      get(board, *d2, *d4),
      # 3-1-4
      get(board, *d3, *d1),
      get(board, *d3, *d4)
    ].count { |e| e == 'MASMAS' }
  end
end

if $PROGRAM_NAME == __FILE__
  p = P4.new('../input/4-1.input')
  print('Part 1 (2462): ')
  puts(p.part1)

  print('Part 2 (): ')
  puts(p.part2)
end
