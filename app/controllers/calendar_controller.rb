class CalendarController < ApplicationController
  caches_page :matches

  def matches
    @fixtures = Fixtures.new
    @id = params[:id]

    if @id.to_i > 0
      rows = get_table_rows(params[:id])
      @fixtures.from_table_rows(rows)

      respond_to do |format|
        format.html
        format.ics {render :text => @fixtures.to_ical}
      end
    else
      raise "Illegal ID"
    end
  end


  private
  def get_table_rows(team_id)
    require 'hpricot'
    require 'open-uri'

    # TODO: Check sanity of team_id
    doc = Hpricot(open("http://idrett.speaker.no/07/organisation.aspx?WCI=wiTeamResults&WCU=#{team_id}&HideKO=y"))

    doc/"table.tblFixtures"/"tr.even"
  end
end
