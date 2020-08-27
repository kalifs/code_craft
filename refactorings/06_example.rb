
require 'json'

class TextPrinter
  def initialize(title, name, last_name, house_number, street, town, postcode)
    @title = title
    @name = name
    @last_name = last_name
    @house_number = house_number
    @street = street
    @town = town
    @postcode = postcode
  end

  def print(color_code)
    # gets longest attributes size
    max_len = [@title, @name, @last_name, @house_number, @street, @town, @postcode].max{|a, b| a.size <=> b.size }.size
    border = "=" * (max_len + 16)
    # prints as many '=' chars as there are in longest attribute plus 16 for two tabs
    puts border
    puts "\e[#{color_code}mTitle:\e[0m\t\t#{@title}"
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
  def initialize(title, name, last_name, house_number, street, town, postcode)
    @title = title
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
      title: @title,
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
  def initialize(title, name, last_name, house_number, street, town, postcode)
    @title = title
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
        <tr><td #{style}>Title</td><td>#{@title}</td></tr>
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

class PersonPrinter
  def initialize(person)
    @person = person
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
    text_printer = TextPrinter.new(@person.title, @person.name, @person.last_name, @person.house_number, @person.street, @person.town, @person.postcode)
    text_printer.print(color_code)
  end

  def print_json(color_code)
    json_printer = JSONPrinter.new(@person.title, @person.name, @person.last_name, @person.house_number, @person.street, @person.town, @person.postcode)
    json_printer.print(color_code)
  end

  def print_html(color_code)
    html_printer = HTMLPrinter.new(@person.title, @person.name, @person.last_name, @person.house_number, @person.street, @person.town, @person.postcode)
    html_printer.print(color_code)
  end
end

class Person
  attr_reader :title, :name, :last_name, :house_number, :street, :town, :postcode

  def initialize(title, name, last_name, house_number, street, town, postcode)
    @title = title
    @name = name
    @last_name = last_name
    @house_number = house_number
    @street = street
    @town = town
    @postcode = postcode
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

john = Person.new("Mr", "John", "Deer", "1", "Baker street", "London", "W1U 8ED")

print = PersonPrinter.new(john)
print.print(:text, 36)
print.print(:json, 36)
print.print(:html, 36)
print.print(:unknown, 36)
p john.to_hash
