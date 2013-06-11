working_directory '/vagrant'
pid '/vagrant/tmp/pids/unicorn.pid'
stderr_path '/vagrant/log/unicorn.log'
stdout_path '/vagrant/log/unicorn.log'

listen '/tmp/unicorn.todo.sock'
worker_processes 2
timeout 30

before_fork do |server, worker|
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!
end
