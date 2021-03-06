
require 'json'

class TextPrinter
  def initialize(name, last_name, house_number, street, town, postcode)
    @name = name
    @last_name = last_name
    @house_number = house_number
    @street = street
    @town = town
    @postcode = postcode
  end

  def print(color_code)
    # gets longest attributes size
    max_len = [@name, @last_name, @house_number, @street, @town, @postcode].max{|a, b| a.size <=> b.size }.size
    border = "=" * (max_len + 16)
    # prints as many '=' chars as there are in longest attribute plus 16 for two tabs
    puts border
    puts "\e[#{color_code}mName:\e[0m\t\t#{@name}"
    puts "\e[#{color_code}mLast name:\e[0m\t#{@last_name}"
    puts "\e[#{color_code}mHouse number:\e[0m\t#{@house_number}"
    puts "\e[#{color_code}mStreet:\e[0m\t\t#{@street}"
    puts "\e[#{color_code}mTown:\e[0m\t\t#{@town}"
    puts "\e[#{color_code}mPostcode:\e[0m\t#{@postcode}"
    # prints as many '=' chars as there are in longest attribute plus 16 for two tabs
    puts border
  end
end

class JSONPrinter
  def initialize(name, last_name, house_number, street, town, postcode)
    @name = name
    @last_name = last_name
    @house_number = house_number
    @street = street
    @town = town
    @postcode = postcode
  end

  def print(color_code)
    # creates hash with all attributes and converts it to json
    puts({
      color: color_code,
      name: @name,
      last_name: @last_name,
      house_number: @house_number,
      street: @street,
      town: @town,
      postcode: @postcode
    }.to_json)
  end
end

class HTMLPrinter
  def initialize(name, last_name, house_number, street, town, postcode)
    @name = name
    @last_name = last_name
    @house_number = house_number
    @street = street
    @town = town
    @postcode = postcode
  end

  def print(color_code)
    # sets css color based on shell color code
    style = html_style(color_code)
    # creates html table with style attribute
    html = %^
      <table>
        <th><td #{style}>Attribute</td><td>Value</td></th>
        <tr><td #{style}>Name</td><td>#{@name}</td></tr>
        <tr><td #{style}>Last name</td><td>#{@last_name}</td></tr>
        <tr><td #{style}>House number</td><td>#{@house_number}</td></tr>
        <tr><td #{style}>Street</td><td>#{@street}</td></tr>
        <tr><td #{style}>Town</td><td>#{@town}</td></tr>
        <tr><td #{style}>Postcode</td><td>#{@postcode}</td></tr>
      </table>
    ^
    # replaces 3 or more spaces with newline
    puts html.gsub(/\s{3,}/,"\n")
  end

  def html_style(color_code)
    if color_code == 30
      %^style="color: black"^
    elsif color_code == 31
      %^style="color: red"^
    elsif color_code == 32
      %^style="color: green"^
    elsif color_code == 33
      %^style="color: yellow"^
    elsif color_code == 34
      %^style="color: blue"^
    elsif color_code == 35
      %^style="color: magenta"^
    elsif color_code == 36
      %^style="color: cyan"^
    elsif color_code == 37
      %^style="color: white"^
    end
  end
end

class Person
  attr_reader :name, :last_name, :house_number, :street, :town, :postcode

  def initialize(name, last_name, house_number, street, town, postcode)
    @name = name
    @last_name = last_name
    @house_number = house_number
    @street = street
    @town = town
    @postcode = postcode
  end

  def print(format, color_code)
    if format == :text
      print_text(color_code)
    elsif format == :json
      print_json(color_code)
    elsif format == :html
      print_html(color_code)
    else
      puts self.inspect
    end
  end

  def print_text(color_code)
    text_printer = TextPrinter.new(@name, @last_name, @house_number, @street, @town, @postcode)
    text_printer.print(color_code)
  end

  def print_json(color_code)
    json_printer = JSONPrinter.new(@name, @last_name, @house_number, @street, @town, @postcode)
    json_printer.print(color_code)
  end

  def print_html(color_code)
    html_printer = HTMLPrinter.new(@name, @last_name, @house_number, @street, @town, @postcode)
    html_printer.print(color_code)
  end

  def to_hash
    {
      name: @name,
      last_name: @last_name,
      house_number: @house_number,
      street: @street,
      town: @town,
      postcode: @postcode
    }
  end
end

john = Person.new("John", "Deer", "1", "Baker street", "London", "W1U 8ED")
john.print(:text, 36)
john.print(:json, 36)
john.print(:html, 36)
john.print(:unknown, 36)
p john.to_hash
