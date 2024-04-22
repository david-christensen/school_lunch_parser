require 'rtesseract'
require 'byebug'

def find_line_marker(boxes, key = :x_start)
  # group date_boxes by x_start
  grouped_date_boxes = boxes.group_by {|hsh| hsh[key]}

  # count each group of boxes by x_start value
  grouped_date_boxes.each {|k,v| puts "#{key}: #{k}, count: #{v.count}"}
  list = grouped_date_boxes.map {|k,v| {key => k, count: v.count}}.sort_by {|hsh| hsh[key]}

  merged_list = []

  while current = list.shift
      current_x_start = current[key]

      while next_line_i = list.find_index{|hsh| hsh[key] == (current_x_start + 1) }
          next_line = list.delete_at(next_line_i)
          current[:count] = current[:count] + next_line[:count]
          current_x_start += 1
      end

      merged_list.push(current)
  end

  marker = merged_list.sort_by {|hsh| hsh[:count]}.reverse.first
  
  [marker[key], marker[:count]]
end

image_path = "./img/April2024.jpg"

obj = RTesseract.new(image_path)
boxed = obj.to_box

# Find boxed words that appear to be days of the month
date_boxes = boxed.select {|hsh| hsh[:word].match(/^[0-9]{1,2}$/)}

x_start, x_count = find_line_marker(date_boxes, :x_start)
y_start, y_count = find_line_marker(date_boxes, :y_start)

table_y_start = date_boxes.select{|box| (x_start..(x_start+2)).include?(box[:x_start])}.map{|hsh| hsh[:y_start]}.min

x_row_y_starts = date_boxes.select{|box| (x_start..(x_start+2)).include?(box[:x_start])}.map{|hsh| hsh[:y_start]}.sort

# Calculate differences between consecutive numbers
differences = []
x_row_y_starts.each_cons(2) { |a, b| differences << b - a }

# Calculate the average difference
average_difference = (differences.sum.to_f / differences.length).to_i

# Not quite - needs to be adjusted by average distance between boxes
table_y_end = date_boxes.select{|box| (x_start..(x_start+2)).include?(box[:x_start])}.map{|hsh| hsh[:y_end]}.max + average_difference

table_x_start = date_boxes.select{|box| (y_start..(y_start+2)).include?(box[:y_start])}.map{|hsh| hsh[:x_start]}.min

# Not quite - needs to be adjusted by average distance between boxes
y_column_x_starts = date_boxes.select{|box| (y_start..(y_start+2)).include?(box[:y_start])}.map{|hsh| hsh[:x_start]}.sort

# Calculate differences between consecutive numbers
differences = []
y_column_x_starts.each_cons(2) { |a, b| differences << b - a }

# Calculate the average difference
average_difference = (differences.sum.to_f / differences.length).to_i

table_x_end = date_boxes.select{|box| (y_start..(y_start+2)).include?(box[:y_start])}.map{|hsh| hsh[:x_end]}.max + average_difference


avg_column_size = (table_x_end - table_x_start) / 5
avg_row_size = (table_y_end - table_y_start) / 5


# example of where to find the coordinates of the box for April 3rd
x_start = 675; x_end = 961; y_start = 194; y_end = 373 # 3 with this y_start

x_start = 675; x_end = 961; y_start = 379; y_end = 557 # 5  with this y_start

x_start = 675; x_end = 961; y_start = 563; y_end = 745 # 4 with y_start of 567

x_start = 675; x_end = 961; y_start = 750; y_end = 929 # 3 with y_start of 751

x_start = 675; x_end = 961; y_start = 930; y_end = 1109 # 2 with y_start of 935
boxed.select {|hsh| hsh[:x_start] >= x_start and hsh[:x_end] <= x_end  and hsh[:y_start] >= y_start and hsh[:y_end] <= y_end }

byebug

puts "Done."

