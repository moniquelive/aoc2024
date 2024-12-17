#!/usr/bin/env ruby
# frozen_string_literal: true

# class P8
class P8
  attr_reader :part1, :part2

  def initialize(filename) # rubocop:disable Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/MethodLength,Metrics/PerceivedComplexity
    # lines = <<~LINES.split("\n")
    #   ............
    #   ........0...
    #   .....0......
    #   .......0....
    #   ....0.......
    #   ......A.....
    #   ............
    #   ............
    #   ........A...
    #   .........A..
    #   ............
    #   ............
    # LINES
    lines = File.readlines(filename)
    board = lines.map { |line| line.chomp.split('') }
    height = board.size
    width = board.first.size
    antennas = board.size.times.flat_map do |j|
                 board[j].size.times.map do |i|
                   [board[j][i], [i, j]] if board[j][i] =~ /[a-zA-Z0-9]/
                 end.compact
               end.compact.group_by(&:first).transform_values { |v| v.map(&:last) } # rubocop:disable Style/MultilineBlockChain

    @part1 = antennas.flat_map do |(_, coords)|
      coords.combination(2).flat_map do |a, b|
        dx = (a.first - b.first)
        dy = (a.last - b.last)
        d_angle = Math.atan2(dy, dx).abs * (180 / Math::PI)
        dx = dx.abs
        dy = dy.abs

        Set.new.tap do |ps|
          case d_angle
          when 0..90
            ps << [a.first + dx, a.last - dy]
            ps << [b.first - dx, b.last + dy]
          when 90..180
            ps << [a.first - dx, a.last - dy]
            ps << [b.first + dx, b.last + dy]
          else
            raise 'Invalid angle'
          end
        end.filter { |p| (0...width).cover?(p.first) && (0...height).cover?(p.last) } # rubocop:disable Style/MultilineBlockChain
      end
    end.compact.to_set.size

    @part2 = antennas.flat_map do |(_, coords)| # rubocop:disable Metrics/BlockLength
      coords.combination(2).flat_map do |x, y| # rubocop:disable Metrics/BlockLength
        a = x.dup
        b = y.dup
        dx = a.first - b.first
        dy = a.last - b.last
        d_angle = Math.atan2(dy, dx).abs * (180 / Math::PI)
        dx = dx.abs
        dy = dy.abs

        Set.new.tap do |ps|
          case d_angle
          when 0..90
            while (0...width).cover?(a.first) || (0...height).cover?(a.last) || (0...width).cover?(b.first) || (0...height).cover?(b.last)
              ps << [a.first, a.last]
              ps << [b.first, b.last]
              a[0] += dx
              a[1] -= dy
              b[0] -= dx
              b[1] += dy
            end
          when 90..180
            while (0...width).cover?(a.first) || (0...height).cover?(a.last) || (0...width).cover?(b.first) || (0...height).cover?(b.last)
              ps << [a.first, a.last]
              ps << [b.first, b.last]
              a[0] -= dx
              a[1] -= dy
              b[0] += dx
              b[1] += dy
            end
          else
            raise 'Invalid angle'
          end
        end.filter { |p| (0...width).cover?(p.first) && (0...height).cover?(p.last) }
      end
    end.compact.to_set.size
  end
end

if $PROGRAM_NAME == __FILE__
  p = P8.new('../input/8-1.input')
  puts("Part 1 (323): #{p.part1}")
  puts("Part 2 (1077): #{p.part2}")
end
