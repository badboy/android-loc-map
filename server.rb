#!/usr/bin/env ruby
# encoding: utf-8

require 'sinatra'
require 'haml'
require 'json'
require 'stringio'

class App <  Sinatra::Base
  enable :inline_templates

  dir = File.dirname(__FILE__)
  set :public, "#{dir}/public"
  enable :static

  set :haml, {
    :format => :html5,
    :attr_wrapper => '"'
  }

  def parse_cache(data)
    data = StringIO.new(data) unless data.kind_of?(StringIO)
    db_version, db_total = data.read(4).unpack("nn")

    json_object = {}
    json_object[:info] = {}
    json_object[:info][:description] = "Android Location Cache"
    json_object[:info][:version] = db_version
    json_object[:info][:total] = db_total
    json_object[:data] = []

    0.upto(db_total-1) do |i|
      key = data.read(data.read(2).unpack("n").first)
      accuracy, confidence, latitude, longitude = data.read(24).unpack("NNGG")
      accuracy = accuracy == (2**32-1) ? -1 : accuracy
      readtime = data.read(8).reverse.unpack("Q").first

      readtime = Time.at(readtime / 1000.0).iso8601

      json_object[:data] << {
        :key        => key,
        :accuracy   => accuracy,
        :confidence => confidence,
        :latitude   => latitude,
        :longitude  => longitude,
        :readtime   => readtime
      }
    end

    json_object.to_json
  rescue Exception
    {}.to_json
  end

  get '/' do
    haml :index
  end

  get '/map' do
    @j = {}.to_json
    haml :upload
  end

  post '/map' do
    redirect '/' unless params[:data]
    datafile = params[:data]
    data = datafile[:tempfile].read

    redirect '/' if data.empty?

    @j = parse_cache(data)

    haml :upload
  end
end

__END__
@@ layout
!!!
%html
  %head
    %title Plot your Android Location Cache Data on Google Maps
    %link{:rel=>"stylesheet", :href=>"/style.css", :type=>"text/css", :media=>"screen"}
    %script{:src=>"http://ajax.googleapis.com/ajax/libs/jquery/1.5.2/jquery.min.js"}
    %script{:src=>"http://maps.google.com/maps/api/js?sensor=false"}
  %body
    = yield

    %div#footer
      %a{:href=>"https://twitter.com/badboy_"} @badboy_
      &dash;
      thx:
      %a{:href=>"https://github.com/markolson"} Mark Olson
      &
      %a{:href=>"https://github.com/williame"} William Edwards
      (iPhone Cache Data Map),
      %a{:href=>"https://github.com/packetlss/android-locdump"} Magnus Eriksson
      (android-locdump parser)
      &dash;
      %a{:href=>"http://github.com/badboy/android-loc-map/"} code on github
      &dash;
      %b Data is only uploaded to be parsed. Nothing is stored server-side!
  </div>

@@ index
%div.title Choose your cache file.

%form{:action=>"/map", :method=>"post", :enctype=>"multipart/form-data"}
  %input{:type=>"file", :name=>"data"}
  %input{:type=>"submit", :value=>"Send"}


@@ upload
%div#airlock
  %div.o#map_canvas

%div#footer
  %a{:href=>"..."} something

%script{:type=>"text/javascript"}
  window.cache_data = (
  = @j
  );

%script{:type=>"text/javascript", :src=>"/app.js"}
