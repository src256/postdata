require "postdata/version"
require "postdata/downloader"

module Postdata
  def self.download(dir = '', force_download = false, logger = nil)
    Postdata::Downloader.download_all(dir, force_download, logger)
  end
end

