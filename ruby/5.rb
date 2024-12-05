#!/usr/bin/env ruby
# frozen_string_literal: true

# class P5
class P5
  attr_reader :part1, :part2

  def initialize(filename) # rubocop:disable Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/MethodLength,Metrics/PerceivedComplexity
    rules, pages = File.read(filename).split("\n\n")
    @rules = rules.split("\n")
                  .map { |l| l.split('|') }
                  .map { |r| [r[0].to_i, r[1].to_i] }
                  .group_by(&:first)
                  .transform_values { |a| a.map(&:last) }
    pages = pages
            .split("\n")
            .map { |l| l.split(',') }
            .map { |p| p.map(&:to_i) }

    sum = ->(pp) { pp.map { |p| p[p.size / 2] }.sum }
    sort = ->(pp) { pp.sort { |a, b| @rules[a]&.include?(b) ? 1 : -1 } }

    @part1 = sum.call(pages.filter { |p| valid?(p) })
    @part2 = sum.call(pages.reject { |p| valid?(p) }.map { |p| sort.call(p) })
  end

  private

  def valid?(page)
    page.each.with_index.none? do |p, i|
      @rules.key?(p) \
        && (page[...i].any? { |p2| @rules[p].include?(p2) } || \
            !page[i + 1..].all? { |p2| @rules[p].include?(p2) })
    end
  end
end

if $PROGRAM_NAME == __FILE__
  p = P5.new('../input/5-1.input')
  print('Part 1 (5208): ')
  puts(p.part1)

  print('Part 2 (6732): ')
  puts(p.part2)
end
