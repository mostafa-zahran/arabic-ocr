class HomeController < ApplicationController

  def index
    @extracted_text = ''
  end

  def ocr
    uploaded_io = params[:picture]
    dir = Rails.root.join('tmp')
    path = Rails.root.join('tmp', uploaded_io.original_filename)
    File.open(path, 'wb') do |file|
      file.write(uploaded_io.read)
      tiff_path = "#{File.split(path).first}/text.tiff"
      text_path = "#{dir}/ara.txt"
      system("convert -depth 8 -density 300 #{path} #{tiff_path}")
      system("./lib/textcleaner -g #{tiff_path} #{tiff_path}")
      system("tesseract #{tiff_path} #{dir}/ara -l ara")
      @extracted_text = File.read(text_path).to_s if File.exist?(text_path)
      File.delete(path)
      File.delete(tiff_path)
      File.delete(text_path)
    end
    render :index
  end
end
