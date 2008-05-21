require 'hpricot'
require 'icalendar'
class Fixtures
  def initialize
    @fixtures = []
  end

  def from_table_rows(trs)
    trs.each do |row|
      m=Match.new
      m.from_table_row(row)
      @fixtures.push(m)
    end
  end

  def to_ical
    cal = Icalendar::Calendar.new
    @fixtures.each do |f|
      cal.add(f.to_ical_event)
    end
    cal.to_ical
  end

  def to_s
    @fixtures.map{|x| x.to_s}
  end
end
