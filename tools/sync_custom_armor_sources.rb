#!/usr/bin/env ruby
# frozen_string_literal: true

ROOT = File.expand_path('..', __dir__)
SOURCE_PATH = File.join(ROOT, 'armor2_custom_reworked.yml')
TARGETS = %w[armor.yml armor2.yml].map { |name| File.join(ROOT, name) }

def split_blocks(text)
  header_lines = []
  blocks = []
  current_id = nil
  current_lines = []
  in_items = false

  text.each_line do |line|
    if line.start_with?('- id: ')
      in_items = true
      unless current_id.nil?
        blocks << [current_id, current_lines.join]
      end
      current_id = line.split(':', 2).last.to_i
      current_lines = [line]
    elsif current_id
      current_lines << line
    elsif !in_items
      header_lines << line
    end
  end

  blocks << [current_id, current_lines.join] unless current_id.nil?
  [header_lines.join, blocks]
end

source_header, source_blocks_list = split_blocks(File.read(SOURCE_PATH))
source_blocks = source_blocks_list.to_h
updated = Hash.new(0)

TARGETS.each do |path|
  header, blocks = split_blocks(File.read(path))
  rewritten_blocks = blocks.map do |id, block|
    if source_blocks.key?(id)
      updated[File.basename(path)] += 1
      source_blocks[id]
    else
      block
    end
  end

  File.write(path, header + rewritten_blocks.join)
end

puts "updated=#{updated.sort.map { |k, v| "#{k}:#{v}" }.join(' ')}"
