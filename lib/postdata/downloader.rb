# coding: utf-8
require 'open-uri'

module Postdata
  class Downloader
    KEN_ALL_PAGE_URL = 'http://www.post.japanpost.jp/zipcode/dl/oogaki-zip.html'
    KEN_ALL_ZIP_URL = 'http://www.post.japanpost.jp/zipcode/dl/oogaki/zip/ken_all.zip'

    JIGYOSYO_PAGE_URL = 'http://www.post.japanpost.jp/zipcode/dl/jigyosyo/index-zip.html'
    JIGYOSYO_ZIP_URL = 'http://www.post.japanpost.jp/zipcode/dl/jigyosyo/zip/jigyosyo.zip'

    def self.heisei_to_seireki(heisei)
      2000 + heisei.to_i - 12
    end

    def self.format_month_or_day(str)
      if str.length < 2
        return '0' + str
      end
      str
    end

    def self.get_update_date(url)
      content = open(url, "r:UTF-8").read
      if content !~ /<p><small>平成(\d+)年\s*(\d+)月\s*(\d+)日更[^<]*<\/small><\/p>/u
        raise RuntimeError, "更新日が取得できません";
      end
      heisei = $1
      month = $2
      day = $3
      year = heisei_to_seireki(heisei).to_s

      ymd = year + format_month_or_day(month) + format_month_or_day(day)
      if (ymd.length != 8)
        raise RuntimeError, "日付が不正です: #{ymd}"
      end
      ymd
    end

    def self.download(url, file, force_download, logger)
      msg = "Download #{url} -> #{file}"
      use_cache = !force_download && FileTest.file?(file)
      if use_cache
        msg << " File exists."
      else
        open(url) do |http|
          File.open(file, 'wb') do |f|
            f.write(http.read)
          end
        end
      end
      msg << " Done."
      logger.info(msg) if logger
    end

    def self.download_all(dir = '', force_download = false, logger = nil)
      zip_ymd =  get_update_date(KEN_ALL_PAGE_URL)
      zip_filename = dir + "/ken_all_#{zip_ymd}.zip"
      download(KEN_ALL_ZIP_URL, zip_filename, force_download, logger)

      jigyo_ymd = get_update_date(JIGYOSYO_PAGE_URL)
      jigyo_filename = dir + "/jigyosyo_#{jigyo_ymd}.zip"
      download(JIGYOSYO_ZIP_URL, jigyo_filename, force_download, logger)
      return zip_filename, zip_ymd, jigyo_filename, jigyo_ymd
    end
  end
end
