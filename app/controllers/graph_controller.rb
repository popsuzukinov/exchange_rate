class GraphController < ApplicationController
  def index
    @end_at = @project.due_date
    @start_at = @project.start_date
    @categories = []
    @data = []
    @span_dt = ( @end_at - @start_at ) / 10
    @start_at.step( @end_at , @span_dt ){|dt|
       if @end_at - dt < @span_dt then
           calc_dt = @end_at
       else
           calc_dt = dt
       end
       @categories << calc_dt
       cnt_new = @project.issues.count(:all, :conditions => [ "start_date BETWEEN ? AND ?" , @start_at , calc_dt + @span_dt ] )
       cnt_end = @project.issues.count(:all, :conditions => [ "#{IssueStatus.table_name}.is_closed = ? AND #{Issue.table_name}.updated_on  BETWEEN ? AND ?" , true , @start_at , calc_dt + @span_dt ] )
       @data << cnt_new - cnt_end
    }
    @h = LazyHighCharts::HighChart.new("graph") do |f|
       f.chart(:type => "area")
       f.title(:text => "Opened Issue Graph")
       f.xAxis(:categories => @categories)
       f.series(:name => "'Opened Issue' - 'Closed Issue'", :data => @data)
    end
  end

end
