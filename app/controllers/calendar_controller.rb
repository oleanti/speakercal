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

    raise RuntimeError, "Illegal ID" unless /^\d+$/.match(team_id.to_s) and team_id.to_s.length < 8
    if team_id.to_i > 10000
      doc = Hpricot(open("http://idrett.speaker.no/07/organisation.aspx?WCI=wiTeamResults&WCU=#{team_id}&HideKO=y"))
      doc/"table.tblFixtures"/"tr.even"
    else
      logger.info "Using new URL"
      doc = Hpricot(open("http://fotball.speaker.no/FiksFotballdataClient/ft.aspx?scr=teamresult&flid=#{team_id}"))
      (doc/"table.clCommonGrid tbody > tr").delete_if{|node| node.children.length != 9}
    end
  end
end
