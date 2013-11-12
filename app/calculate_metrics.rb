require	'open-uri'
require 'yajl'
require "debugger"
require "date"
require "erb"
 
start = Time.now
push_events_source = File.new('data/input/push-events-2013-04.json', 'r')

push_count_by_language = Hash.new(0)
commit_count_by_language = Hash.new(0)
push_by_language_by_repo = Hash.new(0)
push_count_by_hour = Hash.new(0)
push_count_by_weekday = Hash.new(0)
commits_with_swear_words = 0
total_commits = 0
push_count = 0

yajl = Yajl::Parser.new(:symbolize_keys => true)
yajl.parse(push_events_source) do |event|
  if event[:type] == "PushEvent" && !event[:repository].nil?
  	# some push events don't have an attached repository
  	# maybe these repos were deleted
	repo = event[:repository][:name]
	language = event[:repository][:language]
	commits = event[:payload][:size]
	date = DateTime.strptime(event[:repository][:pushed_at], "%Y-%m-%dT%H:%M:%S%z")
	
	commit_messages = event[:payload][:shas].map{|commit| commit[2].to_s}
	swear_count = commit_messages.map{|message| if message.match(/(shit|fuck|damn|crap|ass|bitch|hell)/) then 1 else 0 end}

	# seems like some repos don't have a reported language
	# let's keep track of those separately
	if language.nil? then language = "None" end
	push_count_by_language[language] += 1
	commit_count_by_language[language] += commits
	push_by_language_by_repo[language] = Hash.new(0) unless push_by_language_by_repo.has_key?(language)
	push_by_language_by_repo[language][repo] += 1
	push_count_by_hour[date.hour] += 1
	push_count_by_weekday[date.strftime("%A")] += 1
	commits_with_swear_words += swear_count.inject(:+).nil? ? 0 : swear_count.inject(:+)
	total_commits += commits
  end
  push_count += 1
end

# helpers for report template
class Helpers
	def number_with_delimiter(number, delimiter=",", separator=".")
		parts = number.to_s.split('.')
		parts[0].gsub!(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1#{delimiter}")
		parts.join separator
	end
	def div_id(str)
		str.gsub('_','-')
	end	
	def camel_case(str)
		str.split("_").each_with_index.map{|x,i| if i==0 then x else x.capitalize end}.join("")
	end
	def title(str)
		str.split("_").map{|x| x.capitalize}.join(" ")
	end
end

# prepare metrics for output
def keep_top(var, top = 19)
	new_var = Hash[var.sort_by{ |k, v| -v}].keep_if{ |k, v| var.keys.index(k) < top }
	new_var["Other"] = Hash[var.sort_by{ |k, v| -v}].keep_if{ |k, v| var.keys.index(k) >= top }.values.inject(:+)
	new_var
end

top_languages_by_push_count = keep_top(push_count_by_language)
top_languages_by_commits  = keep_top(commit_count_by_language)

repos = push_by_language_by_repo.values.each_with_index.map{|x, i| x.keys}.flatten
repo_pushes = push_by_language_by_repo.values.each_with_index{|x, i| x.values}.flatten
unique_repos_with_push_events = push_by_language_by_repo.values.map { |e| e.length  }.inject(:+)
swear_percent = (commits_with_swear_words.to_f / total_commits.to_f)
swear_data = [swear_percent.round(2), (1 - swear_percent).round(2)]


# generate static html file
helpers = Helpers.new
encoder = Yajl::Encoder.new
bar_chart_metrics = %w[top_languages_by_push_count top_languages_by_commits push_count_by_hour push_count_by_weekday]
template = ERB.new(File.read("views/github-push-events.html.erb"))
html_content = template.result(binding)
File.open("views/github-push-events.html", "w") do |file|
  file.puts html_content
end

# keep track of execution time
puts "Elapsed time: #{((Time.now - start)/30).round(2)} minutes"