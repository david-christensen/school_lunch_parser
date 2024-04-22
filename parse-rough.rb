require 'rtesseract'

image_path = "./img/April2024-rough.jpg"

obj = RTesseract.new(image_path)
boxed = obj.to_box

# Find boxes which appear to be dates
boxed.select {|hsh| hsh[:word].match(/^[0-9]{1,2}$/)}

# example of where to find the coordinates of the box for April 3rd
x_start = 1666
x_end = 2300
y_start = 490
y_end = 890

pp boxed.select {|hsh| hsh[:x_start] > x_start and hsh[:x_start] < x_end  and hsh[:y_start] > y_start and hsh[:y_start] < y_end }

