class CalendarController < ApplicationController
  caches_page :matches

  def matches
    @fixtures = Fixture.new
    @id = params[:id]

    rows = get_table_rows(@id)
    @fixtures.from_table_rows(rows)

    respond_to do |format|
      format.html
      format.ics {render :text => @fixtures.to_ical}
    end
  end


  private
  def get_table_rows(team_id)
    require 'hpricot'
    require 'open-uri'

    if (/^\d+$/.match(team_id.to_s))
      doc = Hpricot(open("http://idrett.speaker.no/07/organisation.aspx?WCI=wiTeamResults&WCU=#{team_id}&HideKO=y"))
      doc/"table.tblFixtures"/"tr.even"
    else
      raise RuntimeError, "Illegal ID"
    end
  end
end
