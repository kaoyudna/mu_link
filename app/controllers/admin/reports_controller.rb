class Admin::ReportsController < ApplicationController
  
  def index
    @reports = Report.all
  end
  
  def show
    @report = Report.find(params[:id])
  end
  
  def update
    @report = Report.find(params[:id])
    if @report.update(report_params)
      redirect_to request.referer, notice: "対応ステータスを更新しました。"
    end
  end
  
  private
  
  def report_params
    params.require(:report).permit(:status)
  end
  
end
