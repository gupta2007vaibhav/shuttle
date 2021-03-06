module Shuttle
  module Helpers
    LEVEL_COLORS = {
      'info'    => :green,
      'warning' => :yellow,
      'error'   => :red
    }

    def log(message, level='info')
      prefix = "----->".send(LEVEL_COLORS[level])
      STDOUT.puts("#{prefix} #{message}")
    end

    def error(message)
      log("ERROR: #{message}", "error")
      log("Release v#{version} aborted", "error")
      
      raise DeployError, message
    end

    def warn(message)
      log("WARNING: #{message}", "warning")
    end

    def git_installed?
      ssh.run("which git").success?
    end

    def svn_installed?
      ssh.run("which svn").success?
    end

    def release_exists?
      ssh.directory_exists?(release_path)
    end

    def stream_output(buff)
      str = buff.split("\n").map { |str| "       #{str}"}.join("\n")
      STDOUT.puts(str)
    end

    def git_remote
      result = ssh.run("cd #{scm_path} && git remote -v")

      if result.success?
        result.output.scan(/^origin\t(.+)\s\(fetch\)/).flatten.first
      else
        nil
      end
    end

    def deployer_hostname
      `hostname`.strip
    end
  end
end