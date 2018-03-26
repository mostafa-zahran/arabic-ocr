class HomeController < ApplicationController
  before_action :set_shared_params

  def index
    @extracted_text = ''
  end

  def ocr
    uploaded_io = params[:picture]
    lang = params[:lang]
    path = Rails.root.join('tmp', uploaded_io.original_filename)
    tiff_path = Rails.root.join('tmp', 'text.tiff')
    text_path = Rails.root.join('tmp', 'text')
    text_with_extention = text_path.to_s + '.txt'
    File.open(path, 'wb') do |file|
      file.write(uploaded_io.read)
    end

    system("convert -depth 8 -density 300 #{path} #{tiff_path}")
    File.delete(path)
    #system("./lib/textcleaner -g #{tiff_path} #{tiff_path}")
    system("tesseract #{tiff_path} #{text_path} -l #{lang}")
    File.delete(tiff_path)
    if File.exist?(text_with_extention)
      @extracted_text = File.read(text_with_extention).to_s
      File.delete(text_with_extention)
    end
    render :index
  end

  private

  def set_shared_params
    @langs = %w[ara eng]
  end
end
