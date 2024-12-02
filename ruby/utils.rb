#!/usr/bin/env ruby
# frozen_string_literal: true

# 🐒️ patch
class Array
  def remove_at(idx)
    reject.with_index { |_, j| j == idx }
  end
end
