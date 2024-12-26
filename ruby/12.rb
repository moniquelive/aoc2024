#!/usr/bin/env ruby
# frozen_string_literal: true

# class P12
class P12
  def initialize(filename)
    # lines = <<~LINES.split("\n")
    #   RRRRIICCFF
    #   RRRRIICCCF
    #   VVRRRCCFFF
    #   VVRCCCJFFF
    #   VVVVCJJCFE
    #   VVIVCCJJEE
    #   VVIIICJJEE
    #   MIIIIIJJEE
    #   MIIISIJEEE
    #   MMMISSJEEE
    # LINES
    lines = File.readlines(filename)
    @board = lines.map { |line| line.chomp.split('') }
  end

  def part1
    visited = Set.new
    @board.size.times.flat_map do |j|
      @board[j].size.times.map do |i|
        coord = [i, j]
        next if visited.include?(coord)

        (1 + area(coord, visited)) * perimeter(coord, Set.new)
      end.compact
    end.sum
  end

  def part2
    visited = Set.new
    @board.size.times.flat_map do |j|
      @board[j].size.times.map do |i|
        coord = [i, j]
        next if visited.include?(coord)

        (1 + area(coord, visited)) * sides(coord, Set.new)
      end.compact
    end.sum
  end

  private

  def area(coord, visited)
    flower = cell(coord)
    [[-1, 0], [1, 0], [0, -1], [0, 1]].sum do |(dx, dy)|
      visited << coord

      new_coord = [coord.first + dx, coord.last + dy]
      if !visited.include?(new_coord) && cell(new_coord) == flower
        1 + area(new_coord, visited)
      else
        0
      end
    end
  end

  def perimeter(coord, visited) # rubocop:disable Metrics/MethodLength
    flower = cell(coord)
    [[-1, 0], [1, 0], [0, -1], [0, 1]].sum do |(dx, dy)|
      visited << coord

      new_coord = [coord.first + dx, coord.last + dy]
      (cell(new_coord) != flower ? 1 : 0) +
        if !visited.include?(new_coord) && cell(new_coord) == flower
          perimeter(new_coord, visited)
        else
          0
        end
    end
  end

  def sides(coord, visited) # rubocop:disable Metrics/MethodLength
    flower = cell(coord)
    dd = [[0, -1], [1, 0], [0, 1], [-1, 0]]
    dd.each_with_index.sum do |(dx, dy), i|
      visited << coord

      new_coord = [coord.first + dx, coord.last + dy]
      count_sides(coord, dd, i) +
        if !visited.include?(new_coord) && cell(new_coord) == flower
          sides(new_coord, visited)
        else
          0
        end
    end
  end

  def count_sides(coord, delta, index) # rubocop:disable Metrics/AbcSize
    flower = cell(coord)
    new_coord = [coord.first + delta[index].first, coord.last + delta[index].last]
    return 0 if cell(new_coord) == flower

    perpendicular = [coord.first + delta[(index - 1) % 4].first, coord.last + delta[(index - 1) % 4].last]
    corner = [new_coord.first + delta[(index - 1) % 4].first, new_coord.last + delta[(index - 1) % 4].last]

    cell(perpendicular) != flower || cell(corner) == flower ? 1 : 0
  end

  def cell(coords)
    return '' if coords.last.negative? || coords.last >= @board.size
    return '' if coords.first.negative? || coords.first >= @board.first.size

    @board[coords.last][coords.first]
  end
end

if $PROGRAM_NAME == __FILE__
  p = P12.new('../input/12-1.input')
  puts("Part 1 (1381056): #{p.part1}")
  puts("Part 2 (834828): #{p.part2}")
end
