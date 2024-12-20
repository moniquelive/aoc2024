#!/usr/bin/env ruby
# frozen_string_literal: true

# class P10
class P10
  attr_reader :part1, :part2

  def initialize(filename) # rubocop:disable Metrics/MethodLength,Metrics/AbcSize,Metrics/CyclomaticComplexity
    # lines = <<~LINES.split("\n")
    #   89010123
    #   78121874
    #   87430965
    #   96549874
    #   45678903
    #   32019012
    #   01329801
    #   10456732
    # LINES
    @neighbors = [
      [-1, 0],
      [1, 0],
      [0, -1],
      [0, 1]
    ]
    lines = File.readlines(filename)
    @board = lines.map { |line| line.chomp.split('').map(&:to_i) }
    @height = @board.size
    @width = @board.first.size
    zeroes = @board.size.times.flat_map { |j| @board[j].size.times.map { |i| [i, j] if @board[j][i].zero? }.compact }
    @part1 = zeroes.map { |start| walk(start, Set.new) }.sum
    @part2 = zeroes.map { |start| walk2(start, Set.new) }.sum
  end

  private

  def walk(from, visited) # rubocop:disable Metrics/MethodLength
    return 0 unless in_board?(from)
    return 0 if visited.include?(from)

    visited << from
    here = cell(from)
    return 1 if here == 9

    @neighbors.sum do |(dx, dy)|
      there = [from[0] + dx, from[1] + dy]
      next 0 unless in_board?(there)
      next 0 unless here + 1 == cell(there)

      walk(there, visited)
    end
  end

  def walk2(from, visited)
    return 0 unless in_board?(from)

    visited << from
    here = cell(from)
    return 1 if here == 9

    @neighbors.sum do |(dx, dy)|
      there = [from[0] + dx, from[1] + dy]
      next 0 unless in_board?(there) && here + 1 == cell(there)

      walk2(there, visited)
    end
  end

  def in_board?(coord)
    coord[0] >= 0 && coord[0] < @width && coord[1] >= 0 && coord[1] < @height
  end

  def cell(coord)
    @board[coord[1]][coord[0]]
  end
end

if $PROGRAM_NAME == __FILE__
  p = P10.new('../input/10-1.input')
  puts("Part 1 (798): #{p.part1}")
  puts("Part 2 (1816): #{p.part2}")
end
