defmodule Issues.Formatter do
  def output(github_issue_responses) do
    issues = github_issue_responses
    |> Enum.map(&extract/1)
    
    max_widthes = max_widthes(issues)

    show_header(max_widthes)
    show_body(max_widthes, issues)
  end

  def show_header([number_width, created_at_width, title_width]) do
    IO.puts(" #{String.pad_trailing("#", number_width)} | #{String.pad_trailing("created_at", created_at_width)} | #{String.pad_trailing("title", title_width)}")
    IO.puts(String.duplicate("-", 7 + number_width + created_at_width + title_width))
  end

  def show_body(max_widthes, issues) do
    Enum.map(issues, &(show_line(max_widthes, &1)))
  end

  def show_line(max_widthes, issue) do
    [number_width, created_at_width, title_width] = max_widthes
    [number, created_at, title] = issue
    IO.puts(" #{String.pad_trailing(number, number_width)} | #{String.pad_trailing(created_at, created_at_width)} | #{String.pad_trailing(title, title_width)}")
  end

  def max_widthes(issues) do
    Enum.map([0, 1, 2], &(extract_vertical(issues, &1)))
    |> Enum.map(&max_width/1)
  end

  def extract_vertical(issues, index) do
    Enum.map(issues, &(at(&1, index)))
  end

  def at(issue, index) do
    Enum.at(issue, index)
  end

  def extract(issue) do
    [Integer.to_string(issue["number"]), issue["created_at"], issue["title"]]
  end

  def max_width(words) do
    words
    |> Enum.map(&String.length/1)
    |> Enum.max
  end
end

# it works!

# [ifrita] ~/programming_elixiir/work/issues % mix run -e 'Issues.CLI.run(["jyllsarta", "stray"])'             
# Compiling 1 file (.ex)                                                                                       
#  #  | created_at           | title                                                                           
# --------------------------------------------------------------------                                         
#  33 | 2021-05-19T17:32:40Z | Bump puma from 4.3.7 to 4.3.8                                                   
#  34 | 2021-05-20T12:23:44Z | Bump nokogiri from 1.11.3 to 1.11.5                                             
#  35 | 2021-05-25T23:34:05Z | Bump browserslist from 4.16.3 to 4.16.6                                         
#  36 | 2021-05-28T10:15:41Z | Bump dns-packet from 1.3.1 to 1.3.4                                             
