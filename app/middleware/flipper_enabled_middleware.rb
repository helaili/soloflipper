class FlipperEnabledMiddleware
  @@admins = ["helaili", "octocat"]
  @@early = ["alain"]
  @@marketing = ["darth", "obiwan"]


  def self.admins
    @@admins
  end

  def self.early
    @@early
  end

  def self.marketing
    @@marketing
  end

  class FlipperActor
    attr_reader :flipper_id

    def admin?
      FlipperEnabledMiddleware::admins.include? @flipper_id
    end

    def early?
      FlipperEnabledMiddleware::early.include? @flipper_id
    end

    def marketing?
      FlipperEnabledMiddleware::marketing.include? @flipper_id
    end

    def initialize(flipper_id)
      @flipper_id = flipper_id
    end
  end



  def initialize(app, flipper)
    @app = app
    @flipper = flipper
  end

  def call(env)
    request = Rack::Request.new(env)

    puts "flipper-enabled!!!!"

    puts request.path
    if request.path == "/flipper-enabled"

      headers = {"Content-Type" => "application/json"}
      flipper_id = request.params["flipper_id"]
      featureName = request.params["feature"]
      puts flipper_id
      puts featureName
      enabled = if flipper_id.nil? || flipper_id.empty? || featureName.nil? || featureName.empty?
          false
        else
          feature = @flipper[featureName]
          if feature.nil?
            false
          else
            feature.enabled?(FlipperActor.new(flipper_id))
          end
        end


      body = JSON.generate({enabled: enabled})
      [200, headers, [body]]
    else
      @app.call(env)
    end
  end
end
