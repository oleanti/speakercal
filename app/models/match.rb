require 'icalendar'
require 'hpricot'
require 'htmlentities'

class Match
  def initialize
    @event = Icalendar::Event.new
  end
  
  # This takes a Hpricot.element, which should be a table row from
  # speaker.no, and turns it into a match object (which, incidentally,
  # is stored internally as an iCalendar Event object
  def from_table_row(row)
    if (row/"td").length == 7
      from_old_table_row row
    elsif (row/"td").length == 4
      from_new_table_row row
    end
  end
  
  def from_old_table_row(row)
    columns = row/"td"
    data = Hash.new

    date = columns[0].inner_html
    start_time = columns[1].inner_html
    data[:start_time] = DateTime.strptime(date + " " + start_time, "%d.%m.%Y %H:%M")

    %w{home_team result away_team tournament venue}.each_with_index do |key, index|
      data.store(key.to_sym, format_element(columns[index + 2]))
    end
    puts data.inspect
    from_data(data)
  end

  def from_new_table_row(row)
    columns = row/"td"
    data = Hash.new
    data[:start_time]=DateTime.strptime((columns[0]/"a").inner_html, "%Y-%m-%d %H:%M")
    data[:tournament]=format_element(columns[1])
    teams = format_element(columns[2]).split(" - ")
    data[:home_team]=teams[0]
    data[:away_team]=teams[1]
    data[:result]=format_element(columns[3])

    from_data(data)
  end

  def from_data(data)
    @event.start = data[:start_time]
    @event.end = @event.start + 105.minutes
    @event.location = data[:venue] if data[:venue]
    @event.summary = "#{data[:home_team]} - #{data[:away_team]}"
    @event.summary += " #{data[:result]}" unless data[:result].blank?
    @event.organizer = data[:tournament]
  end

  # This returns the match as an iCalendar @event
  def to_ical_event
    @event
  end

  # Returns the match as a string
  def to_s
    "<p><strong>#{@event.summary}</strong><br/>
    <small>(<em>#{@event.location}</em>, 
    #{@event.start.strftime('%d.%m.%Y %H:%M')})</small></p>\n"
  end

  private
  def format_element(element)
    coder=HTMLEntities.new
    coder.decode( (element/:a).inner_html.strip ) if element
  end
end
