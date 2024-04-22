require 'byebug'

master_list = [{x_start: 681, count: 2},
{x_start: 529, count: 1},
{x_start: 682, count: 2},
{x_start: 89, count: 1},
{x_start: 384, count: 3},
{x_start: 391, count: 1},
{x_start: 691, count: 1},
{x_start: 385, count: 1},
{x_start: 387, count: 1},
{x_start: 977, count: 1},
{x_start: 1275, count: 3},
{x_start: 1282, count: 1},
{x_start: 1276, count: 2},
{x_start: 979, count: 2},
{x_start: 978, count: 1},
{x_start: 1285, count: 1},
{x_start: 1033, count: 1},
{x_start: 1080, count: 1}]

def find_line_marker(boxes, key = :x_start)
    list = boxes.sort_by {|hsh| hsh[key]}

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

    [marker[:x_start], marker[:count]]
end

byebug

puts "done."
