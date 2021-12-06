# frozen_string_literal: true
require 'faraday'
require 'nokogiri'
require 'fileutils'
require 'ostruct'

# template for a problem
class AOC
  BASE_URL = 'https://adventofcode.com'
  APP_ROOT = File.dirname(__FILE__)
  CONFIG   = {
    files: {
      problem_file: 'README.md',
      data_file: 'data.txt',
      example_file: 'example.txt',
      solution_file: 'main.rb'
    }
  }.freeze

  attr_accessor :problem

  def self.auth(cookie)
    File.open(File.join(APP_ROOT, '.cookie'), 'w+') do |cf|
      cf.puts cookie
    end
  end

  def initialize(year, day)
    load_template(year, day)
  end

  private

  def load_template(year, day)
    set_time_records(year, day)
    create_files
    fetch_problem
    parse_problem
    fetch_input
    write_files
    close_files
  end

  def set_time_records(year_input = nil, day_input = nil)
    @year = year_input || Time.now.year.to_s
    @day  = day_input || Time.now.day.to_s
  end

  def create_files
    @problem_dir = File.join(APP_ROOT, @year, "day#{@day}")
    FileUtils.mkdir_p(@problem_dir)
    CONFIG[:files].map do |file_type, file_name|
      instance_variable_set(
        "@#{file_type}",
        File.open(
          File.join(@problem_dir, file_name),
          'w+'
        )
      )
    end
  end

  def fetch_input
    @fetch_input ||= api_client.get(input_url) do |req|
      request_headers.each do |header, value|
        req.headers[header] = value
      end
    end.body
  end

  def fetch_problem
    @fetch_problem ||= api_client.get(problem_url) do |req|
      request_headers.each do |header, value|
        req.headers[header] = value
      end
    end.body
  end

  def parse_problem
    @problem = ::OpenStruct.new
    @problem_document = Nokogiri::HTML(fetch_problem)
    parse_problem_title
    parse_problem_example
    parse_problem_body
  end

  def solution_template
    <<-RUBY
    class #{problem_class}
      def data
        @data ||= ARGF.readlines
      end
    end
    RUBY
  end

  def write_files
    @data_file.puts(fetch_input)
    @problem_file.puts(@problem.body)
    @example_file.puts(@problem.example)
    @solution_file.puts(solution_template)
  end

  def close_files
    CONFIG[:files].keys.map do |file_var|
      file = instance_variable_get("@#{file_var}")
      file.close
    end
  end

  def api_client
    @api_client ||= Faraday.new(url: BASE_URL)
  end

  def request_headers
    {
      'authority' => 'adventofcode.com',
      'cache-control' => 'max-age=0',
      'upgrade-insecure-requests' => '1',
      'sec-fetch-site' => 'same-origin',
      'sec-fetch-mode' => 'navigate',
      'sec-fetch-user' => '?1', 'sec-fetch-dest' => 'document',
      'referer' => "https://adventofcode.com#{input_url}",
      'cookie' => "session=#{cookie}"
    }
  end

  def input_url
    "/#{@year}/day/#{@day}/input"
  end

  def parse_problem_title
    @problem.title = @problem_document.css('.day-desc > h2')[0].text
  end

  def parse_problem_body
    @problem.body = @problem_document.css('.day-desc').text
  end

  def parse_problem_example
    statements          = @problem_document.css('.day-desc p, .day-desc pre')
    @problem.example    = statements.each_with_index.find do |statement, index|
      statement.name == 'pre' &&
        !statements[index.pred].text.match(/(example|Example)/).nil?
    end&.first&.text
  end

  def problem_class
    @problem.title.split(':').last.match(/[a-zA-Z\s+]+/).to_s.strip.delete(' ')
  end

  def cookie
    @cookie ||= File.open(File.join(APP_ROOT, '.cookie'), 'r').read
  end

  def problem_url
    "/#{@year}/day/#{@day}"
  end
end
