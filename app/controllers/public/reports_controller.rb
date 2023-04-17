class Public::ReportsController < ApplicationController
  
  def new
    @report = Report.new
    @user = User.find(params[:user_id])
  end
  
  def create
    @user = User.find(params[:user_id])
    @report = Report.new(report_params)
    # reporter = 報告したユーザー
    # reported = 報告されたユーザー
    @report.reporter_id = current_user.id
    @report.reported_id = @user.id
    if @report.save
      redirect_to user_path(@user), notice: "通報が完了しました"
    else
      render "new"
    end
  end
  
  
  private
  
  def report_params
    params.require(:report).permit(:reason, :url)
  end
  
end
