require 'net/http'
require 'json'

GitEvent = Struct.new(:type, :created_at)
GitUser = Struct.new(:name, :link, :gravatar, :score, :scores)
GitScore = Struct.new(:type, :score)

class HomeController < ApplicationController
  def index
  end

  def gitscore
  end

  def gitscored   
    url = 'https://api.github.com/users/' + params[:slug] + '/events/public';
    uri = URI(url)
    response = Net::HTTP.get(uri)
    response = JSON.parse(response)
    @events = Array.new
    @user = GitUser.new('Unkown', url, 'http://www.gravatar.com/avatar/?d=identicon', 0, {})
    
    eventScores = {
      "IssuesEvent" => 7,
      "IssueCommentEvent" => 6,
      "PushEvent" => 5,
      "PullRequestReviewCommentEvent" => 4,
      "WatchEvent" => 3,
      "CreateEvent" => 2,
      "OtherEvent" => 1
    }

    eventScores.each do |k,v|
      @user.scores[k] = 0
    end

    response.each do |event|
      tempEvent  = GitEvent.new(event['type'], event['created_at'])
      @events.push(tempEvent)
      
      if event['actor']['url']
        @user.link = event['actor']['url']
      end
      if event['actor']['avatar_url']
        @user.gravatar = event['actor']['avatar_url']
      end
      if event['actor']['display_login']
        @user.name = event['actor']['display_login']
      end
      
      # Calculate score
      if event['type']
        tempType = event['type'] 
        if @user.scores[tempType]
          @user.scores[tempType] += 1
          @user.score += eventScores[tempType]
        else 
          @user.scores['OtherEvent'] +=1
          @user.score += 1
        end
        
      end
    end

    puts @events
    puts @user
  end
end