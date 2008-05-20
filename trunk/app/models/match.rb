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
    columns = row/"td"
    date = columns[0].inner_html
    start_time = columns[1].inner_html
    @event.start = DateTime.strptime(date + " " + start_time, "%d.%m.%Y %H:%M")
    @event.end = @event.start + 105.minutes

    home_team, result, away_team, tournament, venue = 
      columns[2,5].map{|e| format_element(e)}
    
    @event.location = venue if venue
    @event.summary = "#{home_team} - #{away_team}"
    @event.summary += " #{result}" if result != "-"
    @event.organizer = tournament
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
