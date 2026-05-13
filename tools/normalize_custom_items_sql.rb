path = File.expand_path('../sql/custom_items.sql', __dir__)
text = File.read(path)

weapon_ids = {}
text.scan(/REPLACE INTO `item_weapon` VALUES\s*\n\s*\((\d+),/m) do |match|
  weapon_ids[match[0].to_i] = true
end

text.sub!(/^USE aoniaxi;\n\n/, '')

item_basic_pattern = /
  (REPLACE\ INTO\ `item_basic`\ VALUES\s*)
  \(
    (\d+),\s*
    (\d+),\s*
    '([^']*)',\s*
    '([^']*)',\s*
    (\d+),\s*
    (\d+),\s*
    (\d+),\s*
    (\d+),\s*
    (\d+)
  \);
/x

text.gsub!(item_basic_pattern) do
  prefix = Regexp.last_match(1)
  item_id = Regexp.last_match(2).to_i
  sub_id = Regexp.last_match(3)
  name = Regexp.last_match(4)
  sortname = Regexp.last_match(5)
  stack_size = Regexp.last_match(6)
  flags = Regexp.last_match(7)
  ah = Regexp.last_match(8)
  base_sell = Regexp.last_match(10)
  type = weapon_ids[item_id] ? 7 : 6

  "#{prefix}(#{item_id}, #{sub_id}, '#{name}', '#{sortname}', '#{name}', #{type}, #{stack_size}, #{flags}, #{ah}, #{base_sell});"
end

File.write(path, text)

puts "rewritten_item_basic=#{text.scan(/REPLACE INTO `item_basic` VALUES/).size}"
puts "remaining_use=#{text.include?('USE aoniaxi;')}"
