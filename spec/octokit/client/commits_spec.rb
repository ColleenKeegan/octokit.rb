require File.expand_path('../../../spec_helper.rb', __FILE__)

describe Octokit::Client::Commits do

  before do
    Octokit.reset!
    VCR.insert_cassette 'commits', :match_requests_on => [:method, :uri, :query]
  end

  after do
    VCR.eject_cassette
  end

  describe ".commits" do
    it "returns all commits" do
      commits = Octokit.commits("sferik/rails_admin")
      commits.first.author.wont_be_nil
      assert_requested :get, github_url("/repos/sferik/rails_admin/commits")
    end
    it "handles branch or sha argument" do
      commits = Octokit.commits("sferik/rails_admin", "master")
      assert_requested :get, github_url("/repos/sferik/rails_admin/commits?sha=master")
    end
    it "handles the sha option" do
      commits = Octokit.commits("sferik/rails_admin", :sha => "master")
      assert_requested :get, github_url("/repos/sferik/rails_admin/commits?sha=master")
    end
  end # .commits

  describe ".commits_on" do
    it "returns all commits on the specified date" do
      commits = Octokit.commits_on("sferik/rails_admin", "2011-01-20")
      commits.must_be_kind_of Array
      assert_requested :get, github_url("/repos/sferik/rails_admin/commits?since=2011-01-20&until=2011-01-21")
    end
    it "errors if the date is invalid" do
      assert_raises(ArgumentError) { Octokit.commits_on "sferik/rails_admin", "A pear" }
    end
    it "handles branch or sha argument" do
      commits = Octokit.commits_on("sferik/rails_admin", "2011-01-15", "master")
      assert_requested :get, github_url("/repos/sferik/rails_admin/commits?sha=master&since=2011-01-15&until=2011-01-16")
    end
    it "handles the sha option" do
      commits = Octokit.commits_on("sferik/rails_admin", "2011-01-15", :sha => "master")
      assert_requested :get, github_url("/repos/sferik/rails_admin/commits?sha=master&since=2011-01-15&until=2011-01-16")
    end
  end # .commits_on

  describe ".commits_since" do
    it "returns all commits since the specified date" do
      commits = Octokit.commits_since("sferik/rails_admin", "2011-01-20")
      commits.must_be_kind_of Array
      assert_requested :get, github_url("/repos/sferik/rails_admin/commits?since=2011-01-20")
    end
    it "errors if the date is invalid" do
      assert_raises(ArgumentError) { Octokit.commits_since "sferik/rails_admin", "A pear" }
    end
    it "handles branch or sha argument" do
      commits = Octokit.commits_since("sferik/rails_admin", "2011-01-15", "master")
      assert_requested :get, github_url("/repos/sferik/rails_admin/commits?sha=master&since=2011-01-15")
    end
    it "handles the sha option" do
      commits = Octokit.commits_since("sferik/rails_admin", "2011-01-15", :sha => "master")
      assert_requested :get, github_url("/repos/sferik/rails_admin/commits?sha=master&since=2011-01-15")
    end
  end # .commits_since

  describe ".commits_before" do
    it "returns all commits until the specified date" do
      commits = Octokit.commits_before("sferik/rails_admin", "2011-01-20")
      commits.must_be_kind_of Array
      assert_requested :get, github_url("/repos/sferik/rails_admin/commits?until=2011-01-20")
    end
    it "errors if the date is invalid" do
      assert_raises(ArgumentError) { Octokit.commits_before "sferik/rails_admin", "A pear" }
    end
    it "handles branch or sha argument" do
      commits = Octokit.commits_before("sferik/rails_admin", "2011-01-15", "master")
      assert_requested :get, github_url("/repos/sferik/rails_admin/commits?sha=master&until=2011-01-15")
    end
    it "handles the sha option" do
      commits = Octokit.commits_before("sferik/rails_admin", "2011-01-15", :sha => "master")
      assert_requested :get, github_url("/repos/sferik/rails_admin/commits?sha=master&until=2011-01-15")
    end
  end # .commits_before

  describe ".commits_between" do
    it "returns all commits until the specified date" do
      commits = Octokit.commits_between("sferik/rails_admin", "2011-01-20", "2013-01-20")
      commits.must_be_kind_of Array
      assert_requested :get, github_url("/repos/sferik/rails_admin/commits?since=2011-01-20&until=2013-01-20")
    end
    it "errors if the date is invalid" do
      assert_raises(ArgumentError) { Octokit.commits_between "sferik/rails_admin", "A pear" }
    end
    it "handles branch or sha argument" do
      commits = Octokit.commits_between("sferik/rails_admin", "2011-01-20", "2013-01-20", "master")
      assert_requested :get, github_url("/repos/sferik/rails_admin/commits?sha=master&since=2011-01-20&until=2013-01-20")
    end
    it "handles the sha option" do
      commits = Octokit.commits_between("sferik/rails_admin", "2011-01-20", "2013-01-20", :sha => "master")
      assert_requested :get, github_url("/repos/sferik/rails_admin/commits?sha=master&since=2011-01-20&until=2013-01-20")
    end
  end # .commits_between

  describe ".commit" do
    it "returns a commit" do
      commit = Octokit.client.commit("sferik/rails_admin", "3cdfabd973bc3caac209cba903cfdb3bf6636bcd")
      commit.author.login.must_equal 'caboteria'
      assert_requested :get, github_url("/repos/sferik/rails_admin/commits/3cdfabd973bc3caac209cba903cfdb3bf6636bcd")
    end
  end # .commit

  describe ".create_commit" do
    it "creates a commit" do
      client = basic_auth_client
      commit = client.create_commit("pengwynn/api-sandbox", "My commit message", "827efc6d56897b048c772eb4087f854f46256132", "7d1b31e74ee336d15cbd21741bc88a537ed063a0")
      assert_requested :post, basic_github_url("/repos/pengwynn/api-sandbox/git/commits")
    end
  end # .create_commit

  describe ".merge" do
    it "merges a branch into another" do
      client = basic_auth_client
      merge = client.merge("pengwynn/api-sandbox", "master", "new-branch", :commit_message => "Testing the merge API")
      assert_requested :post, basic_github_url("/repos/pengwynn/api-sandbox/merges")
    end
  end # .merge
end
