#! /usr/bin/env ruby
# coding: utf-8

require 'yaml'
require 'open3'

$resume = YAML.load_file('gingell.yaml')

def md(s)
  Open3.popen3("pandoc -f markdown -t latex") do |stdin, stdout, stderr, wait_thr|
    stdin.puts(s)
    stdin.close
    return stdout.read
  end
end

def itemize(is)
  is.map {|i| "\\item #{md(i)}\n"}.join
end

def list(is)
  <<END_OF_TEMPLATE
\\begin{itemize}
#{itemize(is)}
\\end{itemize}
END_OF_TEMPLATE
end

def subsection(ss)
  <<END_OF_TEMPLATE
\\begin{subsection}
{#{ss["what"]}}
{#{ss["when"]}}
{#{ss["role"]}}
{#{ss["where"]}}
#{itemize(ss["items"]) if ss["items"]}
\\end{subsection}
END_OF_TEMPLATE
end

def subsections(ss)
  ss.map{|e| subsection(e)}.join("\n")
end

def section(s)
  <<END_OF_TEMPLATE
\\begin{section}{#{s["heading"]}}
#{s["body"] if s["body"]}
#{subsections(s["subsections"]) if s["subsections"]}
#{list(s["items"]) if s["items"]}
\\end{section}
END_OF_TEMPLATE
end

def sections
  $resume["sections"].map{|s| section(s)}.join("\n")
end

template = <<END_OF_TEMPLATE
\\documentclass[10pt]{article}
\\input{theme.tex}
\\begin{document}
\\heading
{#{$resume["name"]}}
{#{$resume["email"]}}
{#{$resume["phone"]}}
{#{$resume["address"]}}
#{sections}
\\end{document}
END_OF_TEMPLATE

puts template
