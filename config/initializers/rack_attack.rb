class Rack::Attack
  # Block suspicious requests for '/etc/password' or wordpress specific paths.
  # After 3 blocked requests in 10 minutes, block all requests from that IP for 5 minutes.
  blocklist('fail2ban pentesters') do |req|
    # `filter` returns truthy value if request fails, or if it's from a previously banned IP
    # so the request is blocked
    Fail2Ban.filter("pentesters-#{req.ip}", maxretry: 3, findtime: 10.minutes, bantime: 5.minutes) do
      # The count for the IP is incremented if the return value is truthy
      CGI.unescape(req.query_string) =~ %r{/etc/passwd} ||
      req.path.include?('/etc/passwd') ||
      req.path.include?('wp-admin') ||
      req.path.include?('wp-login')
    end
  end

  unless ENV['DISABLE_THROTTLE'] == 'true'
    throttle('req/ip/api', :limit => 60 * 5, :period => 5.minutes) do |req|
      if req.path.starts_with?('/api/v1/')
        req.ip
      end
    end

    throttle('req/ip/api/emails', :limit => 5, :period => 1.hours) do |req|
      if req.path.starts_with?('/api/v1/emails')
        req.ip
      end
    end

    self.throttled_response = lambda do |env|
      now = Time.now
      match_data = env['rack.attack.match_data']

      headers = {
        'X-RateLimit-Limit' => match_data[:limit].to_s,
        'X-RateLimit-Remaining' => '0',
        'X-RateLimit-Reset' => (now + (match_data[:period] - now.to_i % match_data[:period])).to_s,
        'Content-Type' => 'application/json'
      }

      return [429, headers, ['{"message": "Too Many Requests. Retry Later."}']]
    end
  end
end
