class HomeController < ApplicationController

  def index
    @extracted_text = ''
  end

  def ocr
    uploaded_io = params[:picture]
    dir = Rails.root.join('tmp')
    path = Rails.root.join('tmp', uploaded_io.original_filename)
    tiff_path = Rails.root.join('tmp', 'text.tiff')
    text_path = Rails.root.join('tmp', 'ara.txt')
    File.open(path, 'wb') do |file|
      file.write(uploaded_io.read)
    end
    system("convert -depth 8 -density 300 #{path} #{tiff_path}")
    File.delete(path)
    system("./lib/textcleaner -g #{tiff_path} #{tiff_path}")
    system("tesseract #{tiff_path} #{dir}/ara -l ara")
    File.delete(tiff_path)
    @extracted_text = File.read(text_path).to_s if File.exist?(text_path)
    File.delete(text_path)
    render :index
  end
end
