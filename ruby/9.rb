#!/usr/bin/env ruby
# frozen_string_literal: true

# class P9
class P9
  attr_reader :part1, :part2

  def initialize(filename)
    # line = '2333133121414131402'.split('').map(&:to_i)
    line = File.read(filename).split('').map(&:to_i)
    parsed = parse(line)
    # @part1 = checksum(compact(parsed.dup))
    @part2 = checksum(compact2(parsed.dup))
  end

  private

  def parse(line)
    index = 0
    line.map.with_index do |n, i|
      if i.even?
        index += 1
        [index - 1] * n
      else
        [nil] * n
      end
    end.flatten
  end

  def compact(line)
    while (n = line.index(nil))
      line.pop while line[-1].nil?
      line[n] = line.pop
    end
    line
  end

  def find_nil_sequence(array, count) # rubocop:disable Metrics/MethodLength
    return nil if array.empty? || count <= 0

    current_nils = 0
    start_index = nil

    array.each_with_index do |element, index|
      if element.nil?
        start_index = index if current_nils.zero?
        current_nils += 1
        return start_index if current_nils >= count
      else
        current_nils = 0
        start_index = nil
      end
    end

    nil # Return nil if no sequence found
  end

  def compact2(line) # rubocop:disable Metrics/MethodLength
    index = line.size - 1
    while index >= 0
      while (candidate = line[index]).nil?
        index -= 1
      end
      c = line.count(candidate)
      if !(n = find_nil_sequence(line, c)).nil? && n < index
        c.times do |i|
          line[n + i], line[index] = line[index], line[n + i]
          index -= 1
        end
      else
        index -= c
      end
    end
    line
  end

  def checksum(line)
    line.map.with_index { |n, i| n.nil? ? 0 : i * n }.sum
  end
end

if $PROGRAM_NAME == __FILE__
  p = P9.new('../input/9-1.input')
  puts("Part 1 (6334655979668): #{p.part1}")
  puts("Part 2 (6349492251099): #{p.part2}")
end
